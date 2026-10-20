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

class RatingEditDisplay extends StatelessWidget {
  const RatingEditDisplay({super.key, required this.rating, this.onChanged});

  final Rating rating;
  final ValueChanged<Rating>? onChanged;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: defaultFormPadding,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(t('Rating'), style: const TextStyle(fontSize: 16)),
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
                        Text(t(rating.title)),
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
      title: Text(t('Rating')),
      children: Rating.values
          .map(
            (rating) => ListTile(
              title: Text(t(rating.title)),
              leading: rating.icon,
              onTap: () {
                onSelected?.call(rating);
                Navigator.of(context).pop(rating);
              },
            ),
          )
          .toList(),
    ),
  );
}
