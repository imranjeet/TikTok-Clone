import 'package:agni_app/providers/users.dart';
import 'package:agni_app/providers/video.dart';
import 'package:agni_app/utils/animations/spinner_animation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../audio_spinner_icon.dart';
import 'videoAction/user_profile.dart';
import 'videoAction/video_comment.dart';

import 'videoAction/video_desc.dart';
import 'videoAction/video_like.dart';
import 'videoAction/video_share.dart';

class ScreenControls extends StatelessWidget {
  final Video video;
  final int currentUserId;

  const ScreenControls({Key key, this.video, this.currentUserId})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    var videoUser = Provider.of<Users>(
      context,
      listen: false,
    ).userfindById(video.userId);
    return Container(
      child: Row(
        children: <Widget>[
          Expanded(flex: 6, child: videoDesc(videoUser, video)),
          Expanded(
            flex: 1,
            child: Container(
              padding: EdgeInsets.only(bottom: 60, right: 5),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.end,
                children: <Widget>[
                  VideoUserProfile(
                      currentUserId: currentUserId, videoUser: videoUser),
                  VideoLike(
                      currentUserId: currentUserId,
                      videoId: video.id,
                      videoUserId: videoUser.id,
                      optionalImageUrl: video.thumbnail),
                  VideoComment(currentUserId: currentUserId, video: video),
                  VideoShare(),
                  SizedBox(
                    height: 15,
                  ),
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
