import 'package:flutter/material.dart';

class VideoLike extends StatelessWidget {
  final int videoLike;

  const VideoLike({Key key, this.videoLike}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(top: 10, bottom: 10),
      child: Column(
        children: <Widget>[
          Icon(
            Icons.favorite,
            color: Colors.red,
            size: 35,
          ),
          Padding(
            padding: EdgeInsets.only(
              top: 1.0,
            ),
            child: Text(
              "$videoLike",
              style: TextStyle(fontSize: 10, color: Colors.white),
            ),
          )
        ],
      ),
    );
  }
}
