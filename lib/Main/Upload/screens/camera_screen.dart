import 'package:flutter/material.dart';
import 'dart:io';

import 'package:camera/camera.dart';
import 'package:path_provider/path_provider.dart';

//import './play_video.dart';

class CamRenderer extends StatefulWidget {
  CameraController controller;

  CamRenderer(this.controller);

  @override
  _CamRendererState createState() => _CamRendererState();
}

class _CamRendererState extends State<CamRenderer> {
  String path;
  File filePath;

  int intervalTime = 10; // 30 seconds

  DateTime dateTimeStart;
  Duration totalVideoDuration = Duration(seconds: 0);

  @override
  void initState() {
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: <Widget>[
          CameraPreview(
            widget.controller
          ),
          Positioned(
            bottom: 5.0,
            left: 5.0,
            child: RaisedButton(
              child: Text('Stop'),
              onPressed: () {
                if( widget.controller.value.isRecordingVideo || widget.controller.value.isRecordingPaused ) {
                  print('Stop recording');
                  widget.controller.stopVideoRecording().then(
                    (_) {
                      print('###########################');
                      print('Video recording stopped');
                      totalVideoDuration = Duration(seconds: 0);
                      print(path);
                      filePath = File(path);
                      print(filePath);
                      print('###########################');
                    }
                  );
                } else {  
                  print('No active video recording to stop');
                }
              },
            ),
          ),
          Positioned(
            bottom: 5.0,
            right: 5.0,
            child: GestureDetector(
              child: Container(
                color: Colors.white,
                child: SizedBox(
                  child: Center(
                    child: Text(
                      'Record',
                      style: TextStyle(
                        fontSize: 16.0,
                        color: Colors.red
                      ),
                    )
                  ),
                  height: 40.0,
                  width: 60.0,
                ),
              ),
              onLongPressStart: (data ) {
                print('#######################################################');
                print('onLongPressStart');

                if( ! widget.controller.value.isRecordingVideo ) {
                  print('When user long presses and holds for the first time');
                  dateTimeStart = DateTime.now();
                  print('Video start time: $dateTimeStart');
                  getTemporaryDirectory().then(
                    (dir) {
                      path = dir.path + '$dateTimeStart.mp4';
                      print('Starting video recording');
                      widget.controller.startVideoRecording(path).then(
                        (_) {
                          print('**************');
                          print('Video recording started');
                          print('Video file name: $path');
                          print('**************');
                        }
                      );
                    }
                  );
                }
                
                print('Before resuming the video');
                print('Total video duration: ${totalVideoDuration.inSeconds} s');
                if( ( widget.controller.value.isRecordingVideo || widget.controller.value.isRecordingPaused ) ) {
                  if( totalVideoDuration.inSeconds <= intervalTime ) {
                    print('Resuming');
                    widget.controller.resumeVideoRecording().then(
                      (_) {
                        print('**************');
                        print('Video recording resumed');
                        dateTimeStart = DateTime.now();
                        print('Current time: $dateTimeStart');
                        print('**************');
                      }
                    );
                  } else {
                    print('Total video duration is greater than 30s');
                    print('Total video duration: ${totalVideoDuration.inSeconds} s');
                    print('Stopping');
                    print('Debug>>');
                    print(widget.controller.value.isRecordingVideo);
                    print(widget.controller.value.isRecordingPaused);
                    widget.controller.stopVideoRecording().then(
                      (_) {
                        print('**************');
                        print('Video recording is stopped');
                        totalVideoDuration = Duration(seconds: 0);
                        print(path);
                        filePath = File(path);
                        print(filePath);
                        print('**************');
                      }
                    ).catchError( (err) {
                      print('**************');
                      print('Error while stopping the video');
                      totalVideoDuration = Duration(seconds: 0);
                      print(err.toString());
                      print('**************');
                    });
                  }
                } 
                print('#######################################################');
              },
              onLongPressEnd: (data) {
                print('#######################################################');
                print('onLongPressEnd');
                if( widget.controller.value.isRecordingVideo || widget.controller.value.isRecordingPaused ) {
                  print('Pausing');
                  widget.controller.pauseVideoRecording().then(
                    (_) {
                      print('**************');
                      print('Video recording is paused');
                      DateTime currentTime = DateTime.now();
                      print('Current time: $currentTime');
                      int tempTotalDuration = totalVideoDuration.inSeconds;
                      print('Previous total duration: $tempTotalDuration');
                      totalVideoDuration = currentTime.difference(dateTimeStart);
                      print('Intermediate total duration: ${totalVideoDuration.inSeconds} s');
                      totalVideoDuration = Duration(seconds: totalVideoDuration.inSeconds + tempTotalDuration );
                      print('Total Video duration : ${totalVideoDuration.inSeconds} s');
                      print('**************');
                    }
                  );
                }
                print('#######################################################');
              },
            ),
          ),
          Positioned(
            left: 5.0,
            top: 25.0,
            child: RaisedButton(
              child: Text('View'),
              onPressed: () {
                if( filePath != null ) {
                  //Navigator.push(
                  //  context, 
                  //  MaterialPageRoute(
                  //    builder: (context) => VideoPlayerApp(filePath)
                  //  )
                  //); 
                }
              },
            ),
          )
        ],
      ),
    );
  }
}
// import 'dart:async';
// import 'dart:io';

// import 'package:camera/camera.dart';
// import 'package:path_provider/path_provider.dart';
// import 'package:flutter/material.dart';
// import 'package:video_player/video_player.dart';

// class CameraHomeScreen extends StatefulWidget {
//   // List<CameraDescription> cameras;

//   // CameraHomeScreen(this.cameras);

//   @override
//   State<StatefulWidget> createState() {
//     return _CameraHomeScreenState();
//   }
// }

// class _CameraHomeScreenState extends State<CameraHomeScreen> {
//   CameraController controller;
//   List cameras;
//   String imagePath;
//   bool _toggleCamera = false;
//   bool _startRecording = false;
//   final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

//   final String _assetVideoRecorder = 'assets/images/ic_video_shutter.png';
//   final String _assetStopVideoRecorder = 'assets/images/ic_stop_video.png';

//   String videoPath;
//   VideoPlayerController videoController;
//   VoidCallback videoPlayerListener;

//   @override
//   void initState() {
//     availableCameras().then((availableCameras) {
//       cameras = availableCameras;
//     }).catchError((err) {
//       print('Error :${err.code}Error message : ${err.message}');
//     });
//     try {
//       onCameraSelected(cameras[0]);
//     } catch (e) {
//       print(e.toString());
//     }
    
//     super.initState();
//   }

//   @override
//   void dispose() {
//     controller?.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     if (cameras.isEmpty) {
//       return Container(
//         alignment: Alignment.center,
//         padding: EdgeInsets.all(16.0),
//         child: Text(
//           'No Camera Found!',
//           style: TextStyle(
//             fontSize: 16.0,
//             color: Colors.white,
//           ),
//         ),
//       );
//     }

//     if (!controller.value.isInitialized) {
//       return Container();
//     }

//     return AspectRatio(
//       key: _scaffoldKey,
//       aspectRatio: controller.value.aspectRatio,
//       child: Container(
//         child: Stack(
//           children: <Widget>[
//             CameraPreview(controller),
//             Align(
//               alignment: Alignment.bottomCenter,
//               child: Container(
//                 width: double.infinity,
//                 height: 120.0,
//                 padding: EdgeInsets.all(20.0),
//                 color: Color.fromRGBO(00, 00, 00, 0.7),
//                 child: Stack(
//                   //mainAxisAlignment: MainAxisAlignment.center,
//                   children: <Widget>[
//                     Align(
//                       alignment: Alignment.center,
//                       child: Material(
//                         color: Colors.transparent,
//                         child: InkWell(
//                           borderRadius: BorderRadius.all(Radius.circular(50.0)),
//                           onTap: () {
//                             !_startRecording
//                                 ? onVideoRecordButtonPressed()
//                                 : onStopButtonPressed();
//                             setState(() {
//                               _startRecording = !_startRecording;
//                             });
//                           },
//                           child: Container(
//                             padding: EdgeInsets.all(4.0),
//                             child: Image.asset(
//                               !_startRecording
//                                   ? _assetVideoRecorder
//                                   : _assetStopVideoRecorder,
//                               width: 72.0,
//                               height: 72.0,
//                             ),
//                           ),
//                         ),
//                       ),
//                     ),
//                     !_startRecording ? _getToggleCamera() : new Container(),
//                   ],
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _getToggleCamera() {
//     return Align(
//       alignment: Alignment.centerRight,
//       child: Material(
//         color: Colors.transparent,
//         child: InkWell(
//           borderRadius: BorderRadius.all(Radius.circular(50.0)),
//           onTap: () {
//             !_toggleCamera
//                 ? onCameraSelected(cameras[1])
//                 : onCameraSelected(cameras[0]);
//             setState(() {
//               _toggleCamera = !_toggleCamera;
//             });
//           },
//           child: Container(
//             padding: EdgeInsets.all(4.0),
//             child: Icon(Icons.switch_camera, size: 42,),
//           ),
//         ),
//       ),
//     );
//   }

//   void onCameraSelected(CameraDescription cameraDescription) async {
//     if (controller != null) await controller.dispose();
//     controller = CameraController(cameraDescription, ResolutionPreset.medium);

//     controller.addListener(() {
//       if (mounted) setState(() {});
//       if (controller.value.hasError) {
//         showSnackBar('Camera Error: ${controller.value.errorDescription}');
//       }
//     });

//     try {
//       await controller.initialize();
//     } on CameraException catch (e) {
//       _showException(e);
//     }

//     if (mounted) setState(() {});
//   }

//   String timestamp() => new DateTime.now().millisecondsSinceEpoch.toString();

//   void setCameraResult() {
//     print("Recording Done!");
//     Navigator.pop(context, videoPath);
//   }

//   void onVideoRecordButtonPressed() {
//     print('onVideoRecordButtonPressed()');
//     startVideoRecording().then((String filePath) {
//       if (mounted) setState(() {});
//       if (filePath != null) showSnackBar('Saving video to $filePath');
//     });
//   }

//   void onStopButtonPressed() {
//     stopVideoRecording().then((_) {
//       if (mounted) setState(() {});
//       showSnackBar('Video recorded to: $videoPath');
//     });
//   }

//   Future<String> startVideoRecording() async {
//     if (!controller.value.isInitialized) {
//       showSnackBar('Error: select a camera first.');
//       return null;
//     }

//     final Directory extDir = await getApplicationDocumentsDirectory();
//     final String dirPath = '${extDir.path}/Videos';
//     await new Directory(dirPath).create(recursive: true);
//     final String filePath = '$dirPath/${timestamp()}.mp4';

//     if (controller.value.isRecordingVideo) {
//       return null;
//     }

//     try {
//       videoPath = filePath;
//       await controller.startVideoRecording(filePath);
//     } on CameraException catch (e) {
//       _showException(e);
//       return null;
//     }
//     return filePath;
//   }

//   Future<void> stopVideoRecording() async {
//     if (!controller.value.isRecordingVideo) {
//       return null;
//     }

//     try {
//       await controller.stopVideoRecording();
//     } on CameraException catch (e) {
//       _showException(e);
//       return null;
//     }

//     setCameraResult();
//   }

//   void _showException(CameraException e) {
//     logError(e.code, e.description);
//     showSnackBar('Error: ${e.code}\n${e.description}');
//   }

//   void showSnackBar(String message) {
//     print(message);
//   }

//   void logError(String code, String message) =>
//       print('Error: $code\nMessage: $message');
// }
