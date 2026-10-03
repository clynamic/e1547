import 'package:e1547/l10n/app_localizations.dart';
import 'package:e1547/post/post.dart';
import 'package:e1547/shared/shared.dart';
import 'package:e1547/ticket/ticket.dart';
import 'package:flutter/material.dart';

extension ExtraRatingData on Rating {
  Widget get icon {
    switch (this) {
      case Rating.s:
        return const Icon(Icons.check);
      case Rating.q:
        return const Icon(Icons.help);
      case Rating.e:
        return const Icon(Icons.warning);
    }
  }

  String get title {
    switch (this) {
      case Rating.s:
        return 'Safe';
      case Rating.q:
        return 'Questionable';
      case Rating.e:
        return 'Explicit';
    }
  }
}

/// Rating titles double as stable data keys.
///
/// This maps them to their localized display names.
String localizedRatingName(BuildContext context, Rating rating) {
  final l10n = AppLocalizations.of(context);
  return switch (rating) {
    Rating.s => l10n.filterSafe,
    Rating.q => l10n.filterQuestionable,
    Rating.e => l10n.filterExplicit,
  };
}

class RatingEditDisplay extends StatelessWidget {
  const RatingEditDisplay({super.key, required this.rating, this.onChanged});

  final Rating rating;
  final ValueChanged<Rating>? onChanged;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Padding(
      padding: defaultFormPadding,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(l10n.filterRating, style: const TextStyle(fontSize: 16)),
          const SizedBox(height: 8),
          DropdownButtonFormField<Rating>(
            initialValue: rating,
            decoration: const InputDecoration(border: OutlineInputBorder()),
            items: Rating.values
                .map(
                  (rating) => DropdownMenuItem(
                    value: rating,
                    child: Row(
                      children: [
                        rating.icon,
                        const SizedBox(width: 8),
                        Text(localizedRatingName(context, rating)),
                      ],
                    ),
                  ),
                )
                .toList(),
            onChanged: onChanged != null
                ? (value) => value != null ? onChanged!(value) : null
                : null,
          ),
        ],
      ),
    );
  }
}

Future<Rating?> showRatingDialog({
  required BuildContext context,
  ValueChanged<Rating>? onSelected,
}) async {
  return showDialog<Rating>(
    context: context,
    builder: (context) => SimpleDialog(
      title: Text(AppLocalizations.of(context).filterRating),
      children: Rating.values
          .map(
            (rating) => ListTile(
              title: Text(localizedRatingName(context, rating)),
              leading: rating.icon,
              onTap: () {
                if (popDialog(context, rating)) {
                  onSelected?.call(rating);
                }
              },
            ),
          )
          .toList(),
    ),
  );
}
