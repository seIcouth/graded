import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class ReusableMethods {
  static Color colorDark = const Color(0xff0e1e40);
  static Color colorLight = const Color(0xfffff4f0);
  static Color colorAnnouncement = const Color(0xff2196f3).withOpacity(0.8);
  static Color colorAssignment = const Color(0xffff6340).withOpacity(0.8);
  static Color colorPeople = const Color(0xff7c4dff).withOpacity(0.8);
  static Color colorGrades = const Color(0xff009688).withOpacity(0.8);
  static Color colorProfile1 = const Color(0xffA84D6F).withOpacity(0.8);
  static Color colorProfile2 = const Color(0xffE47668).withOpacity(0.8);
  static Color colorProfile3 = const Color(0xffFFB25D).withOpacity(0.8);

  static String role = '';

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

  static Future<String> getRole() async {
    int? id = await ReusableMethods.getUserId();

    // Construct the URL with the user ID
    String url = 'http://10.0.2.2/graded/getuserinfo.php?id=$id';

    // Make an HTTP GET request to the PHP script
    http.Response response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      // If the response is successful (status code 200)
      // Parse the response body as JSON
      List<dynamic> userData = json.decode(response.body);

      // Access the user data from the JSON response
      // assuming the response is an array containing a single user object
      Map<String, dynamic> user = userData.isNotEmpty ? userData[0] : {};

      // Use the user data as needed
      role = user['role'] == 'student' ? 'Student' : 'Instructor';

      return role;
      //print("$name - $surname - $deptName - $role - $mail");
    } else {
      return '-1';
      // If the response is not successful
      print('Failed to get user info. Status code: ${response.statusCode}');
    }
  }
}
