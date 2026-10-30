import 'package:e1547/settings/settings.dart';
import 'package:e1547/shared/shared.dart';
import 'package:flutter/material.dart';

enum PostSection { pools, family, tags, artist, sources, details }

class PostSectionTitle extends StatelessWidget {
  const PostSectionTitle({super.key, required this.label, this.count});

  final String label;
  final int? count;

  @override
  Widget build(BuildContext context) => Text.rich(
    TextSpan(
      text: label.toUpperCase(),
      children: [
        if (count != null)
          TextSpan(
            text: ' $count',
            style: const TextStyle(fontWeight: FontWeight.w400),
          ),
      ],
    ),
    style: TextStyle(
      fontSize: 12,
      fontWeight: FontWeight.w500,
      letterSpacing: 0.4,
      color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.55),
    ),
  );
}

class PostSectionLine extends StatelessWidget {
  const PostSectionLine({
    super.key,
    required this.label,
    required this.summary,
    required this.icon,
    required this.onTap,
    this.count,
  });

  final String label;
  final int? count;
  final String summary;
  final IconData icon;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final Color onSurface = Theme.of(context).colorScheme.onSurface;
    return PostSectionBorder(
      child: InkWell(
        onTap: onTap,
        child: ConstrainedBox(
          constraints: const BoxConstraints(minHeight: 64),
          child: Row(
            spacing: 12,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  spacing: 3,
                  children: [
                    PostSectionTitle(label: label, count: count),
                    Text(
                      summary,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: 14,
                        color: onSurface.withValues(alpha: 0.7),
                      ),
                    ),
                  ],
                ),
              ),
              Icon(icon, color: onSurface.withValues(alpha: 0.5)),
            ],
          ),
        ),
      ),
    );
  }
}

class PostSectionBorder extends StatelessWidget {
  const PostSectionBorder({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) => DecoratedBox(
    decoration: BoxDecoration(
      border: Border(
        top: BorderSide(
          color: Theme.of(
            context,
          ).colorScheme.onSurface.withValues(alpha: 0.08),
        ),
      ),
    ),
    child: child,
  );
}

class PostDetailSection extends StatelessWidget {
  const PostDetailSection({
    super.key,
    required this.section,
    required this.label,
    required this.summary,
    required this.child,
    this.count,
  });

  final PostSection section;
  final String label;
  final int? count;
  final String summary;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final ValueNotifier<List<String>> collapsed = context
        .watch<Settings>()
        .collapsedPostSections;
    return ValueListenableBuilder<List<String>>(
      valueListenable: collapsed,
      builder: (context, value, _) {
        final bool closed = value.contains(section.name);
        void toggle() => collapsed.value = closed
            ? [...value.where((e) => e != section.name)]
            : [...value, section.name];
        if (closed) {
          return PostSectionLine(
            label: label,
            count: count,
            summary: summary,
            icon: Icons.expand_more,
            onTap: toggle,
          );
        }
        return PostSectionBorder(
          child: Padding(
            padding: const EdgeInsets.only(top: 10, bottom: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              spacing: 6,
              children: [
                InkWell(
                  onTap: toggle,
                  child: SizedBox(
                    height: 40,
                    child: Row(
                      children: [
                        Expanded(
                          child: PostSectionTitle(label: label, count: count),
                        ),
                        Icon(
                          Icons.expand_less,
                          color: Theme.of(
                            context,
                          ).colorScheme.onSurface.withValues(alpha: 0.5),
                        ),
                      ],
                    ),
                  ),
                ),
                child,
              ],
            ),
          ),
        );
      },
    );
  }
}
