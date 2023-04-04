import 'package:flutter/material.dart';
import 'package:graded/screens/auth_screens/login.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(fontFamily: 'San Francisco'),
      debugShowCheckedModeBanner: false,
      home: const LoginPage(),
    );
  }
}



