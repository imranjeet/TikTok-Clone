import 'package:video_player/video_player.dart';
import 'package:flutter/material.dart';

class VideoPlayerScreen extends StatefulWidget {
  final String videoLink;

  const VideoPlayerScreen({
    Key key,
    this.videoLink,
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

    _controller.initialize().then((_) => setState(() {}));

    _controller.play();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        // FloatingActionButton(
        //   backgroundColor: Colors.black38,
        //   onPressed: () {},
        //   child: Icon(
        //     Icons.arrow_back_ios,
        //     color: Colors.white,
        //   ),
        // ),

        // : SizedBox.shrink(),
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
                  playedColor: Colors.grey[800], backgroundColor: Colors.black),
            ),
          ],
        ),
        // Align(
        //   alignment: Alignment.bottomCenter,
        //   child: VideoProgressIndicator(
        //     _controller,
        //     allowScrubbing: true,
        //     colors: VideoProgressColors(
        //         playedColor: Colors.grey[800], backgroundColor: Colors.black),
        //   ),
        // ),
        // VideoPlayer(_controller),
        // _PlayPauseOverlay(controller: _controller),
      ],
    );
  }

  @override
  void dispose() {
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
