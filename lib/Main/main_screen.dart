import 'package:agni_app/providers/comments.dart';
import 'package:agni_app/providers/follows.dart';
import 'package:agni_app/providers/reactions.dart';
import 'package:agni_app/providers/user_notifications.dart';
import 'package:agni_app/providers/users.dart';
import 'package:agni_app/providers/videos.dart';
import 'package:agni_app/resources/dimen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'Home/screens/home_screen.dart';
import 'Inbox/screens/inbox_screen.dart';
import 'discover/screens/search_screen.dart';
import 'Profile/screens/setting_screen.dart';
import 'Upload/screens/upload_screen.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

class MainScreen extends StatefulWidget {
  final int currentUserId;

  const MainScreen({Key key, this.currentUserId}) : super(key: key);
  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _selectedPage = 0;
  List<Widget> pageList = List<Widget>();

  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging();
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    _firebaseMessaging.getToken().then((token) {
      print("firebase_token: $token");
    });
    pushNotification();
  }

  pushNotification() {
    _firebaseMessaging.configure(
      onMessage: (Map<String, dynamic> message) async {
        // final int recipientId = message["data"]["id"];
        final String title = message["notification"]["title"];
        final String body = message["notification"]["body"];

        // if (recipientId == widget.currentUserId) {
        SnackBar snackBar = SnackBar(
          backgroundColor: Colors.purple,
          content: RichText(
            textAlign: TextAlign.start,
            text: TextSpan(
                text: "$title: ",
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 14.5,
                    fontWeight: FontWeight.w500),
                children: <TextSpan>[
                  TextSpan(
                    text: body,
                    style: TextStyle(color: Colors.white, fontSize: 13),
                  )
                ]),
          ),
        );
        _scaffoldKey.currentState.showSnackBar(snackBar);
        print("onMessage: $message");
      },
      onLaunch: (Map<String, dynamic> message) async {
        print("onLaunch: $message");
      },
      onResume: (Map<String, dynamic> message) async {
        print("onResume: $message");
      },
    );
    pageList.add(
      HomeScreen(currentUserId: widget.currentUserId),
    );
    pageList.add(
      SearchScreen(),
    );
    pageList.add(
      UploadScreen(currentUserId: widget.currentUserId),
    );
    pageList.add(
      InboxScreen(currentUserId: widget.currentUserId),
    );
    pageList.add(
      SettingScreen(currentUserId: widget.currentUserId),
    );
  }

  var _isInit = true;

  @override
  void didChangeDependencies() {
    if (_isInit) {
      Provider.of<Videos>(context).fetchVideos();
      Provider.of<Users>(context).fetchUsers();
      Provider.of<Reactions>(context).fetchReactions();
      Provider.of<Comments>(context).fetchComments();
      Provider.of<Follows>(context).fetchFollows();
      Provider.of<UserNotifications>(context)
          .fetchUserNotifications(widget.currentUserId);
    }
    _isInit = false;
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: Colors.white,
      bottomNavigationBar: BottomAppBar(
        shape: CircularNotchedRectangle(),
        child: Container(
          color: Colors.black,
          height: 55,
          child: Column(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.end,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: <Widget>[
              Divider(
                height: 2,
                color: Colors.grey[700],
              ),
              Container(
                height: 50,
                color: Colors.black,
                child: Padding(
                  padding: EdgeInsets.only(top: 6),
                  child: Row(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Expanded(
                        flex: 1,
                        child: InkWell(
                          onTap: () {
                            setState(() {
                              _selectedPage = 0;
                            });
                          },
                          child: Column(
                            children: <Widget>[
                              Icon(
                                Icons.home,
                                color: Colors.white,
                                size: 25,
                              ),
                              Padding(
                                padding:
                                    EdgeInsets.only(top: Dimen.textSpacing),
                                child: Text(
                                  "Home",
                                  style: TextStyle(
                                      fontSize: Dimen.bottomNavigationTextSize,
                                      color: Colors.white),
                                ),
                              )
                            ],
                          ),
                        ),
                      ),
                      Expanded(
                        flex: 1,
                        child: InkWell(
                          onTap: () {
                            setState(() {
                              _selectedPage = 1;
                            });
                          },
                          child: Column(
                            children: <Widget>[
                              Icon(
                                Icons.search,
                                color: Colors.white,
                                size: 25,
                              ),
                              Padding(
                                padding:
                                    EdgeInsets.only(top: Dimen.textSpacing),
                                child: Text(
                                  "Discover",
                                  style: TextStyle(
                                      fontSize: Dimen.bottomNavigationTextSize,
                                      color: Colors.white),
                                ),
                              )
                            ],
                          ),
                        ),
                      ),
                      Expanded(
                        flex: 1,
                        child: InkWell(
                          onTap: () {
                            setState(() {
                              _selectedPage = 2;
                            });
                          },
                          child: Column(
                            children: <Widget>[
                              Container(
                                  width: 45.0,
                                  height: 32.0,
                                  child: Stack(children: [
                                    Container(
                                        margin: EdgeInsets.only(left: 10.0),
                                        width: 100,
                                        decoration: BoxDecoration(
                                            color: Color.fromARGB(
                                                255, 250, 45, 108),
                                            borderRadius: BorderRadius.circular(
                                                Dimen.createButtonBorder))),
                                    Container(
                                        margin: EdgeInsets.only(right: 10.0),
                                        width: 200,
                                        decoration: BoxDecoration(
                                            color: Color.fromARGB(
                                                255, 32, 211, 234),
                                            borderRadius: BorderRadius.circular(
                                                Dimen.createButtonBorder))),
                                    Center(
                                        child: Container(
                                      height: double.infinity,
                                      width: 38,
                                      decoration: BoxDecoration(
                                          color: Colors.white,
                                          borderRadius: BorderRadius.circular(
                                              Dimen.createButtonBorder)),
                                      child: Icon(
                                        Icons.camera,
                                        size: 20.0,
                                      ),
                                    )),
                                  ]))
                            ],
                          ),
                        ),
                      ),
                      Expanded(
                        flex: 1,
                        child: InkWell(
                          onTap: () {
                            setState(() {
                              _selectedPage = 3;
                            });
                          },
                          child: Column(
                            children: <Widget>[
                              Icon(Icons.notifications,
                                  color: Colors.white, size: 25),
                              Padding(
                                padding:
                                    EdgeInsets.only(top: Dimen.textSpacing),
                                child: Text(
                                  "Inbox",
                                  style: TextStyle(
                                      fontSize: Dimen.bottomNavigationTextSize,
                                      color: Colors.white),
                                ),
                              )
                            ],
                          ),
                        ),
                      ),
                      Expanded(
                        flex: 1,
                        child: InkWell(
                          onTap: () {
                            setState(() {
                              _selectedPage = 4;
                            });
                          },
                          child: Column(
                            children: <Widget>[
                              Icon(Icons.person, color: Colors.white, size: 25),
                              Padding(
                                padding:
                                    EdgeInsets.only(top: Dimen.textSpacing),
                                child: Text(
                                  "Me",
                                  style: TextStyle(
                                      fontSize: Dimen.bottomNavigationTextSize,
                                      color: Colors.white),
                                ),
                              )
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      body: IndexedStack(
        index: _selectedPage,
        children: pageList,
      ),
    );
  }
}
