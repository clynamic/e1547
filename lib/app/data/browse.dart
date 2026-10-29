import 'package:flutter/material.dart';

enum BrowseFeed {
  hot('Hot', Icons.whatshot),
  latest('Latest', Icons.schedule),
  popular('Popular', Icons.trending_up),
  timeline('Timeline', Icons.dynamic_feed_outlined);

  const BrowseFeed(this.label, this.icon);

  final String label;
  final IconData icon;
}

enum PopularScale {
  day('Day', 'Today'),
  week('Week', 'This week'),
  month('Month', 'This month');

  const PopularScale(this.label, this.period);

  final String label;
  final String period;
}

String browseFeedTags(BrowseFeed feed, PopularScale scale) => switch (feed) {
  BrowseFeed.latest => '',
  BrowseFeed.popular => 'order:score date:${scale.name}',
  BrowseFeed.hot => 'order:rank',
  BrowseFeed.timeline => '',
};
