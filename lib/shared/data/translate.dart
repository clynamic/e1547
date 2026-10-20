import 'package:dio/dio.dart';

/// Free translation service used to translate post content (descriptions,
/// tags) into Chinese.
///
/// Primary backend is the public Google Translate endpoint (no API key
/// required). If it is unreachable, MyMemory is used as a fallback.
class Translator {
  Translator._();

  static final Dio _dio = Dio(
    BaseOptions(
      connectTimeout: const Duration(seconds: 10),
      receiveTimeout: const Duration(seconds: 10),
    ),
  );

  static const String _target = 'zh-CN';

  static final Map<String, String> _cache = {};

  /// Translates [text] into Chinese. Returns `null` on failure.
  static Future<String?> translate(String text) async {
    final String source = text.trim();
    if (source.isEmpty) {
      return null;
    }
    final String? cached = _cache[source];
    if (cached != null) {
      return cached;
    }
    String? result = await _google(source);
    result ??= await _myMemory(source);
    if (result == null || result.trim().isEmpty) {
      return null;
    }
    _cache[source] = result.trim();
    return _cache[source];
  }

  /// Translates multiple independent strings and returns a map from source
  /// text to translation. Entries that could not be translated are simply
  /// missing from the result. Never throws.
  static Future<Map<String, String>> translateAll(Iterable<String> texts) async {
    final List<String> targets = texts
        .map((e) => e.trim())
        .where((e) => e.isNotEmpty)
        .toSet()
        .where((e) => !_cache.containsKey(e))
        .toList();
    final Map<String, String> result = {};
    if (targets.isEmpty) {
      return result;
    }

    // Try to translate everything in one batched request by joining with
    // newlines.
    final String? batched = await _google(targets.join('\n'));
    if (batched != null) {
      final List<String> lines = batched.split('\n');
      if (lines.length == targets.length) {
        for (int i = 0; i < targets.length; i++) {
          if (lines[i].trim().isNotEmpty) {
            _cache[targets[i]] = lines[i].trim();
          }
        }
      }
    }

    // Anything left (batch failed or line mismatch) is translated
    // individually.
    for (final String target in targets) {
      if (!_cache.containsKey(target)) {
        final String? one = await translate(target);
        if (one != null) {
          _cache[target] = one;
        }
      }
    }

    for (final String target in targets) {
      final String? cached = _cache[target];
      if (cached != null) {
        result[target] = cached;
      }
    }
    return result;
  }

  /// Public Google Translate endpoint. Joins sentence parts of the response.
  static Future<String?> _google(String text) async {
    try {
      final Response<dynamic> response = await _dio.get<dynamic>(
        'https://translate.googleapis.com/translate_a/single',
        queryParameters: {
          'client': 'gtx',
          'sl': 'auto',
          'tl': _target,
          'dt': 't',
          'q': text,
        },
      );
      final dynamic data = response.data;
      if (data is List && data.isNotEmpty && data[0] is List) {
        final StringBuffer buffer = StringBuffer();
        for (final dynamic part in data[0] as List) {
          if (part is List && part.isNotEmpty && part[0] is String) {
            buffer.write(part[0] as String);
          }
        }
        final String result = buffer.toString();
        return result.isEmpty ? null : result;
      }
      return null;
    } on Exception catch (_) {
      return null;
    }
  }

  /// MyMemory fallback. The free API limits queries to 500 bytes, so longer
  /// texts are split into chunks along line boundaries.
  static Future<String?> _myMemory(String text) async {
    try {
      final List<String> chunks = _split(text, 450);
      final StringBuffer buffer = StringBuffer();
      for (final String chunk in chunks) {
        final Response<dynamic> response = await _dio.get<dynamic>(
          'https://api.mymemory.translated.net/get',
          queryParameters: {'q': chunk, 'langpair': 'en|$_target'},
        );
        final dynamic data = response.data;
        final dynamic responseData = data is Map ? data['responseData'] : null;
        final dynamic translated = responseData is Map
            ? responseData['translatedText']
            : null;
        if (translated is! String || translated.trim().isEmpty) {
          return null;
        }
        buffer.write(translated);
      }
      final String result = buffer.toString();
      return result.isEmpty ? null : result;
    } on Exception catch (_) {
      return null;
    }
  }

  static List<String> _split(String text, int maxLength) {
    if (text.length <= maxLength) {
      return [text];
    }
    final List<String> chunks = [];
    final List<String> lines = text.split('\n');
    StringBuffer current = StringBuffer();
    for (final String line in lines) {
      if (current.length + line.length + 1 > maxLength) {
        if (current.isNotEmpty) {
          chunks.add(current.toString());
          current = StringBuffer();
        }
        if (line.length > maxLength) {
          // Hard-split very long lines.
          for (int i = 0; i < line.length; i += maxLength) {
            chunks.add(line.substring(i, i + maxLength > line.length ? line.length : i + maxLength));
          }
          continue;
        }
      }
      if (current.isNotEmpty) {
        current.write('\n');
      }
      current.write(line);
    }
    if (current.isNotEmpty) {
      chunks.add(current.toString());
    }
    return chunks;
  }
}
