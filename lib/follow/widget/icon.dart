import 'package:e1547/follow/follow.dart';
import 'package:flutter/material.dart';

extension FollowIcon on FollowType {
  IconData get iconData => switch (this) {
    FollowType.notify => Icons.notifications_active,
    FollowType.update => Icons.person_add,
    FollowType.bookmark => Icons.bookmark,
  };

  Widget get icon => Icon(iconData);
}
