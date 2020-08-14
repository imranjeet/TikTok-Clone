import 'package:flutter/material.dart';

class EmptyBoxScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Image.asset("assets/images/empty1.png"),
          Text(
            "Whoops!",
            style: TextStyle(fontSize: 22, fontWeight: FontWeight.w400),
          ),
          Text("it seems it's empty here.")
        ],
      ),
    );
  }
}
