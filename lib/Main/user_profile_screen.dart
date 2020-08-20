import 'package:agni_app/providers/comments.dart';
import 'package:agni_app/providers/follows.dart';
import 'package:agni_app/providers/reactions.dart';
import 'package:agni_app/providers/users.dart';
import 'package:agni_app/providers/videos.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'Profile/screens/profile_screen.dart';

class UserProfileScreen extends StatelessWidget {
  final int currentUserId;
  final int userId;

  const UserProfileScreen({Key key, this.currentUserId, this.userId})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    bool isBackButton = true;
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
        // if (dataSnapshot.connectionState == ConnectionState.waiting) {
        //   return Scaffold(
        //       backgroundColor: Colors.white,
        //       body: Center(child: CircularProgressIndicator()));
        //   // } else if (dataSnapshot.connectionState == ConnectionState.none) {
        //   //   return NetworkErrorScreen();
        // }
        try {
          return Scaffold(
            backgroundColor: Colors.white,
            body: ProfilePage(
                currentUserId: currentUserId,
                userId: userId,
                isBackButton: isBackButton),
          );
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
    // Scaffold(
    //   backgroundColor: Colors.white,
    //   body: ProfilePage(currentUserId: currentUserId, userId: userId, isBackButton: isBackButton),
    // );
  }
}
