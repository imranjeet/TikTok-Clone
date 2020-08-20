import 'package:agni_app/providers/comments.dart';
import 'package:agni_app/providers/follows.dart';
import 'package:agni_app/providers/reactions.dart';
import 'package:agni_app/providers/sounds.dart';
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
  // var _isInit = true;

  // @override
  // void didChangeDependencies() {
  //   if (_isInit) {
  //     Provider.of<Videos>(context).fetchVideos();
  //     Provider.of<Users>(context).fetchUsers();
  //     Provider.of<Reactions>(context).fetchReactions();
  //     Provider.of<Comments>(context).fetchComments();
  //     Provider.of<Follows>(context).fetchFollows();
  //   }
  //   _isInit = false;
  //   super.didChangeDependencies();
  // }

  Future<void> _refreshVideos(BuildContext context) async {
    await Provider.of<Videos>(context).fetchVideos();
    await Provider.of<Users>(context).fetchUsers();
    await Provider.of<Reactions>(context).fetchReactions();
    await Provider.of<Comments>(context).fetchComments();
    await Provider.of<Follows>(context).fetchFollows();
    await Provider.of<Sounds>(context).fetchSounds();
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
          Provider.of<Sounds>(context, listen: false).fetchSounds(),
        ]),
        builder: (
          ctx,
          dataSnapshot,
        ) {
          try {
            if (dataSnapshot.connectionState == ConnectionState.waiting) {
              return Scaffold(
                  backgroundColor: Colors.black,
                  body: Center(child: CircularProgressIndicator()));
            } else if (dataSnapshot.hasData == null) {
              return EmptyBoxScreen();
            } else {
              return Consumer<Videos>(
                  builder: (ctx, videoData, child) => RefreshIndicator(
                      backgroundColor: Colors.white,
                      onRefresh: () => _refreshVideos(context),
                      child: PageView.builder(
                          scrollDirection: Axis.vertical,
                          itemCount: videoData.items.length,
                          itemBuilder: (context, pageIndex) {
                            bool isDirect = false;
                            return Container(
                              color: Colors.black,
                              child: Stack(
                                children: <Widget>[
                                  VideoPlayerScreen(
                                    videoLink:
                                        videoData.items[pageIndex].videoUrl,
                                        isDirect: isDirect,
                                  ),
                                  ScreenControls(
                                    video: videoData.items[pageIndex],
                                    currentUserId: currentUserId,
                                  ),
                                ],
                              ),
                            );
                          })));
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
  }
}
