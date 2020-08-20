import 'package:agni_app/providers/user_notifications.dart';
import 'package:agni_app/providers/users.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'notification_list_item.dart';

class RetrieveNotification extends StatelessWidget {
  final int currentUserId;

  const RetrieveNotification({Key key, this.currentUserId}) : super(key: key);

  Future<void> _refreshNotifications(BuildContext context) async {
    await Provider.of<UserNotifications>(context, listen: false)
        .fetchUserNotifications(currentUserId);
    await Provider.of<Users>(context, listen: false).fetchUsers();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: Future.wait([
        Provider.of<Users>(context, listen: false).fetchUsers(),
        Provider.of<UserNotifications>(context, listen: false)
            .fetchUserNotifications(currentUserId),
        // Provider.of<Comments>(context, listen: false).fetchComments(),
        // Provider.of<Follows>(context, listen: false).fetchFollows(),
      ]),
      builder: (
        ctx,
        dataSnapshot,
      ) {
        if (dataSnapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
          // } else if (dataSnapshot.connectionState == ConnectionState.none) {
          //   return NetworkErrorScreen();
        } else {
          try {
            return Consumer<UserNotifications>(
              builder: (ctx, notiData, child) => RefreshIndicator(
                  backgroundColor: Colors.white,
                  onRefresh: () => _refreshNotifications(context),
                  child: Scrollbar(
                    child: ListView.builder(
                      physics: BouncingScrollPhysics(
                          parent: AlwaysScrollableScrollPhysics()),
                      scrollDirection: Axis.vertical,
                      shrinkWrap: true,
                      itemCount: notiData.reversedItems.length,
                      itemBuilder: (context, i) {
                        return NotificationListItem(
                          userNotification: notiData.reversedItems[i],
                          currentUserId: currentUserId
                        );
                      },
                    ),
                  )),
            );
          } catch (error) {
            print(error);
            return AlertDialog(
              title: Text('An error occurred!'),
              content: Text('Something went wrong.'),
              actions: <Widget>[
                FlatButton(
                  child: Text('Okay'),
                  onPressed: () {
                    Navigator.of(ctx).pop();
                  },
                )
              ],
            );
          }
        }
      },
    );
  }
}
