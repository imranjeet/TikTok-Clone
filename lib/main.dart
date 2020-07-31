import 'package:agni_app/providers/users.dart';
import 'package:agni_app/providers/videos.dart';
import 'package:agni_app/resources/dimen.dart';
import 'package:agni_app/screens/home_screen.dart';
import 'package:agni_app/screens/inbox_screen.dart';
import 'package:agni_app/screens/search_screen.dart';
import 'package:agni_app/screens/setting_screen.dart';
import 'package:agni_app/screens/upload_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'auth/login_screen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  SharedPreferences _prefs = await SharedPreferences.getInstance();
  var currentUserId = _prefs.getInt('userId');
  // var currentUserEmail = _prefs.getString('userId');

  runApp(currentUserId != null ? MyApp(currentUserId: currentUserId) : MyApp());
}

class MyApp extends StatelessWidget {
  final int currentUserId;

  const MyApp({Key key, this.currentUserId}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
        providers: [
          ChangeNotifierProvider.value(
            value: Users(),
          ),
          ChangeNotifierProvider.value(
            value: Videos(),
          ),
        ],
        child: MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'Agni App',
          theme: ThemeData(
            primarySwatch: Colors.blueGrey,
          ),
          initialRoute: (currentUserId != null) ? '/' : '/login',
          routes: <String, WidgetBuilder>{
            '/': (BuildContext context) => MainScreen(
                  currentUserId: currentUserId,
                ),
            '/login': (BuildContext context) => LoginScreen(),
          },
        ));
  }
}

// class MainScreen extends StatefulWidget {
//   @override
//   _MainScreenState createState() => _MainScreenState();
// }

// class _MainScreenState extends State<MainScreen> {
//   PageController _pageController;
//   int _currentPage = 0;

//   @override
//   void initState() {
//     super.initState();
//     _pageController = new PageController();
//     _pageController.addListener(() {
//       setState(() {
//         _currentPage = _pageController.page.round();
//       });
//     });
//   }

//   void _changePage(int page) {
//     setState(() {
//       this._currentPage = page;
//     });

//     _pageController.animateToPage(
//       page,
//       duration: const Duration(milliseconds: 100),
//       curve: Curves.ease,
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     // var size = MediaQuery.of(context).size;
//     // User user = User();
//     return Scaffold(
//       backgroundColor: Colors.black,
//       floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
//       floatingActionButton: Container(
//         height: 50.0,
//         width: 50.0,
//         child: FittedBox(
//           child: FloatingActionButton(
//             backgroundColor: Colors.purple,
//             onPressed: () {},
//             child: Icon(
//               Icons.camera,
//               color: Colors.white,
//               size: 45,
//             ),
//             elevation: 5.0,
//           ),
//         ),
//       ),
//       // floatingActionButton:
//       //     FloatingActionButton(child: Icon(Icons.add), onPressed: () {}),
//       body: PageView(
//         children: <Widget>[
//           HomeScreen(),
//           SearchScreen(),
//           // LoginScreen(),
//           InboxScreen(),
//           SettingScreen(),
//         ],
//         controller: _pageController,
//       ),
//       bottomNavigationBar: BottomNavigationBar(
//         backgroundColor: Colors.transparent,
//         items: <BottomNavigationBarItem>[
//           BottomNavigationBarItem(
//               icon: Icon(
//                 Icons.home,
//                 size: 30,
//               ),
//               title: Text(
//                 '',
//               )),
//           BottomNavigationBarItem(
//               icon: Icon(
//                 Icons.search,
//               ),
//               title: Text(
//                 '',
//               )),
//           // BottomNavigationBarItem(
//           //     icon: FloatingActionButton(
//           //         child: Icon(Icons.add), onPressed: () {}),
//           //     title: Text(
//           //       '',
//           //     )),
//           BottomNavigationBarItem(
//             icon: Icon(
//               Icons.notifications,
//             ),
//             title: Text(
//               '',
//             ),
//           ),
//           BottomNavigationBarItem(
//             icon: Icon(
//               Icons.person,
//             ),
//             title: Text(
//               '',
//             ),
//           ),
//         ],
//         type: BottomNavigationBarType.fixed,
//         selectedItemColor: Colors.white,
//         unselectedItemColor: Colors.white,
//         // unselectedIconTheme: IconThemeData(
//         //   size: 30,
//         // ),
//         currentIndex: _currentPage,
//         onTap: _changePage,
//       ),
//     );
//   }
// }

class MainScreen extends StatefulWidget {
  final int currentUserId;

  const MainScreen({Key key, this.currentUserId}) : super(key: key);
  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  PageController _myPage = PageController(initialPage: 0);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // backgroundColor: Colors.black,
      // floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: BottomAppBar(
        shape: CircularNotchedRectangle(),
        child: Container(
          color: Colors.black,
          height: 50,
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
                height: 48,
                color: Colors.black,
                child: Padding(
                  padding: EdgeInsets.only(top: 4),
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
          HomeScreen(),
          SearchScreen(),
          UploadScreen(),
          // LoginScreen(),
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
