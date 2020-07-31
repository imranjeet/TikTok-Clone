import 'dart:convert';

import 'package:agni_app/main.dart';
import 'package:agni_app/models/user.dart';
import 'package:agni_app/auth/register_screen.dart';
import 'package:agni_app/services/user_service.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  final email = TextEditingController();
  final password = TextEditingController();

  _login(BuildContext context, User user) async {
    var _userService = UserService();
    var registeredUser = await _userService.login(user);
    print(registeredUser.body);
    var result = json.decode(registeredUser.body);

    if (result['result'] == true) {
      SharedPreferences _prefs = await SharedPreferences.getInstance();
      _prefs.setInt('userId', result['user']['id']);
      // _prefs.setString('userName', result['user']['name']);
      // _prefs.setString('userEmail', result['user']['email']);
      var currentUserId = _prefs.getInt('userId');
      // Navigator.pop(context);
      Navigator.push(
          context, MaterialPageRoute(builder: (context) => MainScreen(currentUserId: currentUserId)));
    } else {
      _showSnackMessage(Text(
        'Failed to login!',
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
        // actions: <Widget>[
        //   IconButton(
        //     icon: Icon(
        //       Icons.close,
        //       color: Colors.red,
        //     ),
        //     onPressed: () {
        //       Navigator.pop(context);
        //     },
        //   ),
        // ],
      ),
      body: Padding(
        padding: const EdgeInsets.only(top: 120),
        child: ListView(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.only(
                  left: 48.0, top: 14.0, right: 48.0, bottom: 14.0),
              child: TextField(
                controller: email,
                decoration: InputDecoration(
                    hintText: 'youremail@example.com',
                    labelText: 'Enter your email'),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(
                  left: 48.0, top: 14.0, right: 48.0, bottom: 14.0),
              child: TextField(
                controller: password,
                decoration: InputDecoration(
                    hintText: 'Enter your password', labelText: '******'),
              ),
            ),
            Column(
              children: <Widget>[
                ButtonTheme(
                  minWidth: 320,
                  height: 45.0,
                  child: FlatButton(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(5.0)),
                    color: Colors.redAccent,
                    onPressed: () {
                      var user = User();
                      user.email = email.text;
                      user.password = password.text;
                      _login(context, user);
                    },
                    child: Text(
                      'Log in',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ),
                FlatButton(
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => RegistrationScreen()));
                  },
                  child: FittedBox(child: Text('Register your account')),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
// import 'package:agni_app/models/auth.dart';
// import 'package:agni_app/screens/home_screen.dart';
// import 'package:agni_app/screens/register_screen.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';

// class Login extends StatefulWidget {
//   @override
//   _LoginState createState() => _LoginState();
// }

// class _LoginState extends State<Login> {
//   final GlobalKey<FormState> _loginFormKey = GlobalKey<FormState>();
//   TextEditingController _emailInputController = TextEditingController();
//   TextEditingController _pwdInputController = TextEditingController();

//   String emailValidator(String value) {
//     Pattern pattern =
//         r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
//     RegExp regex = RegExp(pattern);

//     if (value.length == 0) {
//       return 'Email cannot be empty';
//     } else if (!regex.hasMatch(value)) {
//       return 'Email format is invalid';
//     } else {
//       return null;
//     }
//   }

//   String pwdValidator(String value) {
//     if (value.length == 0) {
//       return 'Password cannot be empty';
//     } else if (value.length < 8) {
//       return 'Password must be longer than 8 characters';
//     } else {
//       return null;
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         backgroundColor: Colors.black87,
//         title: Text('Login'),
//         centerTitle: true,
//       ),
//       body: Center(
//         child: Padding(
//           padding: const EdgeInsets.symmetric(vertical: 0.0, horizontal: 32.0),
//           child: Form(
//             key: _loginFormKey,
//             child: ListView(
//               children: <Widget>[
//                 // Image
//                 Container(
//                   padding: const EdgeInsets.only(top: 32.0),
//                   child: Image(
//                     image: AssetImage('assets/images/yoga1.png'),
//                   ),
//                 ),

//                 // Email
//                 TextFormField(
//                   keyboardType: TextInputType.emailAddress,
//                   controller: _emailInputController,
//                   decoration: InputDecoration(
//                     labelText: "Email",
//                     fillColor: Colors.white,
//                     border: OutlineInputBorder(
//                       borderRadius: BorderRadius.circular(30.0), // #7449D1
//                     ),
//                   ),
//                   validator: emailValidator,
//                 ),

//                 SizedBox(
//                   height: 32.0,
//                 ),

//                 // Password
//                 TextFormField(
//                   keyboardType: TextInputType.text,
//                   obscureText: true,
//                   controller: _pwdInputController,
//                   decoration: InputDecoration(
//                     labelText: "Password",
//                     fillColor: Colors.white,
//                     border: OutlineInputBorder(
//                       borderRadius: BorderRadius.circular(30.0),
//                     ),
//                   ),
//                   validator: pwdValidator,
//                 ),

//                 SizedBox(
//                   height: 32.0,
//                 ),

//                 // Button
//                 Center(
//                   child: ButtonTheme(
//                     minWidth: 150.0,
//                     child: FlatButton(
//                       onPressed: _login,
//                       color: Colors.deepPurpleAccent,
//                       textColor: Colors.white,
//                       padding: EdgeInsets.all(14.0),
//                       child: Text(
//                         'Login',
//                         style: TextStyle(fontSize: 18.0),
//                       ),
//                       shape: RoundedRectangleBorder(
//                         borderRadius: BorderRadius.circular(30.0),
//                       ),
//                     ),
//                   ),
//                 ),

//                 SizedBox(
//                   height: 15,
//                 ),

//                 // Register Now link
//                 Center(
//                   child: FlatButton(
//                     color: Colors.transparent,
//                     onPressed: _onRegister,
//                     child: Text(
//                       'Sign up',
//                       style: TextStyle(
//                         fontSize: 16.0,
//                       ),
//                     ),
//                   ),
//                 ),

//                 SizedBox(
//                   height: 12,
//                 ),
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }

//   void _onRegister() {
//     Navigator.push(
//       context,
//       MaterialPageRoute(
//         builder: (context) => Register(),
//       ),
//     );
//   }

//   void _login() async {
//     Auth auth = Auth();
//     try {
//       if (_loginFormKey.currentState.validate()) {
//         FirebaseUser user = await auth
//             .signIn(
//           _emailInputController.text,
//           _pwdInputController.text,
//         )
//             .catchError((err) {
//           print(err);
//           showDialog(
//             context: context,
//             builder: (BuildContext context) {
//               return AlertDialog(
//                 title: Text("Error"),
//                 content: Text("Incorrect Email or Password!"),
//                 actions: <Widget>[
//                   FlatButton(
//                     child: Text("Close"),
//                     onPressed: () {
//                       Navigator.of(context).pop();
//                     },
//                   ),
//                 ],
//               );
//             },
//           );
//         });

//         if (user != null) {
//           Navigator.pushReplacement(
//             context,
//             MaterialPageRoute(
//               builder: (context) => HomeScreen(
//                 email: user.email,
//                 uid: user.uid,
//                 displayName: user.displayName,
//                 photoUrl: user.photoUrl,
//               ),
//             ),
//           );
//         }
//       }
//     } catch (e) {
//       print('Error: ' + e.toString());
//     }
//   }
// }
