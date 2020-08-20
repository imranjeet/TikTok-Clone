import 'package:agni_app/providers/user.dart';
import 'package:agni_app/providers/video.dart';
import 'package:agni_app/utils/constant.dart';
import 'package:flutter/material.dart';

Widget videoDesc(User videoUser, Video video) {
  return Container(
    padding: EdgeInsets.only(left: 10, bottom: 25),
    child: Column(
      mainAxisAlignment: MainAxisAlignment.end,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Padding(
          padding: EdgeInsets.only(top: 7, bottom: 7),
          child: Text(
            videoUser.username == null
                ? "${videoUser.name}"
                : "@${videoUser.username}",
            overflow: TextOverflow.ellipsis,
            style: kTitleTextstyle,
          ),
        ),
        video.description == null
            ? SizedBox.shrink()
            : Padding(
                padding: EdgeInsets.only(top: 4, bottom: 7),
                child: Text(
                  "${video.description}",
                  overflow: TextOverflow.ellipsis,
                  style: kSubTextStyle,
                ),
              ),
        video.soundName == null
            ? SizedBox.shrink()
            : Row(
                children: <Widget>[
                  Icon(
                    Icons.music_note,
                    size: 19,
                    color: Colors.white,
                  ),
                  Text(
                    video.soundName,
                    style: kSubTextStyle,
                  )
                ],
              ),
      ],
    ),
  );
}
