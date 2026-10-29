import 'package:flutter/material.dart';

enum SearchKind {
  posts('Posts', 'By tags, with filters and your blacklist', Icons.grid_view),
  pools('Pools', 'Comics and collections, by name', Icons.photo_library),
  sets('Sets', 'Yours first, then public ones', Icons.folder);

  const SearchKind(this.label, this.description, this.icon);

  final String label;
  final String description;
  final IconData icon;
}
