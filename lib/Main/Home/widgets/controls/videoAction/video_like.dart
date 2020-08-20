import 'package:agni_app/providers/reactions.dart';
import 'package:agni_app/providers/user_notifications.dart';
import 'package:agni_app/utils/local_notification.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class VideoLike extends StatefulWidget {
  final int currentUserId;
  final int videoId;
  final int videoUserId;
  final String optionalImageUrl;

  const VideoLike(
      {Key key,
      this.currentUserId,
      this.videoId,
      this.videoUserId,
      this.optionalImageUrl})
      : super(key: key);

  @override
  _VideoLikeState createState() => _VideoLikeState();
}

class _VideoLikeState extends State<VideoLike> {
  Future<void> updateLike(int _videoId, int _currentUserId, int _number) async {
    await Provider.of<Reactions>(context, listen: false)
        .addLike(_videoId, _currentUserId, _number)
        .then((value) {
      LocalNotification.success(
        context,
        message: 'Added to Like videos',
        inPostCallback: true,
      );
      setState(() {});
    });

    // } catch (error) {
    //   await showDialog(
    //     context: context,
    //   builder: (ctx) => AlertDialog(
    //     title: Text('An error occurred!'),
    //     content: Text('Something went wrong.'),
    //     actions: <Widget>[
    //       FlatButton(
    //         child: Text('Okay'),
    //         onPressed: () {
    //           Navigator.of(ctx).pop();
    //         },
    //       )
    //     ],
    //   ),
    // ); addPushNotification
    // }
    String type = "like";
    String value = "liked your video.";

    await Provider.of<UserNotifications>(context, listen: false)
        .addPushNotification(_currentUserId, widget.videoUserId, type, value,
            widget.optionalImageUrl);
  }

  Future<void> _deleteReaction(int id) async {
    await Provider.of<Reactions>(context, listen: false)
        .deleteReaction(id)
        .then((value) {
      LocalNotification.success(
        context,
        message: 'Removed from Liked videos',
        inPostCallback: true,
      );
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    var videoLikesCount = Provider.of<Reactions>(
          context,
          listen: false,
        )
            .reactionByVideoId(
              widget.videoId,
            )
            .length ??
        0;
    var currentUserLikes = Provider.of<Reactions>(
          context,
          listen: false,
        ).reactionfindByuserId(widget.videoId, widget.currentUserId).length ??
        0;
    var userLike = currentUserLikes > 0
        ? Provider.of<Reactions>(
            context,
            listen: false,
          ).reactionfindByuserId(widget.videoId, widget.currentUserId)
        : null;

    return Padding(
      padding: EdgeInsets.only(top: 10, bottom: 10),
      child: Column(
        children: <Widget>[
          currentUserLikes == 1
              ? InkWell(
                  onTap: () {
                    _deleteReaction(userLike.elementAt(0).id);
                  },
                  child: Icon(
                    Icons.favorite,
                    color: Colors.red,
                    size: 35,
                  ),
                )
              : InkWell(
                  onTap: () {
                    updateLike(widget.videoId, widget.currentUserId, 1);
                  },
                  child: Icon(
                    Icons.favorite_border,
                    color: Colors.red,
                    size: 35,
                  ),
                ),
          Padding(
            padding: EdgeInsets.only(
              top: 1.0,
            ),
            child: Text(
              "$videoLikesCount" ?? "0",
              style: TextStyle(fontSize: 10, color: Colors.white),
            ),
          )
        ],
      ),
    );
  }
}
