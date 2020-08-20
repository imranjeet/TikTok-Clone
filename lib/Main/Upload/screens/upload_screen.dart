import 'dart:async';
import 'dart:io';
import 'dart:ui';

import 'package:agni_app/Main/Upload/widgets/record_button_painter.dart';
import 'package:agni_app/Main/Upload/widgets/sound_audio_player.dart';
import 'package:agni_app/Main/Upload/widgets/sound_selection.dart';
import 'package:camera/camera.dart';
import 'package:dio/dio.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_ffmpeg/flutter_ffmpeg.dart';
import 'package:flutter_video_compress/flutter_video_compress.dart';
import 'package:lamp/lamp.dart';
import 'package:path_provider/path_provider.dart';
import 'package:video_player/video_player.dart';
import 'package:path_provider/path_provider.dart' as syspaths;
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
  bool _enableAudio = true;
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
  bool _hasFlash = false;
  bool _isOn = false;
  double _intensity = 1.0;
  String soundUrl;
  var _isLoading = false;
  String soundName;

  @override
  void initState() {
    super.initState();
    initPlatformState();
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
        _initCameraController(cameras[selectedCameraIndex], _enableAudio)
            .then((void v) {});
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

  initPlatformState() async {
    bool hasFlash = await Lamp.hasLamp;
    print("Device has flash ? $hasFlash");
    setState(() {
      _hasFlash = hasFlash;
    });
  }

  String timestamp() => DateTime.now().millisecondsSinceEpoch.toString();

  Future _initCameraController(
      CameraDescription cameraDescription, bool _enableAudio) async {
    if (controller != null) {
      await controller.dispose();
    }
    controller = CameraController(cameraDescription, ResolutionPreset.medium,
        enableAudio: _enableAudio);

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

    final thumbnailFile = await _flutterVideoCompress
        .getThumbnailWithFile(videoFile.path, quality: 50);

    final FlutterFFmpeg _flutterFFmpeg = new FlutterFFmpeg();

    if (thumbnailFile != null && videoFile != null) {
      if (soundUrl != null) {
        final appDir = await syspaths.getApplicationDocumentsDirectory();
        String rawDocumentPath = appDir.path;
        final mergedFilePath = '$rawDocumentPath/output.mp4';
        String commandToExecute =
            '-y -i ${videoFile.path} -i $soundUrl -map 0:v -map 1:a  -shortest $mergedFilePath';
        _flutterFFmpeg.execute(commandToExecute).then((rc) async {
          print("FFmpeg process exited with rc $rc");
          print("Last command output: $mergedFilePath");
          final commpressVideo = await _flutterVideoCompress.compressVideo(
            mergedFilePath,
            quality: VideoQuality.MediumQuality,
            deleteOrigin: false,
          );
          setState(() {
            _isLoading = false;
            soundUrl = null;
          });
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => PostVideoScreen(
                        currentUserId: widget.currentUserId,
                        videoFile: File(commpressVideo.path),
                        thumbnail: thumbnailFile,
                        soundName: soundName,
                        // gif: gifFile
                      )));
        });
      } else {
        setState(() {
          _isLoading = false;
        });
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => PostVideoScreen(
                      currentUserId: widget.currentUserId,
                      videoFile: File(videoFile.path),
                      thumbnail: thumbnailFile,
                      soundName: "",
                      // gif: gifFile
                    )));
      }
    }
    _loadingStreamCtrl.sink.add(false);
  }

  void showDownloadProgress(received, total) {
    if (total != -1) {
      print((received / total * 100).toStringAsFixed(0) + "%");
    }
  }

  Future getVideoFromGallery() async {
    File pickedFile = await FilePicker.getFile(
      type: FileType.video,
      // allowedExtensions: ['mp4',],
    );

    setState(() {
      _isLoading = true;
    });

    // _loadingStreamCtrl.sink.add(true);

    var _startDateTime = DateTime.now();

    final thumbnailFile = await _flutterVideoCompress
        .getThumbnailWithFile(pickedFile.path, quality: 50);

    // final commpressVideo = await _flutterVideoCompress.compressVideo(
    //   pickedFile.path,
    //   quality: VideoQuality.MediumQuality,
    //   deleteOrigin: false,
    // );

    // _loadingStreamCtrl.sink.add(false);

    setState(() {
      _isLoading = false;
    });

    if (pickedFile != null && thumbnailFile != null) {
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => PostVideoScreen(
                    currentUserId: widget.currentUserId,
                    videoFile: File(pickedFile.path),
                    thumbnail: thumbnailFile,
                    soundName: "",
                    // gif: gifFile
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

    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: Colors.black,
      floatingActionButtonLocation: FloatingActionButtonLocation.startTop,
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.transparent,
        onPressed: () {
          timer.cancel();
          onStopButtonPressed();
          setState(() {
            percentage = 0.0;
            newPercentage = 0.0;
            videoActive = false;
            soundUrl = null;
          });
          CameraDescription selectedCamera = cameras[selectedCameraIndex];
          _enableAudio = true;
          _initCameraController(selectedCamera, _enableAudio);
        },
        child: Icon(Icons.refresh),
      ),
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : Container(
              height: MediaQuery.of(context).size.height * .93,
              child: AspectRatio(
                aspectRatio: controller.value.aspectRatio,
                child: Stack(
                  // alignment: Alignment.bottomCenter,
                  children: <Widget>[
                    CameraPreview(controller),
                    Padding(
                      padding: const EdgeInsets.only(top: 40.0),
                      child: Align(
                        alignment: Alignment.topCenter,
                        child: soundUrl == null
                            ? RaisedButton(
                                color: Colors.purple[400],
                                child: Text(
                                  "Add sound",
                                  style: TextStyle(color: Colors.white),
                                ),
                                onPressed: () {
                                  _soundSelection(context);
                                },
                              )
                            : SoundAudioPlayer(soundItem: soundUrl),
                      ),
                    ),
                    Align(
                      alignment: Alignment.topRight,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 40),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: <Widget>[
                            GestureDetector(
                                child: new Icon(
                                  _isOn ? Icons.flash_off : Icons.flash_on,
                                  size: 35,
                                  color: Colors.white,
                                ),
                                onTap: _turnFlash),
                            SizedBox(
                              height: 35,
                            ),
                            _toggleAudioWidget(),
                          ],
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 15),
                      child: Align(
                        alignment: Alignment.bottomCenter,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: <Widget>[
                            // videoActive
                            //     ? _videoRecordingController()
                            //     :
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
                  ],
                ),
              ),
            ),
    );
  }

  Future _turnFlash() async {
    _isOn ? Lamp.turnOff() : Lamp.turnOn(intensity: _intensity);
    var f = await Lamp.hasLamp;
    setState(() {
      _hasFlash = f;
      _isOn = !_isOn;
    });
  }

  // _intensityChanged(double intensity) {
  //   Lamp.turnOn(intensity: intensity);
  //   setState(() {
  //     _intensity = intensity;
  //   });
  // }

  Widget _videoRecordingCheck() {
    return Container(
      height: 40,
      width: 40,
      child: FloatingActionButton(
        backgroundColor: Colors.deepPurple,
        child: Icon(
          Icons.check,
          color: Colors.white,
          size: 30,
        ),
        onPressed: () {
          setState(() {
            percentage = 0.0;
            newPercentage = 0.0;
            videoActive = false;
            // soundUrl = null;
            _isLoading = true;
          });
          timer.cancel();
          onStopButtonPressed();

          runVideoCompressMethods(File(videoPath));
        },
      ),
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
                          "${((percentage) ~/ 363).toInt()}\tsec",
                          // percentage.toString(),
                          style: TextStyle(
                            color: Colors.white,
                            // fontWeight: FontWeight.bold,
                          ),
                        )
                      : Text(
                          "Tap",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 12,
                          ),
                        ),
                ),
                decoration: BoxDecoration(
                  color: Color(0xFFee5253),
                  borderRadius: BorderRadius.circular(50),
                ),
              ),
              // onLongPressEnd: (details) {
              //   onPauseButtonPressed();
              //   timer.cancel();
              // },
              // onSecondaryLongPress: () {
              //   onResumeButtonPressed();
              //   timer = newTimer();
              // },
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
        if (newPercentage > 5450.0) {
          percentage = 0.0;
          newPercentage = 0.0;
          timer.cancel();
          onStopButtonPressed();
          setState(() {
            soundUrl = null;
            videoActive = false;
            _isLoading = true;
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

  Widget _toggleAudioWidget() {
    return _enableAudio
        ? GestureDetector(
            child: Icon(
              Icons.mic,
              size: 30,
              color: Colors.red,
            ),
            onTap: () {
              CameraDescription selectedCamera = cameras[selectedCameraIndex];
              _enableAudio = false;
              _initCameraController(selectedCamera, _enableAudio);
              setState(() {
                _enableAudio = false;
              });
            },
          )
        : GestureDetector(
            child: Icon(
              Icons.mic_off,
              size: 30,
              color: Colors.white,
            ),
            onTap: () {
              CameraDescription selectedCamera = cameras[selectedCameraIndex];
              _enableAudio = true;
              _initCameraController(selectedCamera, _enableAudio);
              setState(() {
                _enableAudio = true;
              });
            },
          );
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
    _initCameraController(selectedCamera, _enableAudio);
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
    });
  }

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

  _soundSelection(BuildContext context) async {
    Map selectedSound = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => SelectionSound()),
    );
    print("selected song: $selectedSound");
    setState(() {
      soundUrl = selectedSound['path'];
      soundName = selectedSound['soundName'];
    });
  }
}
