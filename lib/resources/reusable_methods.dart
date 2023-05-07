import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ReusableMethods {
  static Color colorDark = const Color(0xff0e1e40);
  static Color colorLight = const Color(0xfffff4f0);
  static Color colorAnnouncement = const Color(0xff2196f3).withOpacity(0.8);
  static Color colorAssignment = const Color(0xffff6340).withOpacity(0.8);
  static Color colorPeople = const Color(0xff662D9C).withOpacity(0.8);
  static Color colorPeople1 = const Color(0xff662D9C).withOpacity(0.6);
  static Color colorPeople2 = const Color(0xffED1F79).withOpacity(0.6);
  static Color colorGrades = const Color(0xff009688).withOpacity(0.8);
  static Color colorProfile1 = const Color(0xffA84D6F).withOpacity(0.8);
  static Color colorProfile2 = const Color(0xffE47668).withOpacity(0.8);
  static Color colorProfile2_1 = const Color(0xffE47668);
  static Color colorProfile3 = const Color(0xffFFB25D).withOpacity(0.8);
  static Color colorProfile3_1 = const Color(0xffFFB25D);
  static Color colorCourse1 = const Color(0xff0e1c26);
  static Color colorCourse2 = const Color(0xff2a454b);
  static Color colorCourse3 = const Color(0xff294861);
  static Color colorAnnouncement1 = const Color(0xff2E3192);
  static Color colorAnnouncement2 = const Color(0xff1BFFFF).withOpacity(0.4);
  static Color colorAssignment1 = const Color(0xffFF5F6D);
  static Color colorAssignment2 = const Color(0xffFFC371);
  /*
    > announcements : #2E3192 → #1BFFFF
    > assignments : #FF5F6D -> #FFC371
    > people : #662D9C -> #ED1E79
    > grades : #11998E -> #38EF7D
  */

  static bool isValidEmail(String email) {
    RegExp emailRegExp = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    return emailRegExp.hasMatch(email);
  }

  static Future<bool> isLoggedIn() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool isLoggedIn = prefs.getBool('isLoggedIn') ?? false;
    return isLoggedIn;
  }

  static Future<void> setLoggedInTrue() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isLoggedIn', true);
  }

  static Future<void> setLoggedInFalse() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isLoggedIn', false);
  }

  static Future<void> setUserId(int id) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setInt('id', id);
  }

  static Future<int?> getUserId() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getInt('id');
  }
}
