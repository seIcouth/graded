import 'package:flutter/material.dart';
import 'package:graded/resources/reusable_methods.dart';
import 'package:graded/screens/auth_screens/login.dart';
import 'package:graded/screens/homepage.dart';
import 'package:graded/screens/invitations_page.dart';
import 'package:graded/screens/profile_page.dart';
import 'package:hidden_drawer_menu/hidden_drawer_menu.dart';

class HiddenDrawer extends StatefulWidget {
  const HiddenDrawer({Key? key}) : super(key: key);

  @override
  State<HiddenDrawer> createState() => _HiddenDrawerState();
}

class _HiddenDrawerState extends State<HiddenDrawer> {
  List<ScreenHiddenDrawer> _pagesStudent = [];
  List<ScreenHiddenDrawer> _pagesInstructor = [];

  @override
  void initState() {
    super.initState();

    final textStyleDark = TextStyle(
        fontWeight: FontWeight.bold,
        fontSize: 18,
        color: ReusableMethods.colorDark);
    final textStyleLogOut = TextStyle(
        fontWeight: FontWeight.bold,
        fontSize: 18,
        color: ReusableMethods.colorAssignment);

    _pagesInstructor = [
      ScreenHiddenDrawer(
          ItemHiddenMenu(
            name: 'Home',
            baseStyle: textStyleDark,
            selectedStyle: textStyleDark,
            colorLineSelected: ReusableMethods.colorDark,
          ),
          const HomePage()),
      ScreenHiddenDrawer(
          ItemHiddenMenu(
            name: 'Profile',
            baseStyle: textStyleDark,
            selectedStyle: textStyleDark,
            colorLineSelected: ReusableMethods.colorDark,
          ),
          const ProfilePage()),
      ScreenHiddenDrawer(
        ItemHiddenMenu(
            name: 'Log out',
            baseStyle: textStyleLogOut,
            selectedStyle: textStyleLogOut,
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

    _pagesStudent = [
      ScreenHiddenDrawer(
          ItemHiddenMenu(
            name: 'Home',
            baseStyle: textStyleDark,
            selectedStyle: textStyleDark,
            colorLineSelected: ReusableMethods.colorDark,
          ),
          const HomePage()),
      ScreenHiddenDrawer(
          ItemHiddenMenu(
            name: 'Profile',
            baseStyle: textStyleDark,
            selectedStyle: textStyleDark,
            colorLineSelected: ReusableMethods.colorDark,
          ),
          const ProfilePage()),
      ScreenHiddenDrawer(
          ItemHiddenMenu(
            name: 'Invitations',
            baseStyle: textStyleDark,
            selectedStyle: textStyleDark,
            colorLineSelected: ReusableMethods.colorDark,
          ),
          const InvitationsPage()),
      ScreenHiddenDrawer(
        ItemHiddenMenu(
            name: 'Log out',
            baseStyle: textStyleLogOut,
            selectedStyle: textStyleLogOut,
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
    return FutureBuilder(
      future: ReusableMethods.getRole(),
      builder: (context, AsyncSnapshot<String> snapshot) {
        if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        }
        switch (snapshot.connectionState) {
          case ConnectionState.waiting:
            return Center(
              child: CircularProgressIndicator(
                backgroundColor: ReusableMethods.colorLight,
                color: ReusableMethods.colorDark,
              ),
            );
          default:
            return HiddenDrawerMenu(
              disableAppBarDefault: true,
              backgroundColorMenu: ReusableMethods.colorLight,
              backgroundMenu: const DecorationImage(
                  image: AssetImage('assets/images/logo_straight.png'),
                  alignment: Alignment(-0.80, -0.75),
                  fit: BoxFit.scaleDown),
              screens:
                  snapshot.data == 'Student' ? _pagesStudent : _pagesInstructor,
              initPositionSelected: 0,
              slidePercent: 60,
              styleAutoTittleName: TextStyle(
                color: ReusableMethods.colorLight,
                fontWeight: FontWeight.bold,
              ),
            );
        }
      },
    );
  }
}
