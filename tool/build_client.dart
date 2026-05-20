// Spec → Dart codegen pipeline for the e621 HTTP client.
//
// 1. Loads lib/client/api.yaml.
// 2. Strips response variants per the chosen API version (v1 default, v2
//    optional). The unselected variants would otherwise pollute return types
//    with `dynamic` via `oneOf`.
// 3. Invokes swagger_parser's library API in-process (no temp file, no
//    subprocess).
// 4. Writes each generated file under lib/client/generated/.
// 5. Emits model files for component schemas that swagger_parser references
//    but does not write (a known quirk for parameter-only `$ref` chains).
// 6. Optionally chains build_runner to produce .g.dart / .freezed.dart.
//
// Usage:
//   dart run tool/build_client.dart                    # v1 (default)
//   dart run tool/build_client.dart --variant=v2       # v2 (basic mode)
//   dart run tool/build_client.dart --no-build-runner  # skip the final step

import 'dart:io';

import 'package:swagger_parser/swagger_parser.dart';
import 'package:yaml/yaml.dart';
import 'package:yaml_writer/yaml_writer.dart';

const sourceSpec = 'lib/client/api.yaml';
const generatedDir = 'lib/client/generated';

Future<void> main(List<String> args) async {
  final variant = _argValue(args, '--variant') ?? 'v1';
  if (variant != 'v1' && variant != 'v2') {
    stderr.writeln('error: --variant must be v1 or v2 (got "$variant")');
    exit(64);
  }
  final runBuildRunner = !args.contains('--no-build-runner');

  stderr.writeln('reading $sourceSpec');
  final spec =
      _toMutable(loadYaml(File(sourceSpec).readAsStringSync()))
          as Map<String, dynamic>;

  stderr.writeln('keeping $variant variants');
  _stripVariant(spec, keep: variant);

  if (Directory(generatedDir).existsSync()) {
    Directory(generatedDir).deleteSync(recursive: true);
  }
  Directory(generatedDir).createSync(recursive: true);

  stderr.writeln('generating client');
  const config = SWPConfig(
    outputDirectory: generatedDir,
    rootClient: false,
    includeTags: [
      'posts',
      'favorites',
      'post_votes',
      'post_flags',
      'users',
      'tags',
      'tag_aliases',
      'wiki_pages',
      'comments',
      'pools',
      'forum_topics',
      'forum_posts',
      'tickets',
    ],
  );

  final transformed = YamlWriter().write(spec);
  const processor = GenProcessor(config);
  final files = await processor.generateContent((
    fileContent: transformed,
    isJson: false,
  ));

  // swagger_parser sometimes emits multiple GeneratedFile entries with the
  // same `name`. Last write wins to match what the CLI does on disk.
  final collapsed = <String, String>{};
  for (final file in files) {
    collapsed[file.name] = file.content;
  }
  for (final entry in collapsed.entries) {
    final path = '$generatedDir/${entry.key}';
    final file = File(path)..parent.createSync(recursive: true);
    file.writeAsStringSync(entry.value);
  }
  stderr.writeln('wrote ${collapsed.length} swagger_parser file(s)');

  final missing = _emitMissingModels(spec);
  var written = 0;
  for (final entry in missing.entries) {
    final path = '$generatedDir/${entry.key}';
    if (File(path).existsSync()) {
      stderr.writeln('  skipped (already on disk): ${entry.key}');
      continue;
    }
    final file = File(path)..parent.createSync(recursive: true);
    file.writeAsStringSync(entry.value);
    written++;
    stderr.writeln('  wrote: ${entry.key}');
  }
  stderr.writeln(
    'considered ${missing.length} enum schema(s); wrote $written',
  );

  final renamed = _fixupBracketParams();
  stderr.writeln('renamed $renamed bracket parameter(s)');

  if (runBuildRunner) {
    stderr.writeln('running build_runner');
    await _run('flutter', [
      'pub',
      'run',
      'build_runner',
      'build',
      '--delete-conflicting-outputs',
    ]);
  }

  stderr.writeln('done.');
}

String? _argValue(List<String> args, String flag) {
  for (final a in args) {
    if (a.startsWith('$flag=')) return a.substring(flag.length + 1);
  }
  final i = args.indexOf(flag);
  if (i >= 0 && i + 1 < args.length) return args[i + 1];
  return null;
}

Future<void> _run(String executable, List<String> arguments) async {
  final process = await Process.start('cmd', [
    '/c',
    executable,
    ...arguments,
  ], mode: ProcessStartMode.inheritStdio);
  final code = await process.exitCode;
  if (code != 0) {
    stderr.writeln('$executable ${arguments.join(' ')} failed (exit $code)');
    exit(code);
  }
}

// --- variant strip ---

bool _refContainsV2(dynamic value) =>
    value is String && value.contains('PostV2');

bool _isV2Variant(dynamic item) {
  if (item is! Map) return false;
  if (_refContainsV2(item[r'$ref'])) return true;
  final items = item['items'];
  if (items is Map && _refContainsV2(items[r'$ref'])) return true;
  final desc = item['description'];
  if (desc is String &&
      RegExp(r'^(v2 |Unwrapped)', caseSensitive: false).hasMatch(desc)) {
    return true;
  }
  return false;
}

bool _isAlternateV2Mode(dynamic item) {
  if (item is! Map) return false;
  final desc = item['description'];
  if (desc is! String) return false;
  return RegExp(
    r'^v2 (extended|thumbnail)',
    caseSensitive: false,
  ).hasMatch(desc);
}

bool _isLegacyVariant(dynamic item) {
  if (item is! Map) return false;
  final desc = item['description'];
  return desc is String && desc.toLowerCase().startsWith('legacy');
}

dynamic _unwrapSingleArrayProp(dynamic item) {
  if (item is! Map<String, dynamic>) return item;
  if (item['type'] != 'object') return item;
  final props = item['properties'];
  if (props is! Map<String, dynamic> || props.length != 1) return item;
  final prop = props.values.first;
  if (prop is Map<String, dynamic> && prop['type'] == 'array') return prop;
  return item;
}

bool _shouldStrip(dynamic item, String keep) {
  if (keep == 'v1') return _isV2Variant(item);
  return _isLegacyVariant(item) || _isAlternateV2Mode(item);
}

void _stripVariant(Map<String, dynamic> spec, {required String keep}) {
  _stripWalk(spec, keep);
  if (keep == 'v1') {
    final components = spec['components'];
    if (components is Map<String, dynamic>) {
      for (final key in ['schemas', 'parameters']) {
        final collection = components[key];
        if (collection is Map<String, dynamic>) {
          collection.removeWhere((name, _) => name.startsWith('PostV2'));
        }
      }
    }
  }
}

dynamic _stripWalk(dynamic node, String keep) {
  if (node is List) {
    for (var i = 0; i < node.length; i++) {
      node[i] = _stripWalk(node[i], keep);
    }
    return node;
  }
  if (node is! Map<String, dynamic>) return node;

  final oneOf = node['oneOf'];
  if (oneOf is List && oneOf.any((i) => _shouldStrip(i, keep))) {
    var kept = oneOf.where((item) => !_shouldStrip(item, keep)).toList();
    if (keep == 'v1') {
      kept = kept.map(_unwrapSingleArrayProp).toList();
    }
    final walked = kept.map((i) => _stripWalk(i, keep)).toList();
    if (walked.length == 1) {
      final replacement = walked.first;
      if (replacement is Map<String, dynamic>) return replacement;
      return replacement;
    }
    node['oneOf'] = walked;
    return node;
  }

  final params = node['parameters'];
  if (params is List) {
    params.removeWhere(
      (p) => p is Map<String, dynamic> && _refContainsV2(p[r'$ref']),
    );
  }

  for (final key in node.keys.toList()) {
    node[key] = _stripWalk(node[key], keep);
  }
  return node;
}

// --- bracket-param rename ---
//
// swagger_parser fails to make Dart identifiers out of query parameter names
// that contain brackets (`search[foo_bar]` etc.), falling back to `objectN`.
// It does generate sensible camelCased names in the doc comments, but never
// uses them in the actual parameter list. Rewrite the function signature so
// the param names match what the docs already promise.

int _fixupBracketParams() {
  final clientFiles = Directory(generatedDir)
      .listSync(recursive: true)
      .whereType<File>()
      .where((f) => f.path.endsWith('_client.dart'));

  final pattern = RegExp(
    r"(@Query\('([^']+)'\))(\s+)([\w<>?, ]+?)\s+object\d+,",
  );

  var total = 0;
  for (final file in clientFiles) {
    final content = file.readAsStringSync();
    final updated = content.replaceAllMapped(pattern, (m) {
      final annotation = m.group(1)!;
      final queryName = m.group(2)!;
      final space = m.group(3)!;
      final type = m.group(4)!;
      final dartName = _camel(queryName);
      total++;
      return '$annotation$space$type $dartName,';
    });
    if (updated != content) file.writeAsStringSync(updated);
  }
  return total;
}

// --- missing-model emit ---

Map<String, String> _emitMissingModels(Map<String, dynamic> spec) {
  final out = <String, String>{};
  final components = spec['components'];
  if (components is! Map<String, dynamic>) return out;
  final schemas = components['schemas'];
  if (schemas is! Map<String, dynamic>) return out;

  for (final entry in schemas.entries) {
    final name = entry.key;
    final schema = entry.value;
    if (schema is! Map<String, dynamic>) continue;
    final source = _renderSchema(name, schema);
    if (source == null) continue;
    out['models/${_snake(name)}.dart'] = source;
  }
  return out;
}

String? _renderSchema(String name, Map<String, dynamic> schema) {
  final values = schema['enum'];
  if (values is List && values.isNotEmpty) return _renderEnum(name, schema);
  return null;
}

String _renderEnum(String name, Map<String, dynamic> schema) {
  final values = (schema['enum'] as List).cast<dynamic>();
  final isString = schema['type'] == 'string' || schema['type'] == null;
  final dartType = isString ? 'String' : 'int';
  final variantLines = <String>[];
  final usedNames = <String>{};
  for (final value in values) {
    final variantName = _variantName(value.toString(), usedNames);
    usedNames.add(variantName);
    final literal = isString ? "'$value'" : '$value';
    variantLines.add('  @JsonValue($literal)\n  $variantName($literal),');
  }

  return '''
// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import, invalid_annotation_target, unnecessary_import

import 'package:json_annotation/json_annotation.dart';

@JsonEnum()
enum $name {
${variantLines.join('\n')}
  /// Default value for all unparsed values, allows backward compatibility when adding new values on the backend.
  \$unknown(null);

  const $name(this.json);

  factory $name.fromJson($dartType json) => values.firstWhere(
        (e) => e.json == json,
        orElse: () => \$unknown,
      );

  final $dartType? json;

  @override
  String toString() => json?.toString() ?? super.toString();
  /// Returns all defined enum values excluding the \$unknown value.
  static List<$name> get \$valuesDefined => values.where((value) => value != \$unknown).toList();
}
''';
}

// --- utilities ---

final _dartKeywords = {
  'abstract',
  'as',
  'assert',
  'async',
  'await',
  'break',
  'case',
  'catch',
  'class',
  'const',
  'continue',
  'default',
  'deferred',
  'do',
  'dynamic',
  'else',
  'enum',
  'export',
  'extends',
  'extension',
  'external',
  'factory',
  'false',
  'final',
  'finally',
  'for',
  'function',
  'get',
  'hide',
  'if',
  'implements',
  'import',
  'in',
  'interface',
  'is',
  'library',
  'mixin',
  'new',
  'null',
  'on',
  'operator',
  'part',
  'rethrow',
  'return',
  'set',
  'show',
  'static',
  'super',
  'switch',
  'sync',
  'this',
  'throw',
  'true',
  'try',
  'typedef',
  'var',
  'void',
  'while',
  'with',
  'yield',
};

String _variantName(String raw, Set<String> taken) {
  final camel = _camel(raw);
  final base = camel.isEmpty || _isDigit(camel[0]) ? 'value$camel' : camel;
  var name = base;
  if (_dartKeywords.contains(name)) name = 'value${_pascal(raw)}';
  var n = 2;
  while (taken.contains(name)) {
    name = '$base$n';
    n++;
  }
  return name;
}

bool _isDigit(String c) => c.codeUnitAt(0) >= 0x30 && c.codeUnitAt(0) <= 0x39;

String _camel(String s) {
  final p = _pascal(s);
  return p.isEmpty ? p : p[0].toLowerCase() + p.substring(1);
}

String _pascal(String s) {
  final buf = StringBuffer();
  var upper = true;
  for (final ch in s.split('')) {
    final isAlnum = RegExp(r'[A-Za-z0-9]').hasMatch(ch);
    if (isAlnum) {
      buf.write(upper ? ch.toUpperCase() : ch);
      upper = false;
    } else {
      upper = true;
    }
  }
  return buf.toString();
}

String _snake(String name) {
  final buf = StringBuffer();
  for (var i = 0; i < name.length; i++) {
    final ch = name[i];
    if (i > 0 && ch.toUpperCase() == ch && ch.toLowerCase() != ch) {
      buf.write('_');
    }
    buf.write(ch.toLowerCase());
  }
  return buf.toString();
}

dynamic _toMutable(dynamic node) {
  if (node is YamlMap) {
    return {
      for (final e in node.entries) e.key.toString(): _toMutable(e.value),
    };
  }
  if (node is YamlList) {
    return [for (final e in node) _toMutable(e)];
  }
  return node;
}
