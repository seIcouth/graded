import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:graded/screens/auth_screens/register.dart';
import 'package:graded/screens/auth_screens/change_password.dart';
import 'package:graded/hidden_drawer.dart';
import 'package:graded/resources/reusable_methods.dart';
import 'package:graded/resources/reusable_widgets.dart';
import 'package:http/http.dart' as http;

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  TextEditingController mail = TextEditingController();
  TextEditingController pass = TextEditingController();

  Future<List> login() async {
    final response = await http.post(
        Uri.parse("http://10.0.2.2/graded/login.php"),
        body: {"mail": mail.text, "password": pass.text});

    List<dynamic> datauser = json.decode(response.body);

    if (datauser.isNotEmpty) {
      if (datauser[0]['role'] == 'student') {
        int id = int.parse(datauser[0]['id']);
        ReusableMethods.setUserId(id);
        ReusableMethods.setLoggedInTrue();
        // ignore: use_build_context_synchronously
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => const HiddenDrawer(),
          ),
        );
      } else if (datauser[0]['role'] == 'instructor') {
        int id = int.parse(datauser[0]['id']);
        ReusableMethods.setUserId(id);
        ReusableMethods.setLoggedInTrue();
        // ignore: use_build_context_synchronously
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => const HiddenDrawer(),
          ),
        );
      }
    } else {
      throw const FormatException('Expected at least 1 section');
    }

    return datauser;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ReusableWidgets.colorLight,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  width: 300,
                  height: 300,
                  child: Image.asset('assets/images/logo_straight.png'),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 30.0),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      'Login to your GRADED account',
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
                  padding: const EdgeInsets.symmetric(horizontal: 30),
                  child: TextField(
                    cursorHeight: 16,
                    cursorWidth: 1.5,
                    cursorColor: ReusableWidgets.colorDark,
                    controller: mail,
                    decoration: InputDecoration(
                      enabledBorder: OutlineInputBorder(
                        borderSide: const BorderSide(color: Colors.white),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide:
                            BorderSide(color: ReusableWidgets.colorDark),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      hintText: 'Email',
                      fillColor: Colors.grey[100],
                      filled: true,
                    ),
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 30),
                  child: TextField(
                    obscureText: true,
                    cursorHeight: 16,
                    cursorWidth: 1.5,
                    cursorColor: ReusableWidgets.colorDark,
                    controller: pass,
                    decoration: InputDecoration(
                      enabledBorder: OutlineInputBorder(
                        borderSide: const BorderSide(color: Colors.white),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide:
                            BorderSide(color: ReusableWidgets.colorDark),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      hintText: 'Password',
                      fillColor: Colors.grey[100],
                      filled: true,
                    ),
                  ),
                ),
                const SizedBox(
                  height: 14,
                ),
                Padding(
                  padding: const EdgeInsets.only(right: 30.0),
                  child: Align(
                      alignment: Alignment.centerRight,
                      child: GestureDetector(
                        onTap: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (context) =>
                                  const ForgotPasswordScreen(),
                            ),
                          );
                        },
                        child: const Text('Forgot password?',
                            style: TextStyle(
                                fontSize: 16,
                                color: Colors.blue,
                                fontWeight: FontWeight.bold)),
                      )),
                ),
                const SizedBox(
                  height: 14,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 30.0),
                  child: ElevatedButton(
                    onPressed: () async {
                      if (mail.text.isEmpty || pass.text.isEmpty) {
                        ReusableWidgets.flushbar(
                            "Please fill all necessary fields", context);
                      } else {
                        if (ReusableMethods.isValidEmail(mail.text)) {
                          try {
                            await login();
                          } on FormatException {
                            ReusableWidgets.flushbar(
                                "Something went wrong, please try again",
                                context);
                          }
                        } else {
                          ReusableWidgets.flushbar(
                              "The email address is badly formatted", context);
                        }
                      }
                    },
                    style: ButtonStyle(
                      shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                          RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12.0),
                      )),
                      backgroundColor:
                          MaterialStateProperty.all(ReusableWidgets.colorDark),
                    ),
                    child: Container(
                      padding: const EdgeInsets.all(20),
                      child: const Center(
                        child: Text(
                          'Login',
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
                const SizedBox(
                  height: 24,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'New to GRADED?',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: ReusableWidgets.colorDark,
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) => const RegisterScreen(),
                          ),
                        );
                      },
                      child: const Text(
                        ' Register now',
                        style: TextStyle(
                            fontSize: 16,
                            color: Colors.blue,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
