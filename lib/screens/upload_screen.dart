import 'package:flutter/material.dart';

class UploadScreen extends StatefulWidget {
  // static const routeName = '/video-upload';

  @override
  _UploadScreenState createState() => _UploadScreenState();
}

class _UploadScreenState extends State<UploadScreen> {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Icon(
                  Icons.video_call,
                  size: 100.0,
                  color: Colors.red,
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 20.0),
                  child: RaisedButton(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(9.0),
                    ),
                    child: Text(
                      "Upload Video",
                      style: TextStyle(fontSize: 15.0),
                    ),
                    onPressed: () => () {},
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
