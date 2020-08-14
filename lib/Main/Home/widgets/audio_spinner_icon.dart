import 'package:flutter/material.dart';

Widget audioSpinner() {
  return Container(
      width: 50.0,
      height: 50.0,
      decoration: BoxDecoration(
          gradient: audioDiscGradient,
          shape: BoxShape.circle,
          image: DecorationImage(image: AssetImage("assets/images/rc1.gif"))));
}

LinearGradient get audioDiscGradient => LinearGradient(colors: [
      Colors.pink,
      Colors.yellow,
      Colors.teal,
      Colors.white,
    ], stops: [
      0.0,
      0.4,
      0.6,
      1.0
    ], begin: Alignment.bottomLeft, end: Alignment.topRight);
