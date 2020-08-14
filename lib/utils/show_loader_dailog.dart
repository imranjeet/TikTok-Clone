import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

showLoaderDialog(BuildContext context, String title) {
  AlertDialog alert = AlertDialog(
    content: new Row(
      children: [
        CircularProgressIndicator(),
        Container(
            margin: EdgeInsets.only(left: 7),
            child: Text(
              title,
              style: GoogleFonts.mcLaren(
                color: Colors.black,
                textStyle: TextStyle(
                  fontSize: 18,
                ),
              ),
            )),
      ],
    ),
  );
  showDialog(
    barrierDismissible: false,
    context: context,
    builder: (BuildContext context) {
      return alert;
    },
  );
}
