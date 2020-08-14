import 'package:agni_app/Main/Home/widgets/controls/onscreen_controls.dart';
import 'package:agni_app/Main/Home/widgets/video_player_screen.dart';
import 'package:agni_app/providers/videos.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class UserVideoScreen extends StatelessWidget {
  final int totalVideos;
  final int videoIndex;
  final int userId;

  const UserVideoScreen(
      {Key key, this.totalVideos, this.videoIndex, this.userId});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: UserVideo(
          totalVideos: totalVideos, videoIndex: videoIndex, userId: userId),
    );
  }
}

class UserVideo extends StatelessWidget {
  final int totalVideos;
  final int videoIndex;
  final int userId;

  const UserVideo({Key key, this.totalVideos, this.videoIndex, this.userId})
      : super(key: key);

  Future<void> _refreshVideos(BuildContext context) async {
    await Provider.of<Videos>(context).fetchVideos();
    // await Provider.of<Users>(context).fetchUsers();
  }

  @override
  Widget build(BuildContext context) {
    var userVideos = Provider.of<Videos>(
      context,
      listen: false,
    ).allUserVideos(userId, videoIndex, totalVideos);
    return RefreshIndicator(
      onRefresh: () => _refreshVideos(context),
      child: PageView.builder(
        scrollDirection: Axis.vertical,
        itemBuilder: (context, index) {
          return Scaffold(
            backgroundColor: Colors.transparent,
            floatingActionButtonLocation: FloatingActionButtonLocation.startTop,
            floatingActionButton: FloatingActionButton(
              backgroundColor: Colors.black38,
              onPressed: () {
                Navigator.pop(context);
              },
              child: Icon(
                Icons.arrow_back_ios,
                color: Colors.white,
              ),
            ),
            body: Stack(
              children: <Widget>[
                VideoPlayerScreen(
                    videoLink: userVideos[index].videoUrl,),
                ScreenControls(
                  video: userVideos[index],
                  currentUserId: userId,
                ),
              ],
            ),
          );
        },
        itemCount: userVideos.length,
      ),
    );
  }
}
