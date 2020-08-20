import 'package:agni_app/providers/comment.dart';
import 'package:agni_app/providers/comments.dart';
import 'package:agni_app/providers/user_notifications.dart';
import 'package:agni_app/providers/users.dart';
import 'package:agni_app/providers/video.dart';
import 'package:agni_app/utils/constant.dart';
import 'package:agni_app/utils/local_notification.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:timeago/timeago.dart' as timeago;

import '../../../../empty_box.dart';
import '../../../../user_profile_screen.dart';

class CommentBottomSheet extends StatefulWidget {
  final Video video;
  final int currentUserId;

  const CommentBottomSheet({Key key, this.video, this.currentUserId})
      : super(key: key);
  @override
  _CommentBottomSheetState createState() => _CommentBottomSheetState();
}

class _CommentBottomSheetState extends State<CommentBottomSheet> {
  TextEditingController _commentTextController = TextEditingController();

  Future<void> _addComment(
      int _videoId, int _currentUserId, String comment, ) async {
    await Provider.of<Comments>(context, listen: false)
        .addComment(_videoId, _currentUserId, comment)
        .then((value) {
      LocalNotification.success(
        context,
        message: 'Comment added',
        inPostCallback: true,
      );
      _commentTextController.clear();
      setState(() {});
    });
    String type = "comment";
    String value = "replied: $comment";

    await Provider.of<UserNotifications>(context, listen: false)
        .addPushNotification(_currentUserId, widget.video.userId, type, value,
            widget.video.thumbnail);
  }

  Future<void> _deleteComment(int id) async {
    await Provider.of<Comments>(context, listen: false)
        .deleteComment(id)
        .then((value) {
      LocalNotification.success(
        context,
        message: 'Comment delete',
        inPostCallback: true,
      );
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return new Container(
      height: MediaQuery.of(context).size.height * 0.6,
      child: new Container(
        decoration: new BoxDecoration(
            color: Colors.white,
            borderRadius: new BorderRadius.only(
                topLeft: const Radius.circular(20.0),
                topRight: const Radius.circular(20.0))),
        child: new Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Text(
              "Comments",
              style: kHeadingTextStyle,
            ),
            Expanded(child: retrieveComments()),
            // Divider(),
            Align(
              alignment: Alignment.bottomCenter,
              child: Container(
                child: ListTile(
                  title: TextFormField(
                    controller: _commentTextController,
                    decoration: InputDecoration(
                      labelText: "Write comment here...",
                      labelStyle: TextStyle(color: Colors.black),
                      enabledBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.grey),
                      ),
                      focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.black),
                      ),
                    ),
                    validator: (val) {
                      if (val.length < 1) {
                        return "Comment can\'t be empty!";
                      } else {
                        return null;
                      }
                    },
                  ),
                  trailing: InkWell(
                    child: Icon(
                      Icons.send,
                      size: 28,
                      color: Colors.purple,
                    ),
                    onTap: () {
                      _addComment(widget.video.id, widget.currentUserId,
                          _commentTextController.text,);
                    },
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  retrieveComments() {
    var videoCommentsCount = Provider.of<Comments>(
          context,
          listen: false,
        )
            .commetByVideoId(
              widget.video.id,
            )
            .length ??
        0;
    var commentData = videoCommentsCount > 0
        ? Provider.of<Comments>(context, listen: false)
            .commetByVideoId(widget.video.id)
        : null;
    return
        // FutureBuilder(
        //   future: Provider.of<Comments>(context, listen: false).fetchComments(),
        //   builder: (ctx, dataSnapshot) {
        //     if (dataSnapshot.connectionState == ConnectionState.waiting) {
        //       return Center(child: CircularProgressIndicator());
        //     } else {
        //       if (dataSnapshot.error != null) {
        //         return AlertDialog(
        //           title: Text('An error occurred!'),
        //           content: Text('Something went wrong.'),
        //           actions: <Widget>[
        //             FlatButton(
        //               child: Text('Okay'),
        //               onPressed: () {
        //                 Navigator.of(ctx).pop();
        //               },
        //             )
        //           ],
        //         );
        //       } else if (commentData == null) {
        //         return EmptyBox();
        //       } else {
        //         return Consumer<Comments>(
        //           builder: (ctx, comData, child) => ListView.builder(
        // physics: BouncingScrollPhysics(
        //     parent: AlwaysScrollableScrollPhysics()),
        //             itemCount: commentData.length,
        //             itemBuilder: (ctx, i) => commentItem(commentData[i]),
        //           ),
        //         );
        //       }
        //     }
        //   },
        // );
        commentData == null
            ? Center(child: EmptyBoxScreen())
            : Scrollbar(
                child: ListView.builder(
                  physics: BouncingScrollPhysics(
                      parent: AlwaysScrollableScrollPhysics()),
                  itemCount: commentData.length,
                  itemBuilder: (ctx, i) => commentItem(commentData[i]),
                ),
              );
  }

  Widget commentItem(Comment comment) {
    var loadedUser = Provider.of<Users>(
      context,
      listen: false,
    ).userfindById(comment.userId);
    DateTime myDatetime = DateTime.parse(comment.createdAt);
    return Padding(
      padding: const EdgeInsets.only(bottom: 3.0),
      child: Container(
        child: Column(
          children: <Widget>[
            ListTile(
              title: Text(loadedUser.name + ": " + comment.comment),
              leading: InkWell(
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => UserProfileScreen(
                                currentUserId: widget.currentUserId,
                                userId: comment.userId,
                              )));
                },
                child: CircleAvatar(
                  backgroundImage: loadedUser.profileUrl == null
                      ? AssetImage(assetsProfileImage)
                      : CachedNetworkImageProvider(loadedUser.profileUrl),
                ),
              ),
              subtitle: Text(
                timeago.format(myDatetime),
              ),
              trailing: widget.currentUserId == comment.userId
                  ? PopupMenuButton<int>(
                      itemBuilder: (context) => [
                        PopupMenuItem(
                          height: 25,
                          value: 1,
                          child: Text(
                            "delete",
                          ),
                        ),
                      ],
                      onSelected: (selection) {
                        switch (selection) {
                          case 1:
                            _deleteComment(comment.id);
                            break;
                        }
                      },
                      icon: Icon(Icons.more_vert),
                      offset: Offset(0, 100),
                    )
                  : SizedBox.shrink(),
            ),
          ],
        ),
      ),
    );
  }
}
