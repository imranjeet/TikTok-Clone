import 'dart:convert';
import 'dart:io';

import 'package:agni_app/Main/Upload/widgets/file_video_player.dart';
import 'package:agni_app/utils/local_notification.dart';
import 'package:agni_app/utils/show_loader_dailog.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:percent_indicator/percent_indicator.dart';

class PostVideoScreen extends StatefulWidget {
  final int currentUserId;
  final File videoFile;
  final File thumbnail;
  // final File gif;

  const PostVideoScreen({
    Key key,
    this.videoFile,
    this.thumbnail,
    // this.gif,
    this.currentUserId,
  }) : super(key: key);

  @override
  _PostVideoScreenState createState() => _PostVideoScreenState();
}

class _PostVideoScreenState extends State<PostVideoScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  final _description = TextEditingController();
  bool _validate = false;
  bool _isLoading = false;
  int sent;
  int total;
  int percentage = 0;

  _showSnackMessage(message) {
    var snackBar = SnackBar(
      content: message,
    );
    _scaffoldKey.currentState.showSnackBar(snackBar);
  }

  Future<void> _uploadFile(
    BuildContext context,
    int userId,
    String description,
    File videoFile,
    File thumbnailFile,
    //  File gifFile
  ) async {
    // String fileName = basename(filePath.path);
    // print("file base name:$fileName");

    showLoaderDialog(context, "Uploading...");

    try {
      FormData formData = new FormData.fromMap({
        "userId": userId,
        "description": description,
        "video": await MultipartFile.fromFile(videoFile.path),
        "thumbnail": await MultipartFile.fromFile(thumbnailFile.path),
        // "gif": await MultipartFile.fromFile(gifFile.path),
      });

      Response response = await Dio().post(
        "http://agni-api.infous.xyz/api/store-video",
        data: formData,
        onSendProgress: (int sent, int total) {
          // var _percentage = ((sent ~/ total) * 100).toDouble();
          print("Sent: $sent Total: $total");
          setState(() {
            // this.sent = sent;
            // this.total = total;
            // this.percentage = ((sent ~/ total) * 100);
          });
        },
      );

      print("File upload response: $response");
      if (response != null) {
        setState(() {
          _isLoading = false;
        });
        LocalNotification.success(
          context,
          message: 'Video uploaded successfully!',
          inPostCallback: true,
        );
        int count = 0;
        Navigator.popUntil(context, (route) {
          return count++ == 2;
        });
        // _showSnackMessage(response);
      }
    } catch (e) {
      print(" error expectation Caugch: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
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
                onPressed: () => Navigator.pop(context)),
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
                  _isLoading = true;
                  _description.text.isEmpty
                      ? _validate = true
                      : _validate = false;
                });
                _uploadFile(
                  context,
                  widget.currentUserId,
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
