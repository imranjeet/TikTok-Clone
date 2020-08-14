import 'package:flutter/material.dart';

import 'Profile/screens/profile_screen.dart';

class UserProfileScreen extends StatelessWidget {
  final int currentUserId;
  final int userId;

  const UserProfileScreen({Key key, this.currentUserId, this.userId})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    bool isBackButton = true;
    return Scaffold(
      backgroundColor: Colors.white,
      body: ProfilePage(currentUserId: currentUserId, userId: userId, isBackButton: isBackButton),
    );
  }
}
