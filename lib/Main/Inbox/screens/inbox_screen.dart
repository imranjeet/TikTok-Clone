import 'package:agni_app/Main/Inbox/widgets/retrieve_notification.dart';
import 'package:agni_app/Main/empty_box.dart';
import 'package:agni_app/providers/users.dart';
import 'package:agni_app/utils/constant.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';


class InboxScreen extends StatefulWidget {
  final int currentUserId;
  // final int userId;
  // final int tabIndex;

  const InboxScreen({
    Key key,
    this.currentUserId,
  }) : super(key: key);
  @override
  _InboxScreenState createState() => _InboxScreenState();
}

class _InboxScreenState extends State<InboxScreen>
    with SingleTickerProviderStateMixin {
  TabController _tabController;

  @override
  void initState() {
    _tabController = new TabController(length: 2, vsync: this, initialIndex: 0);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // var loadedUser = Provider.of<Users>(
    //   context,
    //   listen: false,
    // ).userfindById(widget.currentUserId);

    return new Scaffold(
      backgroundColor: Colors.white,
      appBar: new AppBar(
        title: new Text(
          "Inbox",
          // loadedUser.username == null
          //     ? loadedUser.name
          //     : "@${loadedUser.username}",
          style: kHeadingTextStyle,
        ),
        backgroundColor: Colors.white,
        centerTitle: true,
        bottom: TabBar(
          unselectedLabelColor: Colors.black,
          labelColor: Colors.orange,
          tabs: [
            Padding(
              padding: const EdgeInsets.only(bottom: 15),
              child: Text(
                "Notifications",
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w400,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 15),
              child: Text(
                "Messages",
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
        bottomOpacity: 1,
      ),
      body: TabBarView(
        children: [
          RetrieveNotification(currentUserId: widget.currentUserId),
          EmptyBoxScreen(),
        ],
        controller: _tabController,
      ),
    );
  }
}
