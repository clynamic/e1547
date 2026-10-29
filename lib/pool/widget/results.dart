import 'package:e1547/pool/pool.dart';
import 'package:e1547/shared/shared.dart';
import 'package:flutter/material.dart';

class SearchPools extends StatelessWidget {
  const SearchPools({super.key, required this.top, required this.dimmed});

  final SliverTop top;
  final bool dimmed;

  @override
  Widget build(BuildContext context) => PoolsHistoryConnector(
    child: PoolPageQueryBuilder(
      builder: (context, state, query) => NavBarDock(
        builder: (_) => PoolDock(
          params: context.read<PoolParamsController>(),
          onOpen: (transition) =>
              showPoolSearchSheet(context, transition: transition),
        ),
        child: LimitedWidthLayout(
          child: TileLayout(
            child: RefreshShortcuts(
              onRefresh: query.invalidate,
              child: CustomScrollView(
                primary: true,
                physics: refreshPhysics,
                slivers: [
                  ...top(query.invalidate),
                  SliverDim(
                    dimmed: dimmed,
                    sliver: SliverBottomInsetPadding(
                      padding: EdgeInsets.fromLTRB(
                        8,
                        8,
                        8,
                        defaultListPadding.bottom,
                      ),
                      sliver: SliverPoolGrid(state: state, query: query),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    ),
  );
}
