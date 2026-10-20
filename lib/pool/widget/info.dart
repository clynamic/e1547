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
          textInfoRow(t('posts'), pool.postIds.length.toString()),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(t('id')),
              InkWell(
                child: Text(tf('#{id}', params: {'id': pool.id})),
                onLongPress: () async {
                  ScaffoldMessengerState messenger = ScaffoldMessenger.of(
                    context,
                  );
                  Clipboard.setData(ClipboardData(text: pool.id.toString()));
                  await Navigator.of(context).maybePop();
                  messenger.showSnackBar(
                    SnackBar(
                      duration: const Duration(seconds: 1),
                      content: Text(
                        tf('Copied pool id #{id}', params: {'id': pool.id}),
                      ),
                    ),
                  );
                },
              ),
            ],
          ),
          textInfoRow(t('activity'), pool.active ? t('active') : t('inactive')),
          textInfoRow(
            t('created'),
            DateFormatting.dateTime(pool.createdAt.toLocal()),
          ),
          textInfoRow(
            t('updated'),
            DateFormatting.dateTime(pool.updatedAt.toLocal()),
          ),
        ],
      ),
    );
  }
}
