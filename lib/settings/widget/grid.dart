import 'package:e1547/l10n/app_localizations.dart';
import 'package:e1547/shared/shared.dart';
import 'package:flutter/material.dart';

extension GridQuiltDescription on GridQuilt {
  IconData get icon {
    switch (this) {
      case GridQuilt.square:
        return Icons.view_module;
      case GridQuilt.vertical:
        return Icons.view_column;
    }
  }
}

class GridSettingsTile extends StatelessWidget {
  const GridSettingsTile({super.key, required this.state, this.onChange});

  final GridQuilt state;
  final void Function(GridQuilt state)? onChange;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(AppLocalizations.of(context).settingsQuilt),
      subtitle: Text(quiltDescription(context, state)),
      leading: Icon(state.icon),
      onTap: () => showDialog(
        context: context,
        builder: (context) => SimpleDialog(
          title: Text(AppLocalizations.of(context).gridTitle),
          children: [
            Column(
              mainAxisSize: MainAxisSize.min,
              children: GridQuilt.values
                  .map(
                    (state) => ListTile(
                      trailing: Icon(state.icon),
                      title: Text(quiltDescription(context, state)),
                      onTap: () {
                        if (popDialog(context)) {
                          onChange!(state);
                        }
                      },
                    ),
                  )
                  .toList(),
            ),
          ],
        ),
      ),
    );
  }
}

/// Localized descriptions of grid quilt modes.
String quiltDescription(BuildContext context, GridQuilt quilt) =>
    switch (quilt) {
      GridQuilt.square => AppLocalizations.of(context).quiltSquare,
      GridQuilt.vertical => AppLocalizations.of(context).quiltVertical,
    };
