import 'dart:io';

import 'package:agni_app/Main/Upload/widgets/file_video_player.dart';
import 'package:agni_app/providers/videos.dart';
import 'package:agni_app/utils/local_notification.dart';
import 'package:agni_app/Main/show_loader_dailog.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../base_alert_dialog.dart';

class PostVideoScreen extends StatefulWidget {
  final int currentUserId;
  final String soundName;
  final File videoFile;
  final File thumbnail;
  // final File gif;

  const PostVideoScreen({
    Key key,
    this.videoFile,
    this.thumbnail,
    // this.gif,
    this.currentUserId,
    this.soundName,
  }) : super(key: key);

  @override
  _PostVideoScreenState createState() => _PostVideoScreenState();
}

class _PostVideoScreenState extends State<PostVideoScreen> {
  final _description = TextEditingController();
  bool _validate = false;
  bool _isLoading = false;
  int sent;
  int total;
  int percentage = 0;

  Future<void> _uploadVideo(
    BuildContext context,
    int userId,
    String soundName,
    String description,
    File videoFile,
    File thumbnailFile,
  ) async {
    showLoaderDialog(context, "Uploading...");

    await Provider.of<Videos>(context, listen: false)
        .addVideo(userId, soundName, description, videoFile, thumbnailFile)
        .then((value) {
      LocalNotification.success(
        context,
        message: 'Video uploaded successfully',
        inPostCallback: true,
      );
      setState(() {});
      int count = 0;
      Navigator.popUntil(context, (route) {
        return count++ == 2;
      });
    });
    // String type = "comment";
    // String value = "replied: $comment";

    // await Provider.of<UserNotifications>(context, listen: false)
    //     .addPushNotification(_currentUserId, widget.video.userId, type, value,
    //         widget.video.thumbnail);
  }

  _confirmCancel() {
    var baseDialog = BaseAlertDialog(
        title: "Confirm Registration",
        content: "I Agree that the information provided is correct",
        yesOnPressed: () {
          int count = 0;
          Navigator.popUntil(context, (route) {
            return count++ == 2;
          });
        },
        noOnPressed: () {
          Navigator.pop(context);
        },
        yes: "Agree",
        no: "Cancel");
    showDialog(context: context, builder: (BuildContext context) => baseDialog);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        automaticallyImplyLeading: false,
        centerTitle: true,
        title: Text(
          "Upload video",
          style: TextStyle(color: Colors.black),
        ),
        actions: <Widget>[
          Padding(
            padding: const EdgeInsets.only(right: 8.0),
            child: IconButton(
                color: Colors.red,
                icon: Icon(
                  Icons.close,
                  size: 30,
                ),
                onPressed: () => _confirmCancel()),
          )
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            VideoPlayerScreen(
              videoFile: widget.videoFile,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
              child: TextField(
                // maxLines: 2,
                controller: _description,
                decoration: InputDecoration(
                  labelText: 'Video description',
                  errorText:
                      _validate ? 'Video description can\'t be empty!' : null,
                ),
              ),
            ),
            RaisedButton(
              onPressed: () {
                setState(() {
                  _description.text.isEmpty
                      ? _validate = true
                      : _validate = false;
                });
                _uploadVideo(
                  context,
                  widget.currentUserId,
                  widget.soundName,
                  _description.text,
                  widget.videoFile,
                  widget.thumbnail,
                  // widget.gif,
                );
              },
              child: Text('Submit'),
              textColor: Colors.white,
              color: Colors.deepPurple,
            )

            // Image.file(
            //   widget.thumbnail,
            //   height: 200,
            // ),
            // Image.file(
            //   widget.gif,
            //   height: 200,
            // ),
          ],
        ),
      ),
    );
  }
}
