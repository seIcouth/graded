import 'package:flutter/material.dart';
import 'package:graded/screens/auth_screens/login.dart';
import 'package:graded/screens/homepage.dart';
import 'package:graded/screens/profile_page.dart';
import 'package:hidden_drawer_menu/hidden_drawer_menu.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HiddenDrawer extends StatefulWidget {
  const HiddenDrawer({Key? key}) : super(key: key);

  @override
  State<HiddenDrawer> createState() => _HiddenDrawerState();
}

class _HiddenDrawerState extends State<HiddenDrawer> {
  final Color colorDark = const Color(0xff0e1e40);
  final Color colorLight = const Color(0xfffff4f0);
  final Color colorBlue = const Color(0xff023e8a);

  List<ScreenHiddenDrawer> _pages = [];

  @override
  void initState() {
    super.initState();

    final textStyle = TextStyle(
        fontWeight: FontWeight.bold,
        fontSize: 18,
        color: colorLight
    );

    _pages = [
      ScreenHiddenDrawer(
          ItemHiddenMenu(
            name: 'Home',
            baseStyle: textStyle,
            selectedStyle: textStyle,
            colorLineSelected: Colors.white,
          ),
          const HomePage()
      ),
      ScreenHiddenDrawer(
          ItemHiddenMenu(
            name: 'Profile',
            baseStyle: textStyle,
            selectedStyle: textStyle,
            colorLineSelected: Colors.white,
          ),
          const ProfilePage()
      ),
      ScreenHiddenDrawer(
          ItemHiddenMenu(
            name: 'Log out',
            baseStyle: textStyle,
            selectedStyle: textStyle,
            colorLineSelected: Colors.white,
            onTap: () async {
              SharedPreferences prefs =
                  await SharedPreferences.getInstance();
              await prefs.setBool('isLoggedIn', false);
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => const LoginPage(),
                ),
              );
            }
          ),
        const Center(child: CircularProgressIndicator()),
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return HiddenDrawerMenu(
      backgroundColorMenu: colorBlue,
      screens: _pages,
      initPositionSelected: 0,
      slidePercent: 60,
      styleAutoTittleName: TextStyle(
        color: colorLight,
        fontWeight: FontWeight.bold,
      ),
    );
  }
}
