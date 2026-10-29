enum BrowseFeed {
  hot('Hot'),
  latest('Latest'),
  popular('Popular'),
  timeline('Timeline');

  const BrowseFeed(this.label);

  final String label;
}

enum PopularScale {
  day('Day'),
  week('Week'),
  month('Month');

  const PopularScale(this.label);

  final String label;
}

String browseFeedTags(BrowseFeed feed, PopularScale scale) => switch (feed) {
  BrowseFeed.latest => '',
  BrowseFeed.popular => 'order:score date:${scale.name}',
  BrowseFeed.hot => 'order:rank',
  BrowseFeed.timeline => '',
};
