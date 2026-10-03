import 'package:e1547/client/client.dart';
import 'package:e1547/l10n/app_localizations.dart';
import 'package:e1547/post/post.dart';
import 'package:e1547/shared/shared.dart';
import 'package:flutter/material.dart';

class PostEditPage extends StatefulWidget {
  const PostEditPage({super.key, required this.post});

  final Post post;

  @override
  State<PostEditPage> createState() => _PostEditPageState();
}

class _PostEditPageState extends State<PostEditPage> {
  late final TextEditingController _descriptionController;
  late final TextEditingController _tagsController;
  late final TextEditingController _sourcesController;
  late final TextEditingController _parentIdController;
  late final TextEditingController _editReasonController;

  late PostEdit _editData;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();

    _editData = PostEdit.fromPost(widget.post);

    _descriptionController = TextEditingController(text: _editData.description);
    _tagsController = TextEditingController(text: _editData.tags.join(' '));
    _sourcesController = TextEditingController(
      text: _editData.sources.join('\n'),
    );
    _parentIdController = TextEditingController(
      text: _editData.parentId?.toString() ?? '',
    );
    _editReasonController = TextEditingController(
      text: _editData.editReason ?? '',
    );
  }

  @override
  void dispose() {
    _descriptionController.dispose();
    _tagsController.dispose();
    _sourcesController.dispose();
    _parentIdController.dispose();
    _editReasonController.dispose();
    super.dispose();
  }

  void _onRatingChanged(Rating rating) {
    setState(() {
      _editData = _editData.copyWith(rating: rating);
    });
  }

  Future<void> _saveChanges() async {
    if (_isLoading) return;
    setState(() => _isLoading = true);
    final messenger = ScaffoldMessenger.of(context);
    // Resolved up front, the context must not cross async gaps.
    final l10n = AppLocalizations.of(context);

    try {
      final editData = _editData.copyWith(
        description: _descriptionController.text,
        tags: _tagsController.text
            .split(' ')
            .where((s) => s.trim().isNotEmpty)
            .toList(),
        sources: _sourcesController.text
            .split('\n')
            .where((s) => s.trim().isNotEmpty)
            .toList(),
        parentId: _parentIdController.text.trim().isNotEmpty
            ? int.tryParse(_parentIdController.text.trim())
            : null,
        editReason: _editReasonController.text.trim().isNotEmpty
            ? _editReasonController.text.trim()
            : null,
      );

      if (editData.toForm() == null) {
        if (mounted) Navigator.of(context).pop();
        return;
      }

      final state = await context
          .read<Client>()
          .posts
          .useUpdate(id: widget.post.id)
          .mutate(editData);

      if (state.isError) {
        messenger.showSnackBar(
          SnackBar(content: Text(l10n.postUpdateFailed(widget.post.id))),
        );
        return;
      }

      if (mounted) {
        messenger.showSnackBar(
          SnackBar(content: Text(l10n.postUpdated(widget.post.id))),
        );
        Navigator.of(context).pop();
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  Widget _buildLayout(BuildContext context) {
    return LimitedWidthLayout.builder(
      maxWidth: 1200,
      tolerance: 24,
      builder: (context) => SingleChildScrollView(
        child: Padding(
          padding: LimitedWidthLayout.of(context).padding.add(
            const EdgeInsets.only(bottom: defaultActionListBottomHeight),
          ),
          child: _buildFormFields(context),
        ),
      ),
    );
  }

  Widget _buildFormFields(BuildContext context) {
    return Column(
      children: [
        _buildImagePreview(context),
        DescriptionEditDisplay(
          controller: _descriptionController,
          postId: widget.post.id,
          enabled: !_isLoading,
        ),
        TagsEditDisplay(controller: _tagsController, enabled: !_isLoading),
        RatingEditDisplay(
          rating: _editData.rating,
          onChanged: _onRatingChanged,
        ),
        ParentEditDisplay(
          controller: _parentIdController,
          enabled: !_isLoading,
        ),
        SourcesEditDisplay(
          controller: _sourcesController,
          postId: widget.post.id,
          enabled: !_isLoading,
        ),
        EditReasonDisplay(
          controller: _editReasonController,
          enabled: !_isLoading,
        ),
      ],
    );
  }

  Widget _buildImagePreview(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxHeight: 400),
        child: PostDetailImageDisplay(
          post: widget.post,
          onTap: () {
            PostVideoRoute.of(context).keepPlaying();
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => ImageCacheSizeProvider(
                  size: fullscreenImageCacheSize,
                  child: PostFullscreen(post: widget.post),
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return PostVideoRoute(
      post: widget.post,
      child: KeyboardDismisser(
        child: Scaffold(
          extendBodyBehindAppBar: true,
          appBar: TransparentAppBar(
            child: AppBar(leading: const CloseButton()),
          ),
          floatingActionButton: FloatingActionButton(
            onPressed: _isLoading ? null : _saveChanges,
            child: const Icon(Icons.check),
          ),
          body: _buildLayout(context),
        ),
      ),
    );
  }
}
