import 'package:video_player/video_player.dart';
import 'package:flutter/material.dart';
import 'package:visibility_detector/visibility_detector.dart';


class VideoPlayerScreen extends StatefulWidget {
  final String videoLink;
  final bool isDirect;

  const VideoPlayerScreen({
    Key key,
    this.videoLink,
    this.isDirect,
  }) : super(key: key);

  @override
  _VideoPlayerScreenState createState() => _VideoPlayerScreenState();
}

class _VideoPlayerScreenState extends State<VideoPlayerScreen> {
  VideoPlayerController _controller;

  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.network(widget.videoLink);

    _controller.addListener(() {
      setState(() {});
    });

    _controller.setLooping(true);
    _controller.play();

    _controller.initialize().then((_) {
      setState(() {});
      // if (mounted) {
      //   setState(() {});
      //   _controller.play();
      // }
    });
  }

  // @override
  // void didChangeDependencies() {
  //   routeObserver.subscribe(this, ModalRoute.of(context)); //Subscribe it here
  //   super.didChangeDependencies();
  // }

  // @override
  // void didPop() {
  //   print("didPop");
  //   super.didPop();
  // }

  // @override
  // void didPopNext() {
  //   print("didPopNext");
  //   _controller.play();
  //   super.didPopNext();
  // }

  // @override
  // void didPush() {
  //   print("didPush");
  //   super.didPush();
  // }

  // @override
  // void didPushNext() {
  //   print("didPushNext");
  //   _controller.pause();
  //   super.didPushNext();
  // }

  @override
  Widget build(BuildContext context) {
    return VisibilityDetector(
        key: Key("unique key"),
        onVisibilityChanged: (VisibilityInfo info) {
          debugPrint("${info.visibleFraction} of my widget is visible");
          if (info.visibleFraction == 0) {
            widget.isDirect ? print("is Direct play") : _controller.pause();
          } else {
            _controller.play();
          }
        },
        child: Stack(
          children: <Widget>[
            AspectRatio(
              aspectRatio: _controller.value.aspectRatio,
            ),
            Stack(
              alignment: Alignment.bottomCenter,
              children: <Widget>[
                VideoPlayer(_controller),
                _PlayPauseOverlay(controller: _controller),
                VideoProgressIndicator(
                  _controller,
                  allowScrubbing: false,
                  colors: VideoProgressColors(
                      playedColor: Colors.grey[800],
                      backgroundColor: Colors.black),
                ),
              ],
            ),
          ],
        ));
  }

  @override
  void dispose() {
    // routeObserver.unsubscribe(this);
    _controller.dispose();
    super.dispose();
  }
}

class _PlayPauseOverlay extends StatelessWidget {
  const _PlayPauseOverlay({Key key, this.controller}) : super(key: key);

  final VideoPlayerController controller;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        AnimatedSwitcher(
          duration: Duration(milliseconds: 50),
          reverseDuration: Duration(milliseconds: 200),
          child: controller.value.isPlaying
              ? SizedBox.shrink()
              : Container(
                  color: Colors.black26,
                  child: Center(
                    child: Icon(
                      Icons.play_arrow,
                      color: Colors.white,
                      size: 50.0,
                    ),
                  ),
                ),
        ),
        GestureDetector(
          onTap: () {
            controller.value.isPlaying ? controller.pause() : controller.play();
          },
        ),
      ],
    );
  }
}
