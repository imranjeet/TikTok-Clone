import 'package:agni_app/auth/login_screen.dart';
import 'package:agni_app/providers/users.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingScreen extends StatefulWidget {
  final int currentUserId;

  SettingScreen({this.currentUserId});
  @override
  _SettingScreenState createState() => _SettingScreenState();
}

class _SettingScreenState extends State<SettingScreen> {
  var _isInit = true;

  var _isLoading = true;

  @override
  void didChangeDependencies() {
    if (_isInit) {
      setState(() {
        _isLoading = true;
      });
      Provider.of<Users>(context).fetchUsers().then((_) {
        setState(() {
          _isLoading = false;
        });
      });
    }
    _isInit = false;
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return _isLoading
        ? Center(
            child: CircularProgressIndicator(),
          )
        : ProfilePage(currentUserId: widget.currentUserId);
  }
}

class ProfilePage extends StatelessWidget {
  final int currentUserId;

  ProfilePage({this.currentUserId});

  _logOut(BuildContext context) async {
    SharedPreferences _prefs = await SharedPreferences.getInstance();
    _prefs.remove('userId');
    var currentUserId = _prefs.getInt('userId');
    if (currentUserId == null) {
      Navigator.push(
          context, MaterialPageRoute(builder: (context) => LoginScreen()));
    } else {
      showDialog(context: context, child: Text("Failed to logout!"));
    }
  }

  @override
  Widget build(BuildContext context) {
    final loadedUser = Provider.of<Users>(
      context,
      listen: false,
    ).userfindById(currentUserId);
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Text(
            loadedUser.name,
            style: TextStyle(fontSize: 24, color: Colors.black),
          ),
          Text(
            loadedUser.email,
            style: TextStyle(fontSize: 20, color: Colors.black),
          ),
          RaisedButton(
            onPressed: () => _logOut(context),
            child: Text("LogOut"),
          )
        ],
      ),
    );
  }
}

//   @override
//   Widget build(BuildContext context) {
//     return Center(
//       child: Column(
//         mainAxisAlignment: MainAxisAlignment.center,
//         children: <Widget>[
//           Text(
//             "widget.user.displayName",
//             style: TextStyle(fontSize: 30, color: Colors.black),
//           ),
//           Text(
//             "widget.user.email",
//             style: TextStyle(fontSize: 30, color: Colors.black),
//           ),
//           Text(
//             "User Login",
//             style: TextStyle(fontSize: 30, color: Colors.black),
//           ),
//           RaisedButton(
//             child: Text("Log out"),
//             onPressed: () {
//               // AuthProvider().logOut();
//             },
//           )
//         ],
//       ),
//     );
//   }
// }

// final GoogleSignIn gSignIn = GoogleSignIn();

// class SettingScreen extends StatefulWidget {
//   @override
//   _SettingScreenState createState() => _SettingScreenState();
// }

// class _SettingScreenState extends State<SettingScreen> {
//   bool isSignedIn = false;

//   @override
//   void initState() {
//     super.initState();
//     gSignIn.onCurrentUserChanged.listen((gSigninAccount) {
//       controlSignIn(gSigninAccount);
//     }, onError: (gError) {
//       print("Error message" + gError);
//     });

//     gSignIn.signInSilently(suppressErrors: false).then((gSignInAccount) {
//       controlSignIn(gSignInAccount);
//     }).catchError((gError) {
//       print("Error message" + gError);
//     });
//   }

//   controlSignIn(GoogleSignInAccount signInAccount) async {
//     if (signInAccount != null) {
//       await saveUser();
//       setState(() {
//         isSignedIn = true;
//       });
//       // configureRealTimePushNotifications();
//     } else {
//       setState(() {
//         isSignedIn = false;
//       });
//     }
//   }

//   saveUser() async {
//     final GoogleSignInAccount gCurrentUser = gSignIn.currentUser;

//     try {
//       await Provider.of<Users>(context, listen: false).addUser(gCurrentUser);
//     } catch (error) {
//       await showDialog(
//         context: context,
//         builder: (ctx) => AlertDialog(
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
//         ),
//       );
//     }
//   }

//   loginUser() {
//     gSignIn.signIn();
//   }

//   logoutUser() {
//     gSignIn.signOut();
//   }

//   Scaffold buildSignInScreen() {
//     return Scaffold(
//       body: Container(
//         decoration: BoxDecoration(
//             gradient: LinearGradient(
//                 begin: Alignment.topRight,
//                 end: Alignment.bottomLeft,
//                 colors: [
//               Colors.yellowAccent,
//               Colors.redAccent,
//             ])),
//         child: Center(
//           child: Column(
//             mainAxisAlignment: MainAxisAlignment.center,
//             children: <Widget>[
//               // CircleAvatar(
//               //   radius: 60,
//               //   backgroundImage: AssetImage(
//               //     'assets/images/splash.png',
//               //   ),
//               // ),
//               // SizedBox(height: 10),
//               // Text(
//               //   'Social App',
//               //   style: TextStyle(
//               //       fontSize: 60, color: Colors.black, fontFamily: 'Signatra'),
//               // ),
//               GestureDetector(
//                 onTap: () => loginUser(),
//                 child: Container(
//                   height: 50.0,
//                   width: 200.0,
//                   decoration: BoxDecoration(
//                     image: DecorationImage(
//                       image:
//                           AssetImage('assets/images/google_signin_button.png'),
//                       fit: BoxFit.cover,
//                     ),
//                   ),
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     return isSignedIn ? UserProfile() : buildSignInScreen();
//   }
// }

// class UserProfile extends StatefulWidget {
//   @override
//   _UserProfileState createState() => _UserProfileState();
// }

// class _UserProfileState extends State<UserProfile> {
//   var _isInit = true;

//   var _isLoading = false;

//   @override
//   void didChangeDependencies() {
//     if (_isInit) {
//       setState(() {
//         _isLoading = true;
//       });
//       Provider.of<Users>(context).fetchUsers().then((_) {
//         setState(() {
//           _isLoading = false;
//         });
//       });
//     }
//     _isInit = false;
//     super.didChangeDependencies();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return _isLoading
//         ? Center(
//             child: CircularProgressIndicator(),
//           )
//         : ProfileItems();
//   }
// }
