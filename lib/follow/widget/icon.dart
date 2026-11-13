import 'package:e1547/follow/follow.dart';
import 'package:flutter/material.dart';

extension FollowIcon on FollowType {
  IconData get icon {
    switch (this) {
      case FollowType.notify:
        return Icons.notifications_active;
      case FollowType.update:
        return Icons.person_add;
      case FollowType.bookmark:
        return Icons.bookmark;
    }
  }
}
