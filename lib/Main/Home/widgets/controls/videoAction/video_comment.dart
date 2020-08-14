import 'package:agni_app/providers/comments.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'comment_bottom_sheet.dart';

class VideoComment extends StatefulWidget {
  final int currentUserId;
  final int videoId;

  const VideoComment({Key key, this.currentUserId, this.videoId})
      : super(key: key);
  @override
  _VideoCommentState createState() => _VideoCommentState();
}

class _VideoCommentState extends State<VideoComment> {

  @override
  Widget build(BuildContext context) {
    var videoCommentsCount = Provider.of<Comments>(
          context,
          listen: false,
        )
            .commetByVideoId(
              widget.videoId,
            )
            .length ??
        0;
    return Padding(
      padding: EdgeInsets.only(top: 10, bottom: 10),
      child: Column(
        children: <Widget>[
          InkWell(
            onTap: () {
              showBottomSheet(
                context: context,
                builder: (ctx) => CommentBottomSheet(
                    videoId: widget.videoId,
                    currentUserId: widget.currentUserId),
              );
            },
            child: Icon(
              Icons.chat_bubble,
              color: Colors.white,
              size: 35,
            ),
          ),
          Padding(
            padding: EdgeInsets.only(
              top: 1.0,
            ),
            child: Text(
              "$videoCommentsCount",
              style: TextStyle(fontSize: 10, color: Colors.white),
            ),
          )
        ],
      ),
    );
  }
}

// class CommentListItems extends StatelessWidget {
//   final int videoId;

//   const CommentListItems({Key key, this.videoId}) : super(key: key);
//   @override
//   Widget build(BuildContext context) {
//     print('building orders');
//     var videoCommentsCount = Provider.of<Comments>(
//           context,
//           listen: false,
//         )
//             .commetByVideoId(
//               videoId,
//             )
//             .length ??
//         0;
//     var commentData = videoCommentsCount > 0
//         ? Provider.of<Comments>(context, listen: false).commetByVideoId(videoId)
//         : null;
//     // final orderData = Provider.of<Orders>(context);
//     return FutureBuilder(
//       future: Provider.of<Comments>(context, listen: false).fetchComments(),
//       builder: (ctx, dataSnapshot) {
//         if (dataSnapshot.connectionState == ConnectionState.waiting) {
//           return Center(child: CircularProgressIndicator());
//         } else if (dataSnapshot.connectionState == ConnectionState.none) {
//           return NetworkErrorScreen();
//         } else {
//           if (dataSnapshot.error != null) {
//             return AlertDialog(
//               title: Text('An error occurred!'),
//               content: Text('Something went wrong.'),
//               actions: <Widget>[
//                 FlatButton(
//                   child: Text('Okay'),
//                   onPressed: () {
//                     Navigator.of(ctx).pop();
//                   },
//                 )
//               ],
//             );
//           } else if (dataSnapshot.hasData == null) {
//             return EmptyBox();
//           } else {
//             return ListView.builder(
//               itemCount: commentData.length,
//               itemBuilder: (ctx, i) => CommentItem(comment: commentData[i]),
//             );
//           }
//         }
//       },
//     );
//   }
// }

// class CommentItem extends StatefulWidget {
//   final Comment comment;

//   const CommentItem({Key key, this.comment}) : super(key: key);

//   @override
//   _CommentItemState createState() => _CommentItemState();
// }

// class _CommentItemState extends State<CommentItem> {
//   Future<void> _deleteComment(context, int id) async {
//     await Provider.of<Comments>(context, listen: false)
//         .deleteComment(id)
//         .then((value) {
//       LocalNotification.success(
//         context,
//         message: 'Comment delete',
//         inPostCallback: true,
//       );
//       setState(() {});
//     });
//     print(id.toString());
//   }

//   @override
//   Widget build(BuildContext context) {
//     var loadedUser = Provider.of<Users>(
//       context,
//       listen: false,
//     ).userfindById(widget.comment.userId);
//     DateTime myDatetime = DateTime.parse(widget.comment.createdAt);
//     return Padding(
//       padding: const EdgeInsets.only(bottom: 3.0),
//       child: Container(
//         child: Column(
//           children: <Widget>[
//             ListTile(
//               title: Text(loadedUser.name + ": " + widget.comment.comment),
//               leading: CircleAvatar(
//                 backgroundImage: loadedUser.profileUrl == null
//                     ? Image.asset("assets/images/profile-image.png")
//                     : CachedNetworkImageProvider(loadedUser.profileUrl),
//               ),
//               subtitle: Text(
//                 timeago.format(myDatetime),
//               ),
//               trailing: loadedUser.id == widget.comment.userId
//                   ? PopupMenuButton<int>(
//                       itemBuilder: (context) => [
//                         PopupMenuItem(
//                           height: 25,
//                           value: 1,
//                           child: Text(
//                             "delete",
//                           ),
//                         ),
//                       ],
//                       onSelected: (selection) {
//                         switch (selection) {
//                           case 1:
//                             _deleteComment(context, widget.comment.id);

//                             break;
//                         }
//                       },
//                       icon: Icon(Icons.more_vert),
//                       offset: Offset(0, 100),
//                     )
//                   : SizedBox.shrink(),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
