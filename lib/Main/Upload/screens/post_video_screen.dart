import 'dart:convert';
import 'dart:io';

import 'package:agni_app/Main/Upload/widgets/file_video_player.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:path/path.dart';
import 'package:async/async.dart';

class PostVideoScreen extends StatefulWidget {
  final int currentUserId;
  final File videoFile;
  final File thumbnail;
  final File gif;

  const PostVideoScreen({
    Key key,
    this.videoFile,
    this.thumbnail,
    this.gif,
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

  // ignore: unused_element
  _showSnackMessage(message) {
    var snackBar = SnackBar(
      content: message,
    );
    _scaffoldKey.currentState.showSnackBar(snackBar);
  }

  // Future<void> _postVideoToServer(String description, File _video) async {
  //   // var url = 'http://agni-api.infous.xyz/api/store-video';
  //   try {
  //     print("Image Path Got on Controller : $_video");
  //     Uri url = Uri.parse('http://agni-api.infous.xyz/api/store-video');
  //     var sendRequest = http.MultipartRequest("POST", url);
  //     sendRequest.fields['description'] = description;
  //     var vid = await http.MultipartFile.fromPath(
  //       "video",
  //       _video.path,
  //     );
  //     sendRequest.files.add(vid);
  //     http.StreamedResponse response = await sendRequest.send();
  //     final finalResp = await http.Response.fromStream(response);
  //     // return true;
  //     print(finalResp.body);
  //   } on SocketException {
  //     print("No Internet while uploading bill");
  //     // return false;
  //   } catch (e) {
  //     print("ERROR ON UPLOADING BILL : $e");
  //     // return false;
  //   }
  // }

  void _uploadFile(String description, File filePath) async {
    String fileName = basename(filePath.path);
    print("file base name:$fileName");

    try {
      FormData formData = new FormData.fromMap({
        "description": description,
        "video": await MultipartFile.fromFile(filePath.path),
      });

      Response response = await Dio()
          .post("http://agni-api.infous.xyz/api/store-video", data: formData);
      print("File upload response: $response");
      if (response.statusCode == 200) {
        setState(() {
          _isLoading = false;
        });
      }
      _showSnackMessage(response.data['message']);
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
        backgroundColor: Colors.red,
        title: Text("Post Video"),
      ),
      body: Container(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            VideoPlayerScreen(
              videoFile: widget.videoFile,
            ),
            TextField(
              controller: _description,
              decoration: InputDecoration(
                labelText: 'Video description',
                errorText: _validate ? 'Value Can\'t Be Empty' : null,
              ),
            ),
            _isLoading
                ? Center(
                    child: CircularProgressIndicator(),
                  )
                : RaisedButton(
                    onPressed: () {
                      setState(() {
                        _isLoading = true;
                        _description.text.isEmpty
                            ? _validate = true
                            : _validate = false;
                      });
                      _uploadFile(_description.text, widget.videoFile);
                    },
                    child: Text('Submit'),
                    textColor: Colors.white,
                    color: Colors.blueAccent,
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
