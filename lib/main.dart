import 'package:flutter/material.dart';
import 'package:graded/resources/reusable_methods.dart';
import 'package:graded/screens/auth_screens/login.dart';
import 'hidden_drawer.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  bool isLoggedIn = await ReusableMethods.isLoggedIn();
  runApp(MyApp(isLoggedIn: isLoggedIn));
}

class MyApp extends StatelessWidget {
  final bool isLoggedIn;

  const MyApp({Key? key, required this.isLoggedIn}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        fontFamily: 'San Francisco',
        visualDensity: VisualDensity.adaptivePlatformDensity,
        colorScheme: ColorScheme.fromSwatch()
            .copyWith(
              primary: ReusableMethods.colorDark,
            )
            .copyWith(secondary: ReusableMethods.colorDark),
      ),
      debugShowCheckedModeBanner: false,
      home: isLoggedIn ? const HiddenDrawer() : const LoginPage(),
    );
  }
}
