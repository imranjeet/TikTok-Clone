import 'package:agni_app/utils/constant.dart';
import 'package:flutter/material.dart';

import '../../empty_box.dart';

class InboxScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Inbox",
          style: kHeadingTextStyle,
        ),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0.0,
      ),
      extendBodyBehindAppBar: true,
      body: Center(
        child: EmptyBoxScreen(),
      ),
    );
  }
}
