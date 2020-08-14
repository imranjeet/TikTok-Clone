import 'package:agni_app/providers/comments.dart';
import 'package:agni_app/providers/follows.dart';
import 'package:agni_app/providers/reactions.dart';
import 'package:agni_app/providers/users.dart';
import 'package:agni_app/providers/videos.dart';
import 'package:agni_app/Main/Home/widgets/video_player_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../empty_box.dart';
import '../widgets/controls/onscreen_controls.dart';

class HomeScreen extends StatelessWidget {
  final int currentUserId;

  HomeScreen({Key key, this.currentUserId}) : super(key: key);

  Future<void> _refreshVideos(BuildContext context) async {
    await Provider.of<Videos>(context).fetchVideos();
    await Provider.of<Users>(context).fetchUsers();
    await Provider.of<Reactions>(context).fetchReactions();
    await Provider.of<Comments>(context).fetchComments();
    await Provider.of<Follows>(context).fetchFollows();
  }

  @override
  Widget build(BuildContext context) {
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
          try {
            // if (dataSnapshot.connectionState == ConnectionState.waiting) {
            //   return Center(child: CircularProgressIndicator());
            // } else
            if (dataSnapshot.hasData == null) {
              return EmptyBoxScreen();
            } else {
              return Consumer<Videos>(
                builder: (ctx, videoData, child) => RefreshIndicator(
                  backgroundColor: Colors.white,
                  onRefresh: () => _refreshVideos(context),
                  child: PageView.builder(
                    scrollDirection: Axis.vertical,
                    itemBuilder: (context, index) {
                      return Container(
                        color: Colors.black,
                        child: Stack(
                          children: <Widget>[
                            VideoPlayerScreen(
                              videoLink: videoData.items[index].videoUrl,
                            ),
                            ScreenControls(
                              video: videoData.items[index],
                              currentUserId: currentUserId,
                            ),
                          ],
                        ),
                      );
                    },
                    itemCount: videoData.items.length,
                  ),
                ),
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
        });
    // RefreshIndicator(
    //   onRefresh: () => _refreshVideos(context),
    //   child: PageView.builder(
    //     scrollDirection: Axis.vertical,
    //     itemBuilder: (context, index) {
    //       return Container(
    //         color: Colors.black,
    //         child: Stack(
    //           children: <Widget>[
    //             VideoPlayerScreen(videoLink: videoList.items[index].videoUrl),
    //             ScreenControls(
    //               video: videoList.items[index],
    //               currentUserId: widget.currentUserId,
    //             ),
    //           ],
    //         ),
    //       );
    //     },
    //     itemCount: videoList.items.length,
    //   ),
    // );
  }
}
