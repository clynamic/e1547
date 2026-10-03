import 'package:e1547/post/post.dart';
import 'package:e1547/tag/tag.dart';
import 'package:flutter/material.dart';

/// The file type filter of the posts filter panel.
///
/// The type family of metatags is encoded as a single group token, which no
/// plain filter tag can read or write, so this filter builds its own field.
class FileTypeFilterTag extends BuilderFilterTag {
  FileTypeFilterTag()
    : super(
        tag: 'type',
        name: 'File type',
        builder: (context, state) => FileTypeFilter(state: state),
      );
}

class FileTypeFilter extends StatelessWidget {
  const FileTypeFilter({super.key, required this.state});

  final FilterTagState<BuilderFilterTag> state;

  @override
  Widget build(BuildContext context) {
    final theme = FilterTagTheme.of(context);
    return DropdownButtonFormField<PostFileType>(
      key: const Key('FilterList/type'),
      initialValue: fileTypeFromTags(TagMap.from(state.tags)),
      decoration: theme.decoration.copyWith(
        labelText: localizedFilterName(context, state.filter.name!),
      ),
      icon: const Icon(Icons.image),
      isExpanded: true,
      items: [
        for (final type in PostFileType.values)
          DropdownMenuItem(
            value: type,
            child: Text(localizedFilterName(context, type.label)),
          ),
      ],
      onChanged: (type) => state.onChangedTags(
        withFileType(TagMap.from(state.tags), type ?? PostFileType.none),
      ),
    );
  }
}
