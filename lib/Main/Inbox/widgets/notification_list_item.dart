import 'package:agni_app/providers/user_notification.dart';
import 'package:agni_app/providers/users.dart';
import 'package:agni_app/utils/constant.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:timeago/timeago.dart' as timeago;

import '../../user_profile_screen.dart';

class NotificationListItem extends StatelessWidget {
  final UserNotification userNotification;
  final int currentUserId;

  const NotificationListItem(
      {Key key, this.userNotification, this.currentUserId})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    var notificationUser = Provider.of<Users>(
      context,
      listen: false,
    ).userfindById(userNotification.myUserId);
    bool ownProfile = currentUserId == notificationUser.id;
    DateTime notificationtime = DateTime.parse(userNotification.createdAt);
    return ownProfile
        ? SizedBox.shrink()
        : Container(
            child: Column(
              children: [
                ListTile(
                    contentPadding: EdgeInsets.symmetric(
                      horizontal: 6,
                    ),
                    leading: InkWell(
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => UserProfileScreen(
                                      currentUserId: currentUserId,
                                      userId: notificationUser.id,
                                    )));
                      },
                      child: CircleAvatar(
                        radius: 25,
                        backgroundImage: notificationUser.profileUrl == null
                            ? AssetImage(assetsProfileImage)
                            : CachedNetworkImageProvider(
                                notificationUser.profileUrl),
                      ),
                    ),
                    title: RichText(
                      text: TextSpan(
                          text: "${notificationUser.name}: ",
                          style: TextStyle(color: Colors.black, fontSize: 14.5),
                          children: <TextSpan>[
                            TextSpan(
                              text: userNotification.value,
                              style:
                                  TextStyle(color: Colors.orange, fontSize: 13),
                            )
                          ]),
                      overflow: TextOverflow.ellipsis,
                    ),
                    subtitle: Text(
                      timeago.format(notificationtime),
                    ),
                    trailing: userNotification.optionalImageUrl == null
                        ? SizedBox.shrink()
                        : Image.network(
                            userNotification.optionalImageUrl,
                            width: 50,
                            height: 100,
                          )),
                Divider(),
              ],
            ),
          );
  }
}
