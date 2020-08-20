import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:visibility_detector/visibility_detector.dart';

class SoundAudioPlayer extends StatefulWidget {
  final String soundItem;

  const SoundAudioPlayer({Key key, this.soundItem}) : super(key: key);

  @override
  _SoundAudioPlayerState createState() => _SoundAudioPlayerState();
}

class _SoundAudioPlayerState extends State<SoundAudioPlayer> {
  AudioPlayer _audioPlayer;
  bool _isPlaying = false;

  @override
  void initState() {
    super.initState();
    _audioPlayer = AudioPlayer();
  }

  @override
  void dispose() {
    _audioPlayer.dispose();
    super.dispose();
  }

  _play(String url) async {
    await _audioPlayer.play(url);
    setState(() {
      _isPlaying = true;
    });
  }

  _pause() async {
    await _audioPlayer.pause();
    setState(() {
      _isPlaying = false;
    });
  }

  _stop() async {
    await _audioPlayer.stop();
    setState(() {
      _isPlaying = false;
    });
  }

  _resume() async {
    await _audioPlayer.resume();
    setState(() {
      _isPlaying = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    return VisibilityDetector(
      key: Key("unique key"),
      onVisibilityChanged: (VisibilityInfo info) {
        debugPrint("${info.visibleFraction} of my widget is visible");
        if (info.visibleFraction == 0) {
          _stop();
        }
        // else {
        //   _resume();
        // }
      },
      child: IconButton(
        // backgroundColor: Colors.transparent,
        // heroTag: null,
        onPressed: () => _isPlaying ? _pause() : _play(widget.soundItem),
        icon: Icon(
          _isPlaying ? Icons.pause : Icons.play_arrow,
          size: 45,
          color: Colors.red,
        ),
      ),
    );
  }
}