import 'package:e1547/client/client.dart';
import 'package:e1547/flag/flag.dart';
import 'package:e1547/l10n/app_localizations.dart';
import 'package:e1547/markup/markup.dart';
import 'package:e1547/post/post.dart';
import 'package:e1547/shared/shared.dart';
import 'package:e1547/tag/tag.dart';
import 'package:e1547/ticket/ticket.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class PostFlagScreen extends StatefulWidget {
  const PostFlagScreen({super.key, required this.post});

  final Post post;

  @override
  State<PostFlagScreen> createState() => _PostFlagScreenState();
}

/// Flag type titles double as API payloads.
///
/// This maps them to their localized display names.
String localizedFlagName(BuildContext context, FlagType type) {
  final l10n = AppLocalizations.of(context);
  return switch (type) {
    FlagType.uploadingGuidelines => l10n.flagTypeUploadingGuidelines,
    FlagType.youngHuman => l10n.flagTypeYoungHuman,
    FlagType.dnpArtist => l10n.flagTypeDnpArtist,
    FlagType.payContent => l10n.flagTypePayContent,
    FlagType.trace => l10n.flagTypeTrace,
    FlagType.previouslyDeleted => l10n.flagTypePreviouslyDeleted,
    FlagType.realPorn => l10n.flagTypeRealPorn,
    FlagType.corrupt => l10n.flagTypeCorrupt,
    FlagType.inferior => l10n.flagTypeInferior,
  };
}

/// Returns the localized body text of a flag type.
String localizedFlagBody(BuildContext context, FlagType type) {
  final l10n = AppLocalizations.of(context);
  return switch (type) {
    FlagType.uploadingGuidelines => l10n.flagTypeUploadingGuidelinesBody,
    FlagType.youngHuman => l10n.flagTypeYoungHumanBody,
    FlagType.dnpArtist => l10n.flagTypeDnpArtistBody,
    FlagType.payContent => l10n.flagTypePayContentBody,
    FlagType.trace => l10n.flagTypeTraceBody,
    FlagType.previouslyDeleted => l10n.flagTypePreviouslyDeletedBody,
    FlagType.realPorn => l10n.flagTypeRealPornBody,
    FlagType.corrupt => l10n.flagTypeCorruptBody,
    FlagType.inferior => l10n.flagTypeInferiorBody,
  };
}

class _PostFlagScreenState extends State<PostFlagScreen> {
  ScrollController scrollController = ScrollController();
  TextEditingController parentController = TextEditingController();
  FlagType? type;

  bool isLoading = false;

  @override
  void dispose() {
    scrollController.dispose();
    parentController.dispose();
    super.dispose();
  }

  Future<void> _sendFlag(BuildContext context) async {
    if (Form.of(context).validate()) {
      setState(() {
        isLoading = true;
      });
      scrollController.animateTo(
        0,
        duration: defaultAnimationDuration,
        curve: Curves.easeInOut,
      );
      ScaffoldMessengerState messenger = ScaffoldMessenger.of(context);
      // Resolved up front, the context must not cross async gaps.
      final l10n = AppLocalizations.of(context);
      try {
        await context.read<Client>().flags.create(
          widget.post.id,
          type!.title,
          parent: int.tryParse(parentController.text),
        );
        if (context.mounted) {
          Navigator.of(context).maybePop();
        }
        messenger.showSnackBar(
          SnackBar(
            duration: const Duration(seconds: 1),
            content: Text(l10n.flagPostSuccess(widget.post.id)),
            behavior: SnackBarBehavior.floating,
          ),
        );
      } on ClientException {
        messenger.showSnackBar(
          SnackBar(
            duration: const Duration(seconds: 1),
            content: Text(l10n.flagPostFailed(widget.post.id)),
          ),
        );
      }
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return KeyboardDismisser(
      child: Form(
        child: Scaffold(
          appBar: DefaultAppBar(
            elevation: 0,
            title: Text(
              AppLocalizations.of(context).historyLinkPost(widget.post.id),
            ),
            leading: const CloseButton(),
          ),
          floatingActionButton: Builder(
            builder: (context) => FloatingActionButton(
              onPressed: isLoading ? null : () => _sendFlag(context),
              child: const Icon(Icons.check),
            ),
          ),
          body: LimitedWidthLayout(
            child: LayoutBuilder(
              builder: (context, constraints) => ListView(
                controller: scrollController,
                padding: LimitedWidthLayout.of(
                  context,
                ).padding.add(defaultFormScreenPadding),
                children: [
                  PostReportImage(
                    post: widget.post,
                    height: constraints.maxHeight,
                    isLoading: isLoading,
                  ),
                  ReportFormHeader(
                    title: Text(AppLocalizations.of(context).menuFlag),
                    icon: IconButton(
                      onPressed: () => showTagSearchPrompt(
                        context: context,
                        tag: 'e621:flag_for_deletion',
                      ),
                      icon: const Icon(Icons.info_outline),
                    ),
                  ),
                  ReportFormDropdown<FlagType?>(
                    type: type,
                    types: {
                      for (final e in FlagType.values)
                        e: localizedFlagName(context, e),
                    },
                    onChanged: (value) => setState(() => type = value),
                    isLoading: isLoading,
                  ),
                  CrossFade.builder(
                    showChild: type == FlagType.inferior,
                    builder: (context) {
                      final l10n = AppLocalizations.of(context);
                      return Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 24,
                          vertical: 12,
                        ),
                        child: TextFormField(
                          enabled: !isLoading,
                          controller: parentController,
                          decoration: InputDecoration(
                            labelText: l10n.flagParentId,
                            border: const OutlineInputBorder(),
                          ),
                          keyboardType: TextInputType.number,
                          inputFormatters: [
                            FilteringTextInputFormatter.allow(
                              RegExp(r'^ ?\d*'),
                            ),
                          ],
                          validator: (value) {
                            if (value!.trim().isEmpty) {
                              return l10n.flagParentIdRequired;
                            }
                            if (int.tryParse(value) == null) {
                              return l10n.flagParentIdInvalid;
                            }
                            return null;
                          },
                        ),
                      );
                    },
                  ),
                  CrossFade.builder(
                    showChild: type != null,
                    builder: (context) => Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 24,
                        vertical: 6,
                      ),
                      child: Row(
                        children: [
                          Expanded(
                            child: Card(
                              child: Padding(
                                padding: const EdgeInsets.all(16),
                                child: DText(localizedFlagBody(context, type!)),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
