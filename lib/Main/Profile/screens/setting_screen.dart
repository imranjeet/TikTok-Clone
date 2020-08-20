import 'package:agni_app/Main/Profile/screens/profile_screen.dart';
import 'package:agni_app/providers/comments.dart';
import 'package:agni_app/providers/follows.dart';
import 'package:agni_app/providers/reactions.dart';
import 'package:agni_app/providers/users.dart';
import 'package:agni_app/providers/videos.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../empty_box.dart';

class SettingScreen extends StatelessWidget {
  final int currentUserId;

  SettingScreen({this.currentUserId});

  @override
  Widget build(BuildContext context) {
    bool isBackButton = false;
    return FutureBuilder(
      future: Future.wait([
        Provider.of<Videos>(context, listen: false).fetchVideos(),
        Provider.of<Users>(context, listen: false).fetchUsers(),
        Provider.of<Reactions>(context, listen: false).fetchReactions(),
        Provider.of<Comments>(context, listen: false).fetchComments(),
        Provider.of<Follows>(context, listen: false).fetchFollows(),
      ]),
      builder: (
        ctx,
        dataSnapshot,
      ) {
        if (dataSnapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        // } else if (dataSnapshot.connectionState == ConnectionState.none) {
        //   return NetworkErrorScreen();
        }
        try {
          if (dataSnapshot.hasData == null) {
            return EmptyBoxScreen();
          } else {
            return ProfilePage(
              currentUserId: currentUserId,
              userId: currentUserId,
              isBackButton: isBackButton,
            );
          }
        } catch (error) {
          print(error);
          return AlertDialog(
            title: Text('An error occurred!'),
            content: Text('Something went wrong.'),
            actions: <Widget>[
              FlatButton(
                child: Text('Okay'),
                onPressed: () {
                  Navigator.of(ctx).pop();
                },
              )
            ],
          );
        }
      },
    );
    // _isLoading
    //     ? Center(child: CircularProgressIndicator())
    // : ProfilePage(
    //   currentUserId: widget.currentUserId,
    //   userId: widget.currentUserId,
    //   isBackButton: isBackButton,
    // );
  }
}
