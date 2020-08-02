import 'package:flutter/material.dart';

Widget userProfile() {
  return Padding(
    padding: EdgeInsets.only(top: 10, bottom: 10),
    child: Column(
      children: <Widget>[
        Stack(
          alignment: AlignmentDirectional.center,
          children: <Widget>[
            Container(
              height: 50,
              width: 50,
              decoration: BoxDecoration(
                border: Border.all(
                    color: Colors.white, width: 1.0, style: BorderStyle.solid),
                color: Colors.black,
                shape: BoxShape.circle,
                image: DecorationImage(
                    image: NetworkImage(
                        "https://hips.hearstapps.com/hmg-prod.s3.amazonaws.com/images/mh-supermen-1574086730.png?crop=0.454xw:0.907xh;0.0176xw,0&resize=640:*")),
              ),
            ),
            Container(
              margin: EdgeInsets.only(top: 50),
              height: 18,
              width: 18,
              child: Icon(Icons.add, size: 10, color: Colors.white),
              decoration: BoxDecoration(
                  color: Color.fromRGBO(255, 42, 84, 1),
                  shape: BoxShape.circle),
            )
          ],
        )
      ],
    ),
  );
}
