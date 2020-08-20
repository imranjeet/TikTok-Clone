import 'package:flutter/material.dart';

class VideoShare extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(top: 10, bottom: 10),
      child: Column(
        children: <Widget>[
          Image.asset(
                "assets/images/share.png",
                height: 35,
                width: 35,
                color: Colors.white,
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
