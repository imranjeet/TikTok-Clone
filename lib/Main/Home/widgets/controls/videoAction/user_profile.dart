import 'package:agni_app/providers/user.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import '../../../../user_profile_screen.dart';

class VideoUserProfile extends StatelessWidget {
  final int currentUserId;
  final User videoUser;

  const VideoUserProfile({Key key, this.currentUserId, this.videoUser})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    bool ownUserVideo = currentUserId == videoUser.id;
    return InkWell(
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => UserProfileScreen(
                      currentUserId: currentUserId,
                      userId: videoUser.id,
                    )));
      },
      child: Padding(
        padding: EdgeInsets.only(top: 10, bottom: 10),
        child: Column(
          children: <Widget>[
            Stack(
              alignment: AlignmentDirectional.center,
              children: <Widget>[
                Container(
                  height: 50,
                  width: 50,
                  decoration: BoxDecoration(
                    border: Border.all(
                        color: Colors.white,
                        width: 2.0,
                        
                        style: BorderStyle.solid),
                    color: Colors.black,
                    shape: BoxShape.circle,

                    // image: DecorationImage(
                    // image: videoUser.profileUrl == null
                    //     ? AssetImage("assets/images/profile-image.png")
                    //     : CachedNetworkImageProvider(videoUser.profileUrl)),
                  ),
                  child: CircleAvatar(
                    radius: 35,
                    backgroundImage: videoUser.profileUrl == null
                        ? AssetImage("assets/images/profile-image.png")
                        : CachedNetworkImageProvider(videoUser.profileUrl),
                  ),
                ),
                ownUserVideo
                    ? SizedBox.shrink()
                    : Container(
                        margin: EdgeInsets.only(top: 50),
                        height: 18,
                        width: 18,
                        child: Icon(Icons.add, size: 10, color: Colors.white),
                        decoration: BoxDecoration(
                            color: Color.fromRGBO(255, 42, 84, 1),
                            shape: BoxShape.circle),
                      )
              ],
            )
          ],
        ),
      ),
    );
  }
}

// Widget userProfile(int currentUserId, User videoUser) {
//   return Padding(
//     padding: EdgeInsets.only(top: 10, bottom: 10),
//     child: Column(
//       children: <Widget>[
//         Stack(
//           alignment: AlignmentDirectional.center,
//           children: <Widget>[
//             Container(
//               height: 50,
//               width: 50,
//               decoration: BoxDecoration(
//                 border: Border.all(
//                     color: Colors.white, width: 1.0, style: BorderStyle.solid),
//                 color: Colors.black,
//                 shape: BoxShape.circle,
//                 image: DecorationImage(
//                     image: videoUser.profileUrl == null
//                         ? AssetImage("assets/images/profile-image.png")
//                         : NetworkImage(videoUser.profileUrl)),
//               ),
//             ),
//             Container(
//               margin: EdgeInsets.only(top: 50),
//               height: 18,
//               width: 18,
//               child: Icon(Icons.add, size: 10, color: Colors.white),
//               decoration: BoxDecoration(
//                   color: Color.fromRGBO(255, 42, 84, 1),
//                   shape: BoxShape.circle),
//             )
//           ],
//         )
//       ],
//     ),
//   );
// }
