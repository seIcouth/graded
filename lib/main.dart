import 'package:flutter/material.dart';
import 'package:graded/screens/auth_screens/login.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'hidden_drawer.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SharedPreferences prefs = await SharedPreferences.getInstance();
  bool isLoggedIn = prefs.getBool('isLoggedIn') ?? false;
  runApp(MyApp(isLoggedIn: isLoggedIn));
}

class MyApp extends StatelessWidget {
  final bool isLoggedIn;
  final Color colorDark = const Color(0xff0e1e40);

  const MyApp({Key? key, required this.isLoggedIn}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
          fontFamily: 'San Francisco',
          colorScheme: ColorScheme.fromSwatch().copyWith(
            primary: colorDark,
          ),
      ),
      debugShowCheckedModeBanner: false,
      home: isLoggedIn ? const HiddenDrawer() : const LoginPage(),
    );
  }
}

