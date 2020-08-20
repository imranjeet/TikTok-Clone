import 'package:agni_app/Main/Home/widgets/controls/onscreen_controls.dart';
import 'package:agni_app/Main/Home/widgets/video_player_screen.dart';
import 'package:agni_app/Main/empty_box.dart';
import 'package:agni_app/providers/follows.dart';
import 'package:agni_app/providers/video.dart';
import 'package:agni_app/providers/videos.dart';
import 'package:agni_app/utils/local_notification.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'grid_video.dart';

class TabbarVideos extends StatefulWidget {
  final int currentUserId;
  final int userId;

  const TabbarVideos({Key key, this.userId, this.currentUserId})
      : super(key: key);
  @override
  _TabbarVideosState createState() => _TabbarVideosState();
}

class _TabbarVideosState extends State<TabbarVideos>
    with SingleTickerProviderStateMixin {
  TabController _tabController;

  @override
  void initState() {
    _tabController = new TabController(length: 2, vsync: this, initialIndex: 0);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var loadedVideos = Provider.of<Videos>(
      context,
      listen: false,
    ).videoById(widget.userId);
    return Scaffold(
      backgroundColor: Colors.white,
      
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        centerTitle: false,
        title: TabBar(
          unselectedLabelColor: Colors.black,
          labelColor: Colors.orange,
          tabs: [
            Padding(
              padding: const EdgeInsets.only(bottom: 15),
              child: Text(
                "Videos",
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w400,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 15),
              child: Text(
                "Favorites",
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w400,
                ),
              ),
            ),
          ],
          controller: _tabController,
          indicatorColor: Colors.orange,
          indicatorSize: TabBarIndicatorSize.tab,
        ),
      ),
      // bottomOpacity: 1,

      body: Container(
        child: TabBarView(
          children: [
            loadedVideos.isEmpty
                ? EmptyBoxScreen()
                : GridVideo(
                    userId: widget.userId,
                  ),
            EmptyBoxScreen(),
          ],
          controller: _tabController,
        ),
      ),
    );
  }

  gridAllUserVideos() {
    var loadedVideos = Provider.of<Videos>(
      context,
      listen: false,
    ).videoById(widget.userId);
    int totalVideos = loadedVideos.length;
    return Scrollbar(
      child: GridView.builder(
        itemCount: loadedVideos.length,
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3,
          childAspectRatio: .8,
        ),
        // physics: NeverScrollableScrollPhysics(),
        // BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
        itemBuilder: (BuildContext context, int index) {
          return videosCard(
            loadedVideos[index],
            totalVideos,
            index,
            widget.userId,
          );
        },
      ),
    );
  }

  videosCard(Video video, int totalVideos, int videoIndex, int userId) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) =>
                    userVideoScreen(totalVideos, videoIndex, userId)));
      },
      child: Card(
        elevation: 3,
        clipBehavior: Clip.antiAliasWithSaveLayer,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(5),
            side: BorderSide(width: 3, color: Colors.transparent)),
        child: video.thumbnail == null
            ? Image.asset(
                "assets/images/dice.jpg",
                height: 140,
                width: 110,
                fit: BoxFit.fill,
              )
            : CachedNetworkImage(
                imageUrl: video.thumbnail,
                errorWidget: (context, url, error) => Container(
                    child: Column(
                  children: <Widget>[
                    Icon(
                      Icons.error,
                      size: 25,
                    ),
                    Text(
                      "Something went wrong. Try again!",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ],
                )),
                height: 140,
                width: 110,
                fit: BoxFit.fill,
              ),
      ),
    );
  }

  userVideoScreen(int totalVideos, int videoIndex, int userId) {
    var userVideos = Provider.of<Videos>(
      context,
      listen: false,
    ).allUserVideos(userId, videoIndex, totalVideos);
    bool isDirect = true;
    return PageView.builder(
      scrollDirection: Axis.vertical,
      itemBuilder: (context, index) {
        return Scaffold(
          backgroundColor: Colors.transparent,
          floatingActionButtonLocation: FloatingActionButtonLocation.startTop,
          floatingActionButton: FloatingActionButton(
            backgroundColor: Colors.transparent,
            onPressed: () {
              Navigator.pop(context);
            },
            child: Icon(
              Icons.arrow_back_ios,
              size: 30,
              color: Colors.white,
            ),
          ),
          body: Stack(
            children: <Widget>[
              VideoPlayerScreen(
                  videoLink: userVideos[index].videoUrl, isDirect: isDirect),
              ScreenControls(
                video: userVideos[index],
                currentUserId: widget.currentUserId,
              ),
            ],
          ),
        );
      },
      itemCount: userVideos.length,
    );
  }
}
