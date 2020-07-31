import 'package:flutter/material.dart';

Widget videoControlAction({IconData icon, String label, double size = 35, Color color}) {
  return Padding(
    padding: EdgeInsets.only(top: 20, bottom: 40),
    child: Column(
      children: <Widget>[
        Icon(
          
          icon,
          color: color,
          size: size,
          textDirection: TextDirection.rtl,
        ),
        Padding(
          padding: EdgeInsets.only(
              top: 1.0,),
          child: Text(
            label ?? "",
            style: TextStyle(fontSize: 10, color: Colors.white),
          ),
        )
      ],
    ),
  );
}
