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

class MainScreen extends StatefulWidget {
  final int currentUserId;

  const MainScreen({Key key, this.currentUserId}) : super(key: key);
  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  PageController _myPage = PageController(initialPage: 0);

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      // floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
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
                              _myPage.jumpToPage(0);
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
                              _myPage.jumpToPage(1);
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
                              _myPage.jumpToPage(2);
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
                              _myPage.jumpToPage(3);
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
                            // _checkUser();
                            setState(() {
                              _myPage.jumpToPage(4);
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
      body: PageView(
        controller: _myPage,
        onPageChanged: (int) {
          print('Page Changes to index $int');
        },
        children: <Widget>[
          HomeScreen(currentUserId: widget.currentUserId),
          // InboxScreen(),
          SearchScreen(),
          UploadScreen(currentUserId: widget.currentUserId),
          // CameraHomeScreen(),
          InboxScreen(),
          SettingScreen(currentUserId: widget.currentUserId),
        ],
        physics:
            NeverScrollableScrollPhysics(), // Comment this if you need to use Swipe.
      ),
      // floatingActionButton: Container(
      //   height: 55.0,
      //   width: 55.0,
      //   child: FittedBox(
      //     child: FloatingActionButton(
      //       backgroundColor: Colors.purple,
      //       onPressed: () {
      //         _addVideo(context);
      //       },
      //       child: Icon(
      //         Icons.camera,
      //         color: Colors.white,
      //         size: 40,
      //       ),
      //       elevation: 5.0,
      //     ),
      //   ),
      // ),
    );
  }
}
