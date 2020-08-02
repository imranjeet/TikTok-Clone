import 'package:flutter/material.dart';

Widget videoDesc() {
  return Container(
    padding: EdgeInsets.only(left: 10, bottom: 25),
    child: Column(
      mainAxisAlignment: MainAxisAlignment.end,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Padding(
          padding: EdgeInsets.only(top: 7, bottom: 7),
          child: Text(
            "@username",
            style: TextStyle(
                fontSize: 14,
                color: Colors.white,
                fontWeight: FontWeight.w500,
                backgroundColor: Colors.grey[800]),
          ),
        ),
        Padding(
          padding: EdgeInsets.only(top: 4, bottom: 7),
          child: Text("Lorem ipsum dolor sit amet, consectetur ",
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 14,
                  fontWeight: FontWeight.w300,
                backgroundColor: Colors.grey[800])),
        ),
        Row(
          children: <Widget>[
            Icon(
              Icons.music_note,
              size: 19,
              color: Colors.white,
            ),
            Text(
              "Lorem ipsum dolor sit amet ...",
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 14,
                  fontWeight: FontWeight.w300),
            )
          ],
        ),
      ],
    ),
  );
}
