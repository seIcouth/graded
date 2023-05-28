// ignore_for_file: avoid_print
// ignore_for_file: use_build_context_synchronously
import 'dart:convert';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:graded/resources/reusable_methods.dart';
import 'package:graded/resources/reusable_widgets.dart';
import 'package:http/http.dart' as http;

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({Key? key, this.currentPassword})
      : super(key: key);

  final String? currentPassword;

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final _emailController = TextEditingController();
  final _currentPasswordController = TextEditingController();
  final _newPasswordController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    _currentPasswordController.dispose();
    _newPasswordController.dispose();
    super.dispose();
  }

  Future _sendResetEmail() async {
    final email = _emailController.text;
    final message = generatePassword();

    await updatePassword(email, message);

    final url = Uri.parse('https://api.emailjs.com/api/v1.0/email/send');
    final response = await http.post(url,
        headers: {
          'origin': 'http://localhost',
          'Content-Type': 'application/json',
        },
        body: json.encode({
          'service_id': 'service_vpta4w4',
          'template_id': 'template_ggy70h4',
          'user_id': 'aqgNScGI5jcdFYGqi',
          'template_params': {'message': message, 'to_email': email}
        }));

    print(response.body);
  }

  Future<void> updatePassword(String userMail, String newPassword) async {
    try {
      // Prepare the request body as a Map
      final requestBody = {
        'mail': userMail,
        'password': newPassword,
      };

      // Send a POST request to the related file on server
      final response = await http.post(
        Uri.parse('http://10.0.2.2/graded/updatepassword.php'),
        body: requestBody,
      );

      if (response.statusCode == 200) {
        // Course created successfully
        print('Password reset successfully');
      } else {
        // Handle any errors from the server
        print('Failed to reset password: ${response.body}');
      }
    } catch (e) {
      // Handle any errors locally
      print('Failed to reset password: $e');
    }
  }

  // from profile page
  String generatePassword() {
    final random = Random.secure();
    final values = List<int>.generate(8, (_) => random.nextInt(256));
    final password = base64Url.encode(values);
    return password.substring(0, 8);
  }

  Future<void> _changePassword() async {
    int? id = await ReusableMethods.getUserId();

    try {
      // Prepare the request body as a Map
      final requestBody = {
        'id': id.toString(),
        'password': _newPasswordController.text,
      };

      // Send a POST request to the related file on server
      final response = await http.post(
        Uri.parse('http://10.0.2.2/graded/updatepasswordfromprofile.php'),
        body: requestBody,
      );

      if (response.statusCode == 200) {
        // Course created successfully
        print('Password reset successfully');
      } else {
        // Handle any errors from the server
        print('Failed to reset password: ${response.body}');
      }
    } catch (e) {
      // Handle any errors locally
      print('Failed to reset password: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ReusableWidgets.colorLight,
      body: FutureBuilder(
        future: ReusableMethods.isLoggedIn(),
        builder: (context, AsyncSnapshot<bool> snapshot) {
          if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}');
          }
          switch (snapshot.connectionState) {
            case ConnectionState.waiting:
              return Center(
                child:
                    ReusableWidgets.loadingAnimation(ReusableWidgets.colorDark),
              );
            default:
              return SafeArea(
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(left: 8.0, top: 8.0),
                        child: Align(
                          alignment: Alignment.centerLeft,
                          child: IconButton(
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                            icon: Icon(
                              Icons.arrow_back_ios,
                              color: ReusableWidgets.colorDark,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        width: 300,
                        height: 300,
                        child: Image.asset('assets/images/logo_straight.png'),
                      ),
                      !(snapshot.data!)
                          ? Column(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(left: 30.0),
                                  child: Align(
                                    alignment: Alignment.centerLeft,
                                    child: Text(
                                      'Enter your email address to receive a new password',
                                      style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                        color: ReusableWidgets.colorDark,
                                      ),
                                    ),
                                  ),
                                ),
                                const SizedBox(
                                  height: 18,
                                ),
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 30),
                                  child: TextField(
                                    cursorHeight: 16,
                                    cursorWidth: 1.5,
                                    cursorColor: ReusableWidgets.colorDark,
                                    controller: _emailController,
                                    decoration: InputDecoration(
                                      enabledBorder: OutlineInputBorder(
                                        borderSide: const BorderSide(
                                            color: Colors.white),
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                      focusedBorder: OutlineInputBorder(
                                        borderSide: BorderSide(
                                            color: ReusableWidgets.colorDark),
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                      hintText: 'Email',
                                      fillColor: Colors.grey[100],
                                      filled: true,
                                    ),
                                  ),
                                ),
                                const SizedBox(
                                  height: 24,
                                ),
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 30.0),
                                  child: ElevatedButton(
                                    onPressed: () async {
                                      if (_emailController.text.isEmpty) {
                                        ReusableWidgets.flushbar(
                                            "Please enter an email address",
                                            context);
                                      } else {
                                        if (ReusableMethods.isValidEmail(
                                            _emailController.text)) {
                                          try {
                                            await _sendResetEmail();
                                            ReusableWidgets.flushbar(
                                                "Password reset successfully",
                                                context);
                                          } on FormatException {
                                            ReusableWidgets.flushbar(
                                                "Something went wrong, please try again",
                                                context);
                                          }
                                        } else {
                                          ReusableWidgets.flushbar(
                                              "The email address is badly formatted",
                                              context);
                                        }
                                      }
                                    },
                                    style: ButtonStyle(
                                      shape: MaterialStateProperty.all<
                                              RoundedRectangleBorder>(
                                          RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(12.0),
                                      )),
                                      backgroundColor:
                                          MaterialStateProperty.all(
                                              ReusableWidgets.colorDark),
                                    ),
                                    child: Container(
                                      padding: const EdgeInsets.all(20),
                                      child: const Center(
                                        child: Text(
                                          'Reset Password',
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 18,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            )
                          : Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(left: 30.0),
                                  child: Align(
                                    alignment: Alignment.centerLeft,
                                    child: Text(
                                      'Enter your current password',
                                      style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                        color: ReusableWidgets.colorDark,
                                      ),
                                    ),
                                  ),
                                ),
                                const SizedBox(
                                  height: 8,
                                ),
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 30),
                                  child: TextField(
                                    cursorHeight: 16,
                                    cursorWidth: 1.5,
                                    cursorColor: ReusableWidgets.colorDark,
                                    controller: _currentPasswordController,
                                    obscureText: true,
                                    decoration: InputDecoration(
                                      enabledBorder: OutlineInputBorder(
                                        borderSide: const BorderSide(
                                            color: Colors.white),
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                      focusedBorder: OutlineInputBorder(
                                        borderSide: BorderSide(
                                            color: ReusableWidgets.colorDark),
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                      hintText: 'Current Password',
                                      fillColor: Colors.grey[100],
                                      filled: true,
                                    ),
                                  ),
                                ),
                                const SizedBox(
                                  height: 12,
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(left: 30.0),
                                  child: Align(
                                    alignment: Alignment.centerLeft,
                                    child: Text(
                                      'Enter your new password',
                                      style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                        color: ReusableWidgets.colorDark,
                                      ),
                                    ),
                                  ),
                                ),
                                const SizedBox(
                                  height: 8,
                                ),
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 30),
                                  child: TextField(
                                    cursorHeight: 16,
                                    cursorWidth: 1.5,
                                    cursorColor: ReusableWidgets.colorDark,
                                    controller: _newPasswordController,
                                    obscureText: true,
                                    decoration: InputDecoration(
                                      enabledBorder: OutlineInputBorder(
                                        borderSide: const BorderSide(
                                            color: Colors.white),
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                      focusedBorder: OutlineInputBorder(
                                        borderSide: BorderSide(
                                            color: ReusableWidgets.colorDark),
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                      hintText: 'New Password',
                                      fillColor: Colors.grey[100],
                                      filled: true,
                                    ),
                                  ),
                                ),
                                const SizedBox(
                                  height: 24,
                                ),
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 30.0),
                                  child: ElevatedButton(
                                    onPressed: () async {
                                      if (_currentPasswordController
                                              .text.isEmpty ||
                                          _newPasswordController.text.isEmpty) {
                                        ReusableWidgets.flushbar(
                                            "Please fill all necessary fields",
                                            context);
                                      } else if (widget.currentPassword !=
                                          _currentPasswordController.text) {
                                        ReusableWidgets.flushbar(
                                            "Entered current password is wrong",
                                            context);
                                      } else {
                                        if (_newPasswordController.text.length >
                                            5) {
                                          try {
                                            await _changePassword();
                                            ReusableWidgets.flushbar(
                                                "Password reset successfully",
                                                context);
                                          } on FormatException {
                                            ReusableWidgets.flushbar(
                                                "Something went wrong, please try again",
                                                context);
                                          }
                                        } else {
                                          ReusableWidgets.flushbar(
                                              "New password should be at least 6 characters",
                                              context);
                                        }
                                      }
                                    },
                                    style: ButtonStyle(
                                      shape: MaterialStateProperty.all<
                                              RoundedRectangleBorder>(
                                          RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(12.0),
                                      )),
                                      backgroundColor:
                                          MaterialStateProperty.all(
                                              ReusableWidgets.colorDark),
                                    ),
                                    child: Container(
                                      padding: const EdgeInsets.all(20),
                                      child: const Center(
                                        child: Text(
                                          'Change Password',
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 18,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            )
                    ],
                  ),
                ),
              );
          }
        },
      ),
    );
  }
}
