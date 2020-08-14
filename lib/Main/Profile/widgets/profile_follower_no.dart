import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

class ProfileNumberItem extends StatelessWidget {
  final int count;
  final String typeName;
  ProfileNumberItem({
    Key key,
    this.count,
    this.typeName,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var _formattedNumber = NumberFormat.compact().format(count);
    return Container(
      color: Colors.black38,
      child: Column(
        children: <Widget>[
          Card(
            color: Colors.deepOrangeAccent,
            shape: RoundedRectangleBorder(
              side: BorderSide(color: Colors.white, width: 1),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
              child: Text(
                _formattedNumber,
                style: GoogleFonts.mcLaren(
                  textStyle: TextStyle(
                    fontSize: 15,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ),
          Text(
            typeName,
            style: GoogleFonts.mcLaren(
              textStyle: TextStyle(
                fontSize: 14,
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
