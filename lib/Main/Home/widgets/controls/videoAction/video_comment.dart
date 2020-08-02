import 'package:flutter/material.dart';

class VideoComment extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(top: 10, bottom: 10),
      child: Column(
        children: <Widget>[
          Icon(
            Icons.chat_bubble,
            color: Colors.white,
            size: 35,
          ),
          Padding(
            padding: EdgeInsets.only(
              top: 1.0,
            ),
            child: Text(
              "130",
              style: TextStyle(fontSize: 10, color: Colors.white),
            ),
          )
        ],
      ),
    );
  }
}