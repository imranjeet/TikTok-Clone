import 'dart:async';
import 'dart:io';

import 'package:agni_app/Main/Upload/screens/post_video_screen.dart';
import 'package:agni_app/Main/Upload/widgets/file_video_player.dart';
import 'package:flutter/material.dart';
import 'package:flutter_video_compress/flutter_video_compress.dart';

class GalleryVideoScreen extends StatefulWidget {
  final int currentUserId;
  final File videoFile;

  const GalleryVideoScreen({Key key, this.videoFile, this.currentUserId})
      : super(key: key);
  @override
  _GalleryVideoScreenState createState() => _GalleryVideoScreenState();
}

class _GalleryVideoScreenState extends State<GalleryVideoScreen> {
  final _flutterVideoCompress = FlutterVideoCompress();
  Subscription _subscription;
  double _progressState = 0;

  final _loadingStreamCtrl = StreamController<bool>.broadcast();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    _subscription =
        _flutterVideoCompress.compressProgress$.subscribe((progress) {
      setState(() {
        _progressState = progress;
      });
    });
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    _subscription.unsubscribe();
    _loadingStreamCtrl.close();
  }

  String timestamp() => DateTime.now().millisecondsSinceEpoch.toString();

  Future<void> runVideoCompressMethods(
      BuildContext context, File videoFile) async {
    _loadingStreamCtrl.sink.add(true);

    var _startDateTime = DateTime.now();
    // final compressedVideoInfo = await _flutterVideoCompress.compressVideo(
    //   videoFile.path,
    //   quality: VideoQuality.DefaultQuality,
    //   deleteOrigin: false,
    // );
    final thumbnailFile = await _flutterVideoCompress
        .getThumbnailWithFile(videoFile.path, quality: 50);

    _startDateTime = DateTime.now();
    final gifFile = await _flutterVideoCompress
        .convertVideoToGif(videoFile.path, startTime: 0, duration: 10);

    // final videoInfo = await _flutterVideoCompress.getMediaInfo(videoFile.path);

    // setState(() {
    //   _thumbnailFileImage = Image.file(thumbnailFile);
    //   _gifFileImage = Image.file(gifFile);
    //   // _originalVideoInfo = videoInfo;
    //   // _compressedVideoInfo = compressedVideoInfo;
    // });

    _loadingStreamCtrl.sink.add(false);
    if (gifFile != null && thumbnailFile != null) {
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => PostVideoScreen(
                  currentUserId: widget.currentUserId,
                  videoFile: videoFile,
                  thumbnail: thumbnailFile,
                  // gif: gifFile
                  )));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text("Your gallery video"),
      ),
      body: Column(
        children: <Widget>[
          VideoPlayerScreen(
            videoFile: widget.videoFile,
          ),
          RaisedButton(
              child: Text("Confirm"),
              onPressed: () {
                runVideoCompressMethods(context, widget.videoFile);
              }),
          StreamBuilder<bool>(
            stream: _loadingStreamCtrl.stream,
            builder: (context, AsyncSnapshot<bool> snapshot) {
              if (snapshot.data == true) {
                return GestureDetector(
                  onTap: () {
                    _flutterVideoCompress.cancelCompression();
                  },
                  child: Container(
                    color: Colors.transparent,
                    width: MediaQuery.of(context).size.width,
                    // height: MediaQuery.of(context).size.height,
                    child: Center(
                      child: CircularProgressIndicator(),
                    ),
                  ),
                );
              }
              return Container();
            },
          ),
        ],
      ),
    );
  }
}
