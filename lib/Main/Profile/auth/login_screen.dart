import 'dart:convert';

import 'package:agni_app/Main/Profile/auth/register_screen.dart';
import 'package:agni_app/models/user.dart';
import 'package:agni_app/Main/main_screen.dart';
import 'package:agni_app/services/user_service.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
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

  _login(BuildContext context, User user) async {
    var _userService = UserService();
    var registeredUser = await _userService.login(user);
    print(registeredUser.body);
    var result = json.decode(registeredUser.body);

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
                      user.fcmToken = _fcmToken;
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


// import 'package:flutter/gestures.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter/scheduler.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:learn_fazz/app_config.dart';
// import 'package:learn_fazz/assets/learn_fazz_icons.dart';
// import 'package:learn_fazz/blocs/auth/auth.dart';
// import 'package:learn_fazz/blocs/login/login.dart';
// import 'package:learn_fazz/pages/dashboard_page.dart';
// import 'package:learn_fazz/pages/register_choice_page.dart';

// class LoginPage extends StatefulWidget {
//   static const String tag = '/login-screen';

//   LoginPage({this.loginBloc});
  
//   final LoginBloc loginBloc;
  
//   @override
//   State<StatefulWidget> createState() => _LoginPageState();
// }

// class _LoginPageState extends State<LoginPage> {
//   String _email;
//   String _password;
//   bool _obscureText = true;

//   final GlobalKey formKey = GlobalKey<FormState>();
//   final Color borderColor = Colors.black.withOpacity(0.4);

//   LoginBloc _loginBloc;

//   @override
//   void didChangeDependencies() {
//     _loginBloc = widget.loginBloc ?? LoginBloc(
//       authRepository: AppConfig.of(context)?.authRepository,
//       authBloc: BlocProvider.of<AuthBloc>(context),
//     );
//     super.didChangeDependencies();
//   }

//   @override
//   void dispose() {
//     _loginBloc.dispose();
//     super.dispose();
//   }

//   onLoginButtonPressed() {
//     final FormState form = formKey.currentState;
//     if (form.validate()) {
//       form.save();
//       _loginBloc?.dispatch(LoginButtonPressed(email: _email, password: _password));
//     }
//   }

//   Widget buildWidget(BuildContext context, bool _isLoading, LoginState state) {
//     final Image payfazzLogo = Image.asset(
//         'lib/assets/images/learnfazz-color.png',
//         key: const Key('logo'));

//     final TextFormField email = TextFormField(
//       autofocus: true,
//       style: const TextStyle(color: Colors.black, fontSize: 16.0),
//       keyboardType: TextInputType.emailAddress,
//       decoration: InputDecoration(
//         fillColor: Colors.white,
//         filled: true,
//         hintText: 'Email',
//         hintStyle: const TextStyle(color: Colors.black54),
//         contentPadding: const EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
//         border: OutlineInputBorder(
//           borderRadius: BorderRadius.circular(32.0),
//         ),
//         enabledBorder: OutlineInputBorder(
//           borderRadius: BorderRadius.circular(32.0),
//           borderSide: BorderSide(width: 1.5, color: borderColor),
//         ),
//         prefixIcon: const Icon(
//           LearnFazz.mail,
//           color: Colors.black54,
//         ),
//       ),
//       validator: (String value) {
//         if (value.isEmpty) {
//           return 'email cannot be empty';
//         } else if (value.isNotEmpty && !value.contains('@gmail.')) {
//           return 'invalid email address';
//         }
//       },
//       onSaved: (String value) => _email = value,
//     );

//     final TextFormField password = TextFormField(
//       key: const Key('password'),
//       style: const TextStyle(color: Colors.black, fontSize: 16.0),
//       obscureText: _obscureText,
//       decoration: InputDecoration(
//         fillColor: Colors.white,
//         filled: true,
//         hintText: 'Password',
//         hintStyle: const TextStyle(color: Colors.black54),
//         contentPadding: const EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
//         border: OutlineInputBorder(
//           borderRadius: BorderRadius.circular(32.0),
//         ),
//         enabledBorder: OutlineInputBorder(
//           borderRadius: BorderRadius.circular(32.0),
//           borderSide: BorderSide(width: 1.5, color: borderColor),
//         ),
//         prefixIcon: const Icon(
//           LearnFazz.lock,
//           color: Colors.black54,
//         ),
//         suffixIcon: IconButton(
//             key: const Key('showPasswordButton'),
//             icon: Icon(
//               _obscureText ? Icons.visibility : Icons.visibility_off,
//               semanticLabel: _obscureText ? 'hide password' : 'show password',
//             ),
//             onPressed: () {
//               setState(() {
//                 _obscureText = !_obscureText;
//                 print(
//                     'Icon button pressed! state: $_obscureText'); //Confirmed that the _passwordVisible is toggled each time the button is pressed.
//               });
//             }),
//       ),
//       validator: (String value) =>
//           value.isEmpty ? 'password cannot be empty' : null,
//       onSaved: (String value) => _password = value,
//     );

//     final RichText forgotPassword = RichText(
//       text: TextSpan(children: <TextSpan>[
//         TextSpan(
//             text: 'Forgot Password',
//             style: const TextStyle(
//                 color: Colors.black54,
//                 fontWeight: FontWeight.bold,
//                 decoration: TextDecoration.underline),
//             recognizer: TapGestureRecognizer()..onTap = null)
//       ]),
//       textAlign: TextAlign.center,
//     );
//     final Widget haveAccount = Row(
//       mainAxisAlignment: MainAxisAlignment.center,
//       crossAxisAlignment: CrossAxisAlignment.center,
//       children: <Widget>[
//         const Text(
//           'Don\'t have an account? ',
//           style: TextStyle(color: Colors.black54),
//         ),
//         InkWell(
//           key: const Key('signUp'),
//           child: const Text('SIGN UP',
//               style: TextStyle(
//                   color: Colors.black54,
//                   fontWeight: FontWeight.bold,
//                   decoration: TextDecoration.underline)),
//           onTap: _isLoading
//               ? null
//               : () => Navigator.of(context).pushNamed(RegisterChoicePage.tag),
//         ),
//       ],
//     );

//     Widget bottomNavigationBar;
//     if (_isLoading) {
//       bottomNavigationBar = const LinearProgressIndicator();
//     }

//     return Scaffold(
//       backgroundColor: Colors.lightBlueAccent,
//       body: Builder(
//         builder: (BuildContext context) {
//           if (state is LoginFailure) {
//             SchedulerBinding.instance.addPostFrameCallback((_) {
//               Scaffold.of(context).showSnackBar(
//                 SnackBar(
//                   content: Text(state.error),
//                 ),
//               );
//             });
//           } else if (state is LoginSucceed) {
//             SchedulerBinding.instance.addPostFrameCallback((_) {
//               if (Navigator.of(context).canPop()) {
//                 Navigator.of(context).pop();
//               }
//               Navigator.of(context).pushReplacement(
//                 MaterialPageRoute(builder: (context) => DashboardPage(user: state.user))
//               );
//             });
//           }
//           return Container(
//             decoration: const BoxDecoration(
//                 image: DecorationImage(
//               image: AssetImage('lib/assets/images/pattern-bg.png'),
//               fit: BoxFit.cover,
//             )),
//             child: Form(
//               key: formKey,
//               child: ListView(
//                 padding:
//                     const EdgeInsets.only(top: 210.0, left: 50.0, right: 50.0),
//                 children: <Widget>[
//                   payfazzLogo,
//                   const SizedBox(height: 10.0),
//                   email,
//                   const SizedBox(height: 8.0),
//                   password,
//                   const SizedBox(height: 8.0),
//                   InkWell(
//                     key: const Key('signInButton'),
//                     onTap: onLoginButtonPressed,
//                     child: Container(
//                       //width: 100.0,
//                       height: 50.0,
//                       decoration: BoxDecoration(
//                         color: _isLoading ? Colors.grey : Colors.blueAccent,
//                         borderRadius: BorderRadius.circular(30.0),
//                       ),
//                       child: const Center(
//                         child: Text(
//                           'Sign In',
//                           style: TextStyle(fontSize: 18.0, color: Colors.white),
//                         ),
//                       ),
//                     ),
//                   ),
//                   const SizedBox(height: 8.0),
//                   forgotPassword,
//                   const SizedBox(height: 125.0),
//                   haveAccount,
//                   const SizedBox(height: 5.0),
//                 ],
//               ),
//             ));
//         },
//       ),
//       bottomNavigationBar: bottomNavigationBar,
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     return BlocBuilder<LoginEvent, LoginState>(
//       bloc: _loginBloc,
//       builder: (BuildContext context, LoginState state) {
//         return buildWidget(context, state is LoginLoading, state);
//       },
//     );
//   }
// }
