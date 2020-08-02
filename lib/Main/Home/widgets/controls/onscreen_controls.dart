import 'dart:convert';

import 'package:agni_app/animations/spinner_animation.dart';
import 'package:agni_app/providers/video.dart';
import 'package:flutter/material.dart';
import '../audio_spinner_icon.dart';
import 'videoAction/user_profile.dart';
import 'videoAction/video_comment.dart';
import 'package:http/http.dart' as http;

import 'videoAction/video_desc.dart';
import 'videoAction/video_like.dart';
import 'videoAction/video_share.dart';

class ScreenControls extends StatefulWidget {
  final Video video;

  const ScreenControls({Key key, this.video}) : super(key: key);

  @override
  _ScreenControlsState createState() => _ScreenControlsState();
}

class _ScreenControlsState extends State<ScreenControls> {
  // @override
  // void initState() {
  //   viewsUpdate(context);
  //   super.initState();
  // }

  // Future viewsUpdate(BuildContext context) async {
  //   await Future.delayed(Duration(seconds: 1));

  //   final url =
  //       'http://agni-api.infous.xyz/api/update-views/${widget.video.id}';

  //   try {
  //     http.Response response = await http.post(
  //       url,
  //       body: json.encode({
  //         'views': widget.video.views + 1,
  //       }),
  //     );
  //     print(response);
  //   } catch (error) {
  //     print(error);
  //     throw error;
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Row(
        children: <Widget>[
          Expanded(flex: 6, child: videoDesc()),
          Expanded(
            flex: 1,
            child: Container(
              padding: EdgeInsets.only(bottom: 60, right: 5),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.end,
                children: <Widget>[
                  userProfile(),
                  // VideoViews(videoViews: widget.video.views),
                  VideoLike(videoLike: widget.video.like),
                  VideoComment(),
                  VideoShare(),
                  SizedBox(height: 15,),
                  SpinnerAnimation(body: audioSpinner()),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
