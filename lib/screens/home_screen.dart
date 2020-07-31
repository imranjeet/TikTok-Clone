import 'package:agni_app/providers/videos.dart';
import 'package:agni_app/widgets/video/controls/onscreen_controls.dart';
import 'package:agni_app/widgets/video/video_player_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  var _isInit = true;
  var _isLoading = false;

  @override
  void initState() {
    super.initState();
  }

  @override
  void didChangeDependencies() {
    if (_isInit) {
      setState(() {
        _isLoading = true;
      });
      Provider.of<Videos>(context).fetchVideos().then((_) {
        setState(() {
          _isLoading = false;
        });
      });
    }
    _isInit = false;
    super.didChangeDependencies();
  }

  Future<void> _refreshVideos(BuildContext context) async {
    await Provider.of<Videos>(context).fetchVideos();
  }

  @override
  Widget build(BuildContext context) {
    final videoList = Provider.of<Videos>(context);
    return RefreshIndicator(
      onRefresh: () => _refreshVideos(context),
      child: PageView.builder(
        scrollDirection: Axis.vertical,
        itemBuilder: (context, index) {
          return Container(
            color: Colors.black,
            child: Stack(
              children: <Widget>[
                VideoPlayerScreen(videoLink: videoList.items[index].videoUrl),
                ScreenControls(
                  video: videoList.items[index],
                  // videoDis: videoList.items[index].discription, videoLike: videoList.items[index].like,
                ),
              ],
            ),
          );
        },
        itemCount: videoList.items.length,
      ),
    );
  }
}
