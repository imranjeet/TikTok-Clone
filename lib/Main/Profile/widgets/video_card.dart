import 'package:agni_app/Main/Profile/widgets/user_video_player.dart';
import 'package:agni_app/providers/video.dart';
import 'package:agni_app/providers/videos.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class VideoCard extends StatelessWidget {
  final Video video;
  final int totalVideos;
  final int videoIndex;
  final int userId;

  const VideoCard(
      {Key key, this.video, this.totalVideos, this.videoIndex, this.userId})
      : super(key: key);

  Future<void> _deteteVideos(BuildContext context, int id) async {
    await Provider.of<Videos>(context).deleteVideo(id);
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => UserVideoScreen(
                    totalVideos: totalVideos,
                    videoIndex: videoIndex,
                    userId: userId)));
      },
      child: Card(
        elevation: 3,
        clipBehavior: Clip.antiAliasWithSaveLayer,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(5),
            side: BorderSide(width: 3, color: Colors.transparent)),
        child: video.thumbnail == null
            ? Image.asset(
                "assets/images/dice.jpg",
                height: 140,
                width: 110,
                fit: BoxFit.fill,
              )
            : CachedNetworkImage(
                imageUrl: video.thumbnail,
                errorWidget: (context, url, error) => Container(
                    child: Column(
                  children: <Widget>[
                    Icon(
                      Icons.error,
                      size: 25,
                    ),
                    Text(
                      "Something went wrong. Try again!",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ],
                )),
                height: 140,
                width: 110,
                fit: BoxFit.fill,
              ),
      ),
    );
  }
}
