import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ReusableMethods {
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

  static String formatDateString(String date) {
    DateTime dateTime = DateTime.parse(date);
    String formattedDate = DateFormat('d MMM y \'at\' HH:mm').format(dateTime);
    return formattedDate;
  }

  static String formatDateTime(DateTime date) =>
      DateFormat("MMMM d - hh:mm").format(date);
}
