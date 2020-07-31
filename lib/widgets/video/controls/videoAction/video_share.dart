import 'package:flutter/material.dart';

class VideoShare extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(top: 10, bottom: 10),
      child: Column(
        children: <Widget>[
          Icon(
            Icons.reply,
            color: Colors.white,
            size: 35,
            textDirection: TextDirection.rtl,
          ),
          Padding(
            padding: EdgeInsets.only(
              top: 1.0,
            ),
            child: Text(
              "share",
              style: TextStyle(fontSize: 10, color: Colors.white),
            ),
          )
        ],
      ),
    );
  }
}
