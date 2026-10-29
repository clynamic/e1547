enum SearchKind {
  posts('Posts', 'By tags, with filters and your blacklist'),
  pools('Pools', 'Comics and collections, by name'),
  sets('Sets', 'Yours first, then public ones');

  const SearchKind(this.label, this.description);

  final String label;
  final String description;
}
