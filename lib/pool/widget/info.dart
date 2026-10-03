import 'package:e1547/l10n/app_localizations.dart';
import 'package:e1547/pool/pool.dart';
import 'package:e1547/shared/shared.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class PoolInfo extends StatelessWidget {
  const PoolInfo({super.key, required this.pool});

  final Pool pool;

  @override
  Widget build(BuildContext context) {
    Widget textInfoRow(String label, String value) {
      return Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [Text(label), Text(value)],
      );
    }

    return DefaultTextStyle(
      style: TextStyle(color: dimTextColor(context)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          textInfoRow(
            AppLocalizations.of(context).poolInfoPosts,
            pool.postIds.length.toString(),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(AppLocalizations.of(context).poolInfoId),
              InkWell(
                child: Text('#${pool.id}'),
                onLongPress: () async {
                  ScaffoldMessengerState messenger = ScaffoldMessenger.of(
                    context,
                  );
                  final l10n = AppLocalizations.of(context);
                  Clipboard.setData(ClipboardData(text: pool.id.toString()));
                  await Navigator.of(context).maybePop();
                  messenger.showSnackBar(
                    SnackBar(
                      duration: const Duration(seconds: 1),
                      content: Text(l10n.poolCopiedId(pool.id)),
                    ),
                  );
                },
              ),
            ],
          ),
          textInfoRow(
            AppLocalizations.of(context).poolInfoActivity,
            pool.active
                ? AppLocalizations.of(context).poolInfoActive
                : AppLocalizations.of(context).poolInfoInactive,
          ),
          textInfoRow(
            AppLocalizations.of(context).poolInfoCreated,
            localizedDateTime(context, pool.createdAt.toLocal()),
          ),
          textInfoRow(
            AppLocalizations.of(context).poolInfoUpdated,
            localizedDateTime(context, pool.updatedAt.toLocal()),
          ),
        ],
      ),
    );
  }
}
