import 'package:flutter/material.dart';

Widget audioSpinner() {
  return Container(
      width: 50.0,
      height: 50.0,
      decoration: BoxDecoration(
          gradient: audioDiscGradient,
          shape: BoxShape.circle,
          image: DecorationImage(
              image: NetworkImage(
                  "https://hips.hearstapps.com/hmg-prod.s3.amazonaws.com/images/mh-supermen-1574086730.png?crop=0.454xw:0.907xh;0.0176xw,0&resize=640:*")
                  )
                  )
                  );
}

LinearGradient get audioDiscGradient => LinearGradient(colors: [
      Colors.grey[800],
      Colors.grey[900],
      Colors.grey[900],
      Colors.grey[800]
    ], stops: [
      0.0,
      0.4,
      0.6,
      1.0
    ], begin: Alignment.bottomLeft, end: Alignment.topRight);
