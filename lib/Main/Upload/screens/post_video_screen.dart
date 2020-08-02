import 'dart:io';

import 'package:agni_app/Main/Upload/widgets/file_video_player.dart';
import 'package:flutter/material.dart';

class PostVideoScreen extends StatelessWidget {
  final File videoFile;
  final File thumbnail;
  final File gif;
  // final UniqueKey newKey;

  const PostVideoScreen({
    Key key,
    this.videoFile,
    this.thumbnail,
    this.gif,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.red,
        title: Text("Post Video"),
      ),
      body: Container(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            VideoPlayerScreen(videoFile: videoFile,),
            Image.file(
              thumbnail,
              height: 200,
            ),
            Image.file(
              gif,
              height: 200,
            ),
          ],
        ),
      ),
    );
  }
}