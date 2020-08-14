import 'package:agni_app/Main/Profile/widgets/video_card.dart';
import 'package:agni_app/providers/videos.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class GridVideo extends StatelessWidget {
  final int userId;

  const GridVideo({Key key, this.userId}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    var loadedVideos = Provider.of<Videos>(
      context,
      listen: false,
    ).videoById(userId);
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
          return VideoCard(
            video: loadedVideos[index],
            totalVideos: totalVideos,
            videoIndex: index,
            userId: userId,
          );
        },
      ),
    );
  }
}
