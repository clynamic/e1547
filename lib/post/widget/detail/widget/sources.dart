import 'package:e1547/app/app.dart';
import 'package:e1547/post/post.dart';
import 'package:e1547/shared/shared.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

bool isSourceFile(Uri uri) => RegExp(
  r'\.(jpe?g|png|gif|webp|webm|mp4|swf)$',
  caseSensitive: false,
).hasMatch(uri.path);

class PostSourcesSection extends StatelessWidget {
  const PostSourcesSection({super.key, required this.post});

  final Post post;

  @override
  Widget build(BuildContext context) {
    final List<String> links = post.sources
        .where((e) => RegExp(r'^-?https?://\S+').hasMatch(e))
        .toList();
    if (links.isEmpty) return const SizedBox.shrink();
    final Map<String, List<String>> hosts = {};
    for (final String link in links) {
      final String host =
          Uri.tryParse(link.replaceFirst(RegExp('^-'), ''))?.host ?? link;
      hosts
          .putIfAbsent(host.replaceFirst(RegExp(r'^www\.'), ''), () => [])
          .add(link);
    }
    return PostDetailSection(
      section: PostSection.sources,
      label: 'Sources',
      count: links.length,
      summary: hosts.keys.join(' · '),
      child: Column(
        children: [for (final String link in links) PostSourceRow(link: link)],
      ),
    );
  }
}

class PostSourceRow extends StatelessWidget {
  const PostSourceRow({super.key, required this.link});

  final String link;

  @override
  Widget build(BuildContext context) {
    final bool enabled = !link.startsWith('-');
    final String url = enabled ? link : link.substring(1);
    final Uri? uri = Uri.tryParse(url);
    final Color onSurface = Theme.of(context).colorScheme.onSurface;
    final FaIconData? icon = getHostIcon(url);
    return InkWell(
      onTap: enabled ? () => launch(url) : null,
      child: ConstrainedBox(
        constraints: const BoxConstraints(minHeight: 48),
        child: Row(
          spacing: 12,
          children: [
            SizedBox.square(
              dimension: 20,
              child: Center(
                child: icon != null
                    ? FaIcon(
                        icon,
                        size: 16,
                        color: onSurface.withValues(alpha: 0.7),
                      )
                    : Icon(
                        Icons.link,
                        size: 16,
                        color: onSurface.withValues(alpha: 0.7),
                      ),
              ),
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    uri != null && isSourceFile(uri) ? 'Original file' : 'Post',
                    style: enabled
                        ? null
                        : TextStyle(
                            color: onSurface.withValues(alpha: 0.5),
                            decoration: TextDecoration.lineThrough,
                          ),
                  ),
                  Text(
                    linkToDisplay(url),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: 12,
                      color: onSurface.withValues(alpha: 0.5),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class SourceCard extends StatelessWidget {
  const SourceCard({super.key, required this.url});

  final String url;

  @override
  Widget build(BuildContext context) {
    String url = this.url;
    if (RegExp(r'^-?https?://\S+').hasMatch(url)) {
      bool enabled;
      if (url.startsWith('-')) {
        enabled = false;
        url = url.substring(1);
      } else {
        enabled = true;
      }
      return Card(
        child: InkWell(
          onTap: enabled ? () => launch(url) : null,
          child: IntrinsicHeight(
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                ConstrainedBox(
                  constraints: const BoxConstraints(minWidth: 24),
                  child: Padding(
                    padding: const EdgeInsets.only(left: 8),
                    child: Center(
                      child: getHostIcon(url) != null
                          ? FaIcon(
                              getHostIcon(url)!,
                              size: 16,
                              color: Colors.grey,
                            )
                          : const Icon(
                              Icons.link,
                              size: 16,
                              color: Colors.grey,
                            ),
                    ),
                  ),
                ),
                const VerticalDivider(indent: 4, endIndent: 4),
                Flexible(
                  child: Padding(
                    padding: const EdgeInsets.all(6),
                    child: Text(
                      linkToDisplay(url),
                      style: enabled
                          ? TextStyle(color: Colors.blue[400])
                          : const TextStyle(
                              color: Colors.grey,
                              decoration: TextDecoration.lineThrough,
                            ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    } else {
      return Card(
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Flexible(
              child: Padding(
                padding: const EdgeInsets.all(6),
                child: Text(url),
              ),
            ),
          ],
        ),
      );
    }
  }
}
