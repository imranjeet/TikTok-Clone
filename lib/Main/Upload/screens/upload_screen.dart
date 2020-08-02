import 'dart:async';
import 'dart:io';

import 'package:camera/camera.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_video_compress/flutter_video_compress.dart';
import 'package:path_provider/path_provider.dart';
import 'package:uuid/uuid.dart';
import 'package:video_player/video_player.dart';

import 'post_video_screen.dart';

class UploadScreen extends StatefulWidget {
  @override
  _UploadScreenState createState() => _UploadScreenState();
}

class _UploadScreenState extends State {
  final _flutterVideoCompress = FlutterVideoCompress();
  Subscription _subscription;

  Image _thumbnailFileImage;
  Image _gifFileImage;
  double _progressState = 0;

  final _loadingStreamCtrl = StreamController<bool>.broadcast();

  CameraController controller;
  List cameras;
  int selectedCameraIndex;
  int selectVideoIndex;
  String imgPath;
  String videoPath;
  VideoPlayerController videoController;
  VoidCallback videoPlayerListener;
  bool enableAudio = true;
  bool videoPause = false;
  bool videoActive = false;
  String imagePath;

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    _subscription =
        _flutterVideoCompress.compressProgress$.subscribe((progress) {
      setState(() {
        _progressState = progress;
      });
    });
    availableCameras().then((availableCameras) {
      cameras = availableCameras;

      if (cameras.length > 0) {
        setState(() {
          selectedCameraIndex = 1;
        });
        _initCameraController(cameras[selectedCameraIndex]).then((void v) {});
      } else {
        print('No camera available');
      }
    }).catchError((err) {
      print('Error :${err.code}Error message : ${err.message}');
    });
  }

  Future _initCameraController(CameraDescription cameraDescription) async {
    if (controller != null) {
      await controller.dispose();
    }
    controller = CameraController(cameraDescription, ResolutionPreset.high);

    controller.addListener(() {
      if (mounted) {
        setState(() {});
      }

      if (controller.value.hasError) {
        print('Camera error ${controller.value.errorDescription}');
      }
    });

    try {
      await controller.initialize();
    } on CameraException catch (e) {
      _showCameraException(e);
    }
    if (mounted) {
      setState(() {});
    }
  }

  @override
  void dispose() {
    super.dispose();
    _subscription.unsubscribe();
    _loadingStreamCtrl.close();
  }

  Future<void> runFlutterVideoCompressMethods(File videoFile) async {
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
        .convertVideoToGif(videoFile.path, startTime: 0, duration: 5);

    // final videoInfo = await _flutterVideoCompress.getMediaInfo(videoFile.path);

    setState(() {
      _thumbnailFileImage = Image.file(thumbnailFile);
      _gifFileImage = Image.file(gifFile);
      // _originalVideoInfo = videoInfo;
      // _compressedVideoInfo = compressedVideoInfo;
    });

    _loadingStreamCtrl.sink.add(false);
    if (gifFile != null && thumbnailFile != null) {
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => PostVideoScreen(
                  videoFile: File(videoPath),
                  thumbnail: thumbnailFile,
                  gif: gifFile)));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      key: _scaffoldKey,
      body: Stack(
        children: <Widget>[
          _cameraPreviewWidget(),
          Padding(
            padding: const EdgeInsets.all(7.0),
            child: Align(
              alignment: Alignment.bottomCenter,
                          child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: <Widget>[
                  FloatingActionButton(
                      backgroundColor: Colors.transparent,
                      heroTag: Uuid(),
                      child: Icon(
                        Icons.file_upload,
                        size: 30,
                        color: Colors.white,
                      ),
                      onPressed: () {}),
                  Padding(
                    padding: const EdgeInsets.only(left: 60.0, right: 15),
                    child: _videoControlWidget(context),
                  ),
                  videoActive
                      ? Container(
                          height: 42,
                          child: FloatingActionButton(
                            heroTag: Uuid(),
                            child: Icon(
                              Icons.check,
                              color: Colors.white,
                              size: 30,
                            ),
                            backgroundColor: Colors.deepPurpleAccent,
                            onPressed: () {
                              onStopButtonPressed();
                              setState(() {
                                videoActive = false;
                              });
                              runFlutterVideoCompressMethods(File(videoPath));
                            },
                          ),
                        )
                      : SizedBox.shrink(),
                  videoActive ? SizedBox.shrink() : _cameraToggleRowWidget(),
                  
                ],
              ),
            ),
          ),
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
                          // width: MediaQuery.of(context).size.width,
                          // height: MediaQuery.of(context).size.height,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            // mainAxisSize: MainAxisSize.max,
                            children: [
                              // LinearPercentIndicator(
                              //   width: 100.0,
                              //   lineHeight: 8.0,
                              //   percent: _progressState,
                              //   progressColor: Colors.orange,
                              // ),
                              CircularProgressIndicator(),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(
                                  '$_progressState％',
                                  style: TextStyle(color: Colors.white),
                                ),
                              ),
                            ],
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

  Widget _cameraPreviewWidget() {
    if (controller == null || !controller.value.isInitialized) {
      return Center(
        child: const Text(
          'Loading...',
          style: TextStyle(
            color: Colors.white,
            fontSize: 28.0,
            fontWeight: FontWeight.w900,
          ),
        ),
      );
    }

    return AspectRatio(
      aspectRatio: controller.value.aspectRatio,
      child: CameraPreview(controller),
    );
  }

  Widget _videoControlWidget(contaxt) {
    if (videoActive) {
      return videoPause
          ? FloatingActionButton(
              heroTag: Uuid(),
              child: Icon(
                Icons.play_arrow,
                color: Colors.black,
                size: 35,
              ),
              backgroundColor: Colors.white,
              onPressed: () {
                onResumeButtonPressed();
              },
            )
          : FloatingActionButton(
              heroTag: Uuid(),
              child: Icon(
                Icons.pause,
                color: Colors.white,
                size: 35,
              ),
              backgroundColor: Colors.red,
              onPressed: () {
                onPauseButtonPressed();
              },
            );
    } else {
      return FloatingActionButton(
        heroTag: Uuid(),
        child: Icon(
          Icons.camera,
          color: Colors.white,
          size: 35,
        ),
        backgroundColor: Colors.purple,
        onPressed: () {
          onVideoRecordButtonPressed();
        },
      );
    }
  }

  Widget _cameraToggleRowWidget() {
    if (cameras == null || cameras.isEmpty) {
      return SizedBox.shrink();
    }
    CameraDescription selectedCamera = cameras[selectedCameraIndex];
    CameraLensDirection lensDirection = selectedCamera.lensDirection;

    return FloatingActionButton(
      heroTag: Uuid(),
      onPressed: _onSwitchCamera,
      backgroundColor: Colors.transparent,
      child: Icon(
        _getCameraLensIcon(lensDirection),
        color: Colors.white,
        size: 35,
      ),
      // label: Text(
      //   '${lensDirection.toString().substring(lensDirection.toString().indexOf('.') + 1).toUpperCase()}',
      //   style: TextStyle(color: Colors.white, fontWeight: FontWeight.w500),
      // ),
    );
  }

  IconData _getCameraLensIcon(CameraLensDirection direction) {
    switch (direction) {
      case CameraLensDirection.back:
        return CupertinoIcons.switch_camera;
      case CameraLensDirection.front:
        return CupertinoIcons.switch_camera_solid;
      case CameraLensDirection.external:
        return Icons.camera;
      default:
        return Icons.device_unknown;
    }
  }

  void _showCameraException(CameraException e) {
    String errorText = 'Error:${e.code}\nError message : ${e.description}';
    print(errorText);
  }

  void _onSwitchCamera() {
    selectedCameraIndex =
        selectedCameraIndex < cameras.length - 1 ? selectedCameraIndex + 1 : 0;
    CameraDescription selectedCamera = cameras[selectedCameraIndex];
    _initCameraController(selectedCamera);
  }

  void showInSnackBar(String message) {
    _scaffoldKey.currentState.showSnackBar(SnackBar(content: Text(message)));
  }

  void onVideoRecordButtonPressed() {
    startVideoRecording().then((String filePath) {
      if (mounted)
        setState(() {
          videoActive = true;
        });
      if (filePath != null) print('Saving video to $filePath');
    });
  }

  void onStopButtonPressed() {
    stopVideoRecording().then((_) {
      if (mounted) setState(() {});
      print('Video recorded to: $videoPath');
    });
  }

  void onPauseButtonPressed() {
    pauseVideoRecording().then((_) {
      if (mounted)
        setState(() {
          videoPause = true;
        });
      // showInSnackBar('Video recording paused');
    });
  }

  void onResumeButtonPressed() {
    resumeVideoRecording().then((_) {
      if (mounted)
        setState(() {
          videoPause = false;
        });
      // showInSnackBar('Video recording resumed');
    });
  }

  String timestamp() => DateTime.now().millisecondsSinceEpoch.toString();

  Future<String> startVideoRecording() async {
    if (!controller.value.isInitialized) {
      showInSnackBar('Error: select a camera first.');
      return null;
    }

    final Directory extDir = await getApplicationDocumentsDirectory();
    final String dirPath = '${extDir.path}/Movies/flutter_test';
    await Directory(dirPath).create(recursive: true);
    final String filePath = '$dirPath/${timestamp()}.mp4';

    if (controller.value.isRecordingVideo) {
      // A recording is already started, do nothing.
      return null;
    }

    try {
      videoPath = filePath;
      await controller.startVideoRecording(filePath);
    } on CameraException catch (e) {
      _showCameraException(e);
      return null;
    }
    return filePath;
  }

  Future<void> stopVideoRecording() async {
    if (!controller.value.isRecordingVideo) {
      return null;
    }

    try {
      await controller.stopVideoRecording();
    } on CameraException catch (e) {
      _showCameraException(e);
      return null;
    }

    // await _startVideoPlayer();
  }

  Future<void> pauseVideoRecording() async {
    if (!controller.value.isRecordingVideo) {
      return null;
    }

    try {
      await controller.pauseVideoRecording();
    } on CameraException catch (e) {
      _showCameraException(e);
      rethrow;
    }
  }

  Future<void> resumeVideoRecording() async {
    if (!controller.value.isRecordingVideo) {
      return null;
    }

    try {
      await controller.resumeVideoRecording();
    } on CameraException catch (e) {
      _showCameraException(e);
      rethrow;
    }
  }

  Future<void> _startVideoPlayer() async {
    final VideoPlayerController vcontroller =
        VideoPlayerController.file(File(videoPath));
    videoPlayerListener = () {
      if (videoController != null && videoController.value.size != null) {
        // Refreshing the state to update video player with the correct ratio.
        if (mounted) setState(() {});
        videoController.removeListener(videoPlayerListener);
      }
    };
    vcontroller.addListener(videoPlayerListener);
    await vcontroller.setLooping(true);
    await vcontroller.initialize();
    await videoController?.dispose();
    if (mounted) {
      setState(() {
        imagePath = null;
        videoController = vcontroller;
      });
    }
    await vcontroller.play();
  }
}
