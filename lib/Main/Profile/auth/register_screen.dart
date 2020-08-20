import 'dart:convert';

import 'package:agni_app/models/user.dart';
import 'package:agni_app/Main/main_screen.dart';
import 'package:agni_app/services/user_service.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'login_screen.dart';

class RegistrationScreen extends StatefulWidget {
  @override
  _RegistrationScreenState createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  final name = TextEditingController();

  final email = TextEditingController();

  final password = TextEditingController();

  String _fcmToken;

  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging();

  @override
  void initState() {
    super.initState();
    _firebaseMessaging.getToken().then((String token) {
      assert(token != null);
      setState(() {
        _fcmToken = token;
      });
      
    });
  }

  _register(BuildContext context, User user) async {
    var _userService = UserService();
    var registeredUser = await _userService.createUser(user);
    var result = json.decode(registeredUser.body);
    print("Result: $result");
    if (result['result'] == true) {
      SharedPreferences _prefs = await SharedPreferences.getInstance();

      _prefs.setInt('userId', result['user']['id']);
      var currentUserId = _prefs.getInt('userId');
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => MainScreen(currentUserId: currentUserId)));
    } else {
      _showSnackMessage(Text(
        'Failed to register the user!',
        style: TextStyle(color: Colors.red),
      ));
    }
  }

  _showSnackMessage(message) {
    var snackBar = SnackBar(
      content: message,
    );
    _scaffoldKey.currentState.showSnackBar(snackBar);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0.0,
      ),
      body: Padding(
        padding: const EdgeInsets.only(top: 100.0),
        child: ListView(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.only(
                  left: 28.0, top: 14.0, right: 28.0, bottom: 14.0),
              child: TextField(
                controller: name,
                decoration: InputDecoration(
                    hintText: 'Enter your name', labelText: 'Enter your name'),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(
                  left: 28.0, top: 14.0, right: 28.0, bottom: 14.0),
              child: TextField(
                keyboardType: TextInputType.emailAddress,
                controller: email,
                decoration: InputDecoration(
                    hintText: 'Enter your email address',
                    labelText: 'Enter your email address'),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(
                  left: 28.0, top: 14.0, right: 28.0, bottom: 14.0),
              child: TextField(
                controller: password,
                obscureText: true,
                decoration:
                    InputDecoration(hintText: 'Password', labelText: '******'),
              ),
            ),
            Column(
              children: <Widget>[
                ButtonTheme(
                  minWidth: 320.0,
                  height: 45.0,
                  child: FlatButton(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(7.0)),
                    color: Colors.redAccent,
                    onPressed: () {
                      var user = User();
                      user.name = name.text;
                      user.email = email.text;
                      user.password = password.text;
                      user.fcmToken = _fcmToken;
                      print("fcmtoken is here: $_fcmToken");
                      _register(context, user);
                    },
                    child:
                        Text('Register', style: TextStyle(color: Colors.white)),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(5),
                  child: FlatButton(
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => LoginScreen()));
                    },
                    child: FittedBox(child: Text('Log in to your account')),
                  ),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.only(
                  left: 65.0, top: 14.0, right: 65.0, bottom: 14.0),
              child: Text(
                'By signing up you accept the Terms of Service and Privacy Policy',
                textAlign: TextAlign.center,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
