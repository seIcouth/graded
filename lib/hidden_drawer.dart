import 'package:flutter/material.dart';
import 'package:graded/resources/reusable_methods.dart';
import 'package:graded/screens/auth_screens/login.dart';
import 'package:graded/screens/homepage.dart';
import 'package:graded/screens/profile_page.dart';
import 'package:hidden_drawer_menu/hidden_drawer_menu.dart';

class HiddenDrawer extends StatefulWidget {
  const HiddenDrawer({Key? key}) : super(key: key);

  @override
  State<HiddenDrawer> createState() => _HiddenDrawerState();
}

class _HiddenDrawerState extends State<HiddenDrawer> {
  List<ScreenHiddenDrawer> _pages = [];

  @override
  void initState() {
    super.initState();

    final textStyle = TextStyle(
        fontWeight: FontWeight.bold,
        fontSize: 18,
        color: ReusableMethods.colorDark);

    _pages = [
      ScreenHiddenDrawer(
          ItemHiddenMenu(
            name: 'Home',
            baseStyle: textStyle,
            selectedStyle: textStyle,
            colorLineSelected: ReusableMethods.colorDark,
          ),
          const HomePage()),
      ScreenHiddenDrawer(
          ItemHiddenMenu(
            name: 'Profile',
            baseStyle: textStyle,
            selectedStyle: textStyle,
            colorLineSelected: ReusableMethods.colorDark,
          ),
          const ProfilePage()),
      ScreenHiddenDrawer(
        ItemHiddenMenu(
            name: 'Log out',
            baseStyle: textStyle,
            selectedStyle: textStyle,
            colorLineSelected: ReusableMethods.colorDark,
            onTap: () async {
              ReusableMethods.setLoggedInFalse();
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => const LoginPage(),
                ),
              );
            }),
        const Center(child: CircularProgressIndicator()),
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return HiddenDrawerMenu(
      backgroundColorMenu: ReusableMethods.colorLight,
      screens: _pages,
      initPositionSelected: 0,
      slidePercent: 60,
      styleAutoTittleName: TextStyle(
        color: ReusableMethods.colorLight,
        fontWeight: FontWeight.bold,
      ),
    );
  }
}
