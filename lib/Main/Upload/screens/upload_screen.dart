import 'dart:async';
import 'dart:io';
import 'dart:ui';

import 'package:agni_app/Main/Upload/screens/gallery_video_screen.dart';
import 'package:agni_app/Main/Upload/widgets/record_button_painter.dart';
import 'package:camera/camera.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_video_compress/flutter_video_compress.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:video_player/video_player.dart';

import 'post_video_screen.dart';

class UploadScreen extends StatefulWidget {
  final int currentUserId;

  const UploadScreen({Key key, this.currentUserId}) : super(key: key);
  @override
  _UploadScreenState createState() => _UploadScreenState();
}

class _UploadScreenState extends State<UploadScreen>
    with TickerProviderStateMixin {
  final _flutterVideoCompress = FlutterVideoCompress();
  Subscription _subscription;
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
  // String imagePath;

  int intervalTime = 10;
  DateTime dateTimeStart;
  Duration totalVideoDuration = Duration(seconds: 0);

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  double percentage = 0.0;
  double newPercentage = 0.0;
  double videoTime = 0.0;
  Timer timer;
  AnimationController percentageAnimationController;
  final _picker = ImagePicker();

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

    setState(() {
      percentage = 0.0;
    });
    percentageAnimationController = new AnimationController(
        vsync: this, duration: new Duration(milliseconds: 1000))
      ..addListener(() {
        setState(() {
          percentage = lerpDouble(
              percentage, newPercentage, percentageAnimationController.value);
        });
      });
  }

  String timestamp() => DateTime.now().millisecondsSinceEpoch.toString();

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

  Future<void> runVideoCompressMethods(File videoFile) async {
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
                  videoFile: File(videoPath),
                  thumbnail: thumbnailFile,
                  gif: gifFile)));
    }
  }

  Future getVideoFromGallery() async {
    final pickedFile = await _picker.getVideo(
        source: ImageSource.gallery, maxDuration: const Duration(seconds: 10));

    if (pickedFile != null) {
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => GalleryVideoScreen(
                    currentUserId: widget.currentUserId,
                    videoFile: File(pickedFile.path),
                  )));
    }
  }

  @override
  Widget build(BuildContext context) {
    if (controller == null || !controller.value.isInitialized) {
      return Scaffold(
        backgroundColor: Colors.black,
        body: Center(
          child: const Text(
            'Loading...',
            style: TextStyle(
              color: Colors.white,
              fontSize: 28.0,
              fontWeight: FontWeight.w900,
            ),
          ),
        ),
      );
    }

    return AspectRatio(
      aspectRatio: controller.value.aspectRatio,
      key: _scaffoldKey,
      child: Stack(
        children: <Widget>[
          CameraPreview(controller),
          Padding(
            padding: const EdgeInsets.all(25.0),
            child: Align(
              alignment: Alignment.bottomCenter,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: <Widget>[
                  videoActive
                      ? _videoRecordingController()
                      : _videoUploadControl(),
                  _videoControlWidget(),
                  videoActive
                      ? _videoRecordingCheck()
                      : _cameraToggleRowWidget(),
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
                    width: MediaQuery.of(context).size.width,
                    height: MediaQuery.of(context).size.height,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        // LinearPercentIndicator(
                        //   width: 100.0,
                        //   lineHeight: 8.0,
                        //   percent: _progressState,
                        //   progressColor: Colors.orange,
                        // ),
                        CircularProgressIndicator(),
                        // Padding(
                        //   padding: const EdgeInsets.all(8.0),
                        //   child: Text(
                        //     '$_progressState％',
                        //     style: TextStyle(color: Colors.white),
                        //   ),
                        // ),
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

  Widget _videoRecordingCheck() {
    return GestureDetector(
      child: Icon(
        Icons.check,
        color: Colors.white,
        size: 30,
      ),
      onTap: () {
        setState(() {
          percentage = 0.0;
          newPercentage = 0.0;
        });
        timer.cancel();
        onStopButtonPressed();
        setState(() {
          videoActive = false;
        });
        runVideoCompressMethods(File(videoPath));
      },
    );
  }

  Widget _videoControlWidget() {
    return Container(
      height: 80.0,
      width: 80.0,
      child: new CustomPaint(
        foregroundPainter: new RecordButtonPainter(
            lineColor: Colors.black12,
            completeColor: Color(0xFFee5253),
            completePercent: percentage,
            width: 5.0),
        child: Padding(
          padding: const EdgeInsets.all(5.0),
          child: new Container(
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(70.0),
                border: Border.all(
                  color: Colors.white,
                  width: 4.0,
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black12,
                    blurRadius: 2.0,
                  ),
                ]),
            child: GestureDetector(
              onTap: () {
                onVideoRecordButtonPressed();
                timer = newTimer();
              },
              child: Container(
                child: Center(
                  child: videoActive
                      ? Text(
                          "${((percentage) ~/ 1000).toInt()}\tsec",
                          // percentage.toString(),
                          style: TextStyle(
                            color: Colors.white,
                            // fontWeight: FontWeight.bold,
                          ),
                        )
                      : Text(
                          "Tap",
                          style: TextStyle(
                            color: Colors.red,
                          ),
                        ),
                ),
                decoration: BoxDecoration(
                  color: Color(0xFFee5253),
                  borderRadius: BorderRadius.circular(50),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Timer newTimer() {
    return new Timer.periodic(
      Duration(milliseconds: 1),
      (Timer t) => setState(() {
        percentage = newPercentage;
        newPercentage += 1;
        if (newPercentage > 10000.0) {
          percentage = 0.0;
          newPercentage = 0.0;
          timer.cancel();
          onStopButtonPressed();
          setState(() {
            videoActive = false;
          });
          runVideoCompressMethods(File(videoPath));
        }
        percentageAnimationController.forward(from: 0.0);
        // print((t.tick / 1000).toStringAsFixed(0));
      }),
    );
  }

  Widget _videoUploadControl() {
    return GestureDetector(
        child: Icon(
          Icons.file_upload,
          size: 30,
          color: Colors.white,
        ),
        onTap: () {
          getVideoFromGallery();
        });
  }

  Widget _videoRecordingController() {
    return videoPause
        ? GestureDetector(
            child: Icon(
              Icons.play_arrow,
              color: Colors.white,
              size: 35,
            ),
            onTap: () {
              onResumeButtonPressed();
              timer = newTimer();
            },
          )
        : GestureDetector(
            child: Icon(
              Icons.pause,
              color: Colors.white,
              size: 35,
            ),
            onTap: () {
              onPauseButtonPressed();
              timer.cancel();
            },
          );
  }

  Widget _cameraToggleRowWidget() {
    if (cameras == null || cameras.isEmpty) {
      return SizedBox.shrink();
    }
    CameraDescription selectedCamera = cameras[selectedCameraIndex];
    CameraLensDirection lensDirection = selectedCamera.lensDirection;

    return GestureDetector(
      onTap: _onSwitchCamera,
      child: Icon(
        _getCameraLensIcon(lensDirection),
        color: Colors.white,
        size: 35,
      ),
    );
  }

  IconData _getCameraLensIcon(CameraLensDirection direction) {
    switch (direction) {
      case CameraLensDirection.back:
        return CupertinoIcons.switch_camera_solid;
      case CameraLensDirection.front:
        return CupertinoIcons.switch_camera;
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

  // String timestamp() => DateTime.now().millisecondsSinceEpoch.toString();

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
      setState(() {
        videoPath = filePath;
      });
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
}
