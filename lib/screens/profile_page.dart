import 'package:flutter/material.dart';
import '../resources/reusable_methods.dart';
import 'auth_screens/login.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final double coverHeight = 240;
  final double profileHeight = 144;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ReusableMethods.colorLight,
      body: ListView(
        padding: EdgeInsets.zero,
        children: [
          buildTop(),
          buildContent(),
        ],
      ),
    );
  }

  Widget buildCoverImage() => Container(
        color: ReusableMethods.colorLight,
        child: Image.asset(
          'assets/images/background_library.jpg',
          width: double.infinity,
          //height: coverHeight,
          fit: BoxFit.cover,
        ),
      );

  Widget buildProfileImage() => Container(
        decoration: BoxDecoration(
          border: Border.all(width: 3.5, color: ReusableMethods.colorDark),
          borderRadius: BorderRadius.circular(30.0),
          color: ReusableMethods.colorLight,
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(30.0),
          child: Image.asset(
            'assets/images/graduation.png',
            width: 512 / 4,
            height: 512 / 4,
            fit: BoxFit.fill,
          ),
        ),
      );

  /*
  Widget buildProfileImage() => CircleAvatar(
        radius: profileHeight / 2,
        backgroundColor: ReusableMethods.colorLight,
        backgroundImage: const AssetImage('assets/images/graduation.png'),
      );
  */

  Widget buildTop() {
    final top = coverHeight - profileHeight / 2;
    final bottom = profileHeight / 2;
    return Stack(
      clipBehavior: Clip.none,
      alignment: Alignment.center,
      children: [
        Container(
            margin: EdgeInsets.only(
              bottom: bottom,
            ),
            child: buildCoverImage()),
        Positioned(
          top: top,
          child: buildProfileImage(),
        ),
      ],
    );
  }

  Widget buildContent() {
    return Container();
  }
}
