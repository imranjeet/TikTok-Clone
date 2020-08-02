import 'package:flutter/material.dart';

class VideoViews extends StatelessWidget {
  final int videoViews;

  const VideoViews({Key key, this.videoViews}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(top: 10, bottom: 10),
      child: Column(
        children: <Widget>[
          Image.asset(
            "assets/icons/eye.png",
            height: 35,
            width: 35,
          ),
          Padding(
            padding: EdgeInsets.only(
              top: 1.0,
            ),
            child: Text(
              "$videoViews",
              style: TextStyle(fontSize: 10, color: Colors.white),
            ),
          )
        ],
      ),
    );
  }
}
