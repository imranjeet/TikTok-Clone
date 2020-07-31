import 'dart:convert';

import 'package:agni_app/models/user.dart';
import 'package:agni_app/screens/upload_screen.dart';
import 'package:agni_app/services/user_service.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../main.dart';
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

  _register(BuildContext context, User user) async {
    var _userService = UserService();
    var registeredUser = await _userService.createUser(user);
    var result = json.decode(registeredUser.body);
    if (result['result'] == true) {
      SharedPreferences _prefs = await SharedPreferences.getInstance();

      _prefs.setInt('userId', result['user']['id']);
      // _prefs.setString('userName', result['user']['name']);
      // _prefs.setString('userEmail', result['user']['email']);
      var currentUserId = _prefs.getInt('userId');
      Navigator.push(
          context, MaterialPageRoute(builder: (context) => MainScreen(currentUserId: currentUserId)));
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
// import 'package:agni_app/models/auth.dart';
// import 'package:agni_app/screens/home_screen.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/material.dart';
// class Register extends StatefulWidget {

//   @override
//   _RegisterState createState() => _RegisterState();
// }

// class _RegisterState extends State<Register> {
//   final GlobalKey<FormState> _registerFormKey = GlobalKey<FormState>();
//   TextEditingController _firstNameInputController;
//   TextEditingController _lastNameInputController;
//   TextEditingController _emailInputController;
//   TextEditingController _pwdInputController;
//   TextEditingController _confirmPwdInputController;

//   @override
//   initState() {
//     _firstNameInputController = TextEditingController();
//     _lastNameInputController = TextEditingController();
//     _emailInputController = TextEditingController();
//     _pwdInputController = TextEditingController();
//     _confirmPwdInputController = TextEditingController();
//     super.initState();
//   }

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
//         title: Text('Register'),
//         centerTitle: true,
//       ),
//       body: Container(
//         margin: const EdgeInsets.all(32.0),
//         child: SingleChildScrollView(
//           child: Form(
//             key: _registerFormKey,
//             child: Column(
//               children: <Widget>[
//                 SizedBox(
//                   height: 10,
//                 ),
//                 // First Name Input
//                 TextFormField(
//                   controller: _firstNameInputController,
//                   decoration: InputDecoration(
//                     labelText: "First Name",
//                     hintText: "John",
//                     fillColor: Colors.white,
//                     border: OutlineInputBorder(
//                       borderRadius: BorderRadius.circular(30.0), //
//                     ),
//                   ),
//                   validator: (val) {
//                     if (val.length < 3) {
//                       return "Please Enter a valid first name!";
//                     } else {
//                       return null;
//                     }
//                   },
//                 ),

//                 SizedBox(
//                   height: 32.0,
//                 ),

//                 // Last Name Input
//                 TextFormField(
//                   controller: _lastNameInputController,
//                   decoration: InputDecoration(
//                     labelText: "Last Name",
//                     hintText: "Doe",
//                     fillColor: Colors.white,
//                     border: OutlineInputBorder(
//                       borderRadius: BorderRadius.circular(30.0), //
//                     ),
//                   ),
//                   validator: (val) {
//                     if (val.length < 3) {
//                       return "Please Enter a valid last name!";
//                     } else {
//                       return null;
//                     }
//                   },
//                 ),

//                 SizedBox(
//                   height: 32.0,
//                 ),

//                 // Email Input
//                 TextFormField(
//                   controller: _emailInputController,
//                   keyboardType: TextInputType.emailAddress,
//                   decoration: InputDecoration(
//                     labelText: "Email",
//                     hintText: "example@gmail.com",
//                     fillColor: Colors.white,
//                     border: OutlineInputBorder(
//                       borderRadius: BorderRadius.circular(30.0), //
//                     ),
//                   ),
//                   validator: emailValidator,
//                 ),

//                 SizedBox(
//                   height: 32.0,
//                 ),

//                 // Password Input
//                 TextFormField(
//                   controller: _pwdInputController,
//                   obscureText: true,
//                   decoration: InputDecoration(
//                     labelText: "Password",
//                     hintText: "********",
//                     fillColor: Colors.white,
//                     border: OutlineInputBorder(
//                       borderRadius: BorderRadius.circular(30.0), //
//                     ),
//                   ),
//                   validator: pwdValidator,
//                 ),

//                 SizedBox(
//                   height: 32.0,
//                 ),

//                 // Confirm Password Input
//                 TextFormField(
//                   controller: _confirmPwdInputController,
//                   obscureText: true,
//                   decoration: InputDecoration(
//                     labelText: "Confirm Password",
//                     hintText: "********",
//                     fillColor: Colors.white,
//                     border: OutlineInputBorder(
//                       borderRadius: BorderRadius.circular(30.0), //
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
//                       onPressed: _register,
//                       color: Colors.deepPurpleAccent,
//                       textColor: Colors.white,
//                       padding: EdgeInsets.all(14.0),
//                       child: Text(
//                         'Register',
//                         style: TextStyle(fontSize: 18.0),
//                       ),
//                       shape: RoundedRectangleBorder(
//                         borderRadius: BorderRadius.circular(30.0),
//                       ),
//                     ),
//                   ),
//                 ),

//                 SizedBox(
//                   height: 32.0,
//                 ),

//                 // Sign in here
//                 Center(
//                   child: FlatButton(
//                     color: Colors.transparent,
//                     onPressed: () => Navigator.pop(context),
//                     child: Text(
//                       'Already have an account?\nSign in here',
//                       textAlign: TextAlign.center,
//                       style: TextStyle(
//                         fontSize: 16.0,
//                       ),
//                     ),
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }

//   void _register() async {
//     if (_registerFormKey.currentState.validate()) {
//       if (_pwdInputController.text == _confirmPwdInputController.text) {
//         Auth auth = Auth();
//         FirebaseUser user = await auth
//             .signUp(
//           _emailInputController.text,
//           _pwdInputController.text,
//           _firstNameInputController.text,
//           _lastNameInputController.text,
//         )
//             .catchError((err) {
//           print(err);
//           showDialog(
//             context: context,
//             builder: (BuildContext context) {
//               return AlertDialog(
//                 title: Text("Error"),
//                 content: Text("This email is already registered!"),
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
//           Navigator.pushAndRemoveUntil(
//             context,
//             MaterialPageRoute(
//               builder: (context) => HomeScreen(
//                 email: user.email,
//                 uid: user.uid,
//                 displayName: user.displayName,
//                 photoUrl: user.photoUrl,
//               ),
//             ),
//             ModalRoute.withName('/login'),
//           );
//         }

//         _firstNameInputController.clear();
//         _lastNameInputController.clear();
//         _emailInputController.clear();
//         _pwdInputController.clear();
//         _confirmPwdInputController.clear();
//       } else {
//         showDialog(
//           context: context,
//           builder: (BuildContext context) {
//             return AlertDialog(
//               title: Text("Error"),
//               content: Text("The passwords do not match"),
//               actions: <Widget>[
//                 FlatButton(
//                   child: Text("Close"),
//                   onPressed: () {
//                     Navigator.of(context).pop();
//                   },
//                 ),
//               ],
//             );
//           },
//         );
//       }
//     }
//   }
// }
