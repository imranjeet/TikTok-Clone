import 'package:agni_app/providers/users.dart';
import 'package:agni_app/providers/videos.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'Main/Profile/auth/login_screen.dart';
import 'Main/main_screen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp, DeviceOrientation.portraitDown
    ]);

  SharedPreferences _prefs = await SharedPreferences.getInstance();
  var currentUserId = _prefs.getInt('userId');

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
          title: 'New App',
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
