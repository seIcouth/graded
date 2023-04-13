import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_flushbar/flutter_flushbar.dart';
import 'package:graded/hidden_drawer.dart';
import 'package:graded/resources/reusable_methods.dart';
import 'package:graded/screens/auth_screens/login.dart';
import 'package:http/http.dart' as http;

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({Key? key}) : super(key: key);

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  // controllers
  final nameController = TextEditingController();
  final surnameController = TextEditingController();
  final deptName = TextEditingController();
  final mailController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();
  //final role = TextEditingController();
  bool isStudent = true;
  bool isClicked = false;

  @override
  void dispose() {
    mailController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    //role.dispose();
    super.dispose();
  }

  Future<String> register() async {
    final response = await http
        .post(Uri.parse("http://10.0.2.2/graded/register.php"), body: {
      "mail": mailController.text,
      "password": passwordController.text,
      "role": isStudent ? "student" : "instructor",
      "name": nameController.text,
      "surname": surnameController.text,
      "deptName": deptName.text,
    });

    List<dynamic> datauser = json.decode(response.body);
    int id = int.parse(datauser[0]['id']);
    ReusableMethods.setUserId(id);
    ReusableMethods.setLoggedInTrue();

    return response.body;
  }

  bool passwordConfirmed() {
    return passwordController.text.trim() ==
        confirmPasswordController.text.trim();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ReusableMethods.colorLight,
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 30.0),
              child: Column(
                children: [
                  SizedBox(
                    width: 250,
                    height: 250,
                    child: Image.asset('assets/images/logo_straight.png'),
                  ),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      'Create your GRADED account below',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: ReusableMethods.colorDark,
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 14,
                  ),
                  Container(
                    decoration: BoxDecoration(
                      color: const Color(0xfff5f5f5),
                      border: Border.all(
                        color: ReusableMethods.colorDark,
                      ),
                      borderRadius: BorderRadius.circular(12.0),
                    ),
                    child: SizedBox(
                      width: double.infinity,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 15.0, vertical: 20),
                        child: Column(
                          children: [
                            Text(
                              'Register as',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 18,
                                color: ReusableMethods.colorDark,
                              ),
                            ),
                            const SizedBox(
                              height: 8,
                            ),
                            Flex(
                              direction: Axis.horizontal,
                              children: [
                                Expanded(
                                  child: ElevatedButton(
                                    style: ButtonStyle(
                                      shape: MaterialStateProperty.all<
                                              RoundedRectangleBorder>(
                                          RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(12.0),
                                      )),
                                      backgroundColor: (isClicked && isStudent)
                                          ? MaterialStateProperty.all(
                                              const Color(0xff808080))
                                          : MaterialStateProperty.all(
                                              ReusableMethods.colorDark),
                                    ),
                                    onPressed: () {
                                      setState(() {
                                        isClicked = true;
                                        isStudent = true;
                                      });
                                      // handle button 1 press
                                    },
                                    child: Stack(
                                      children: [
                                        const Align(
                                          alignment: Alignment.center,
                                          child: Text('Student'),
                                        ),
                                        Visibility(
                                            visible: (isClicked && isStudent),
                                            child: const Align(
                                                alignment: Alignment.centerLeft,
                                                child: Icon(CupertinoIcons
                                                    .check_mark_circled))),
                                      ],
                                    ),
                                  ),
                                ),
                                const SizedBox(
                                  width: 16.0,
                                ),
                                Expanded(
                                  child: ElevatedButton(
                                    style: ButtonStyle(
                                      shape: MaterialStateProperty.all<
                                              RoundedRectangleBorder>(
                                          RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(12.0),
                                      )),
                                      backgroundColor: (isClicked && !isStudent)
                                          ? MaterialStateProperty.all(
                                              const Color(0xff808080))
                                          : MaterialStateProperty.all(
                                              ReusableMethods.colorDark),
                                    ),
                                    onPressed: () {
                                      setState(() {
                                        isClicked = true;
                                        isStudent = false;
                                      });
                                      // handle button 2 press
                                    },
                                    child: Stack(
                                      children: [
                                        const Align(
                                            alignment: Alignment.center,
                                            child: Text('Instructor')),
                                        Visibility(
                                            visible: (isClicked && !isStudent),
                                            child: const Align(
                                                alignment: Alignment.centerLeft,
                                                child: Icon(CupertinoIcons
                                                    .check_mark_circled))),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 14,
                  ),
                  TextField(
                    cursorHeight: 16,
                    cursorWidth: 1.5,
                    cursorColor: ReusableMethods.colorDark,
                    controller: nameController,
                    decoration: InputDecoration(
                      enabledBorder: OutlineInputBorder(
                        borderSide: const BorderSide(color: Colors.white),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide:
                            BorderSide(color: ReusableMethods.colorDark),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      hintText: 'Name',
                      fillColor: Colors.grey[100],
                      filled: true,
                    ),
                  ),
                  const SizedBox(
                    height: 14,
                  ),
                  TextField(
                    cursorHeight: 16,
                    cursorWidth: 1.5,
                    cursorColor: ReusableMethods.colorDark,
                    controller: surnameController,
                    decoration: InputDecoration(
                      enabledBorder: OutlineInputBorder(
                        borderSide: const BorderSide(color: Colors.white),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide:
                            BorderSide(color: ReusableMethods.colorDark),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      hintText: 'Surname',
                      fillColor: Colors.grey[100],
                      filled: true,
                    ),
                  ),
                  const SizedBox(
                    height: 14,
                  ),
                  TextField(
                    cursorHeight: 16,
                    cursorWidth: 1.5,
                    cursorColor: ReusableMethods.colorDark,
                    controller: deptName,
                    decoration: InputDecoration(
                      enabledBorder: OutlineInputBorder(
                        borderSide: const BorderSide(color: Colors.white),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide:
                            BorderSide(color: ReusableMethods.colorDark),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      hintText: 'Department',
                      fillColor: Colors.grey[100],
                      filled: true,
                    ),
                  ),
                  const SizedBox(
                    height: 14,
                  ),
                  TextField(
                    cursorHeight: 16,
                    cursorWidth: 1.5,
                    cursorColor: ReusableMethods.colorDark,
                    controller: mailController,
                    decoration: InputDecoration(
                      enabledBorder: OutlineInputBorder(
                        borderSide: const BorderSide(color: Colors.white),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide:
                            BorderSide(color: ReusableMethods.colorDark),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      hintText: 'Email',
                      fillColor: Colors.grey[100],
                      filled: true,
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  TextField(
                    obscureText: true,
                    cursorHeight: 16,
                    cursorWidth: 1.5,
                    cursorColor: ReusableMethods.colorDark,
                    controller: passwordController,
                    decoration: InputDecoration(
                      enabledBorder: OutlineInputBorder(
                        borderSide: const BorderSide(color: Colors.white),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide:
                            BorderSide(color: ReusableMethods.colorDark),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      hintText: 'Password',
                      fillColor: Colors.grey[100],
                      filled: true,
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  TextField(
                    obscureText: true,
                    cursorHeight: 16,
                    cursorWidth: 1.5,
                    cursorColor: ReusableMethods.colorDark,
                    controller: confirmPasswordController,
                    decoration: InputDecoration(
                      enabledBorder: OutlineInputBorder(
                        borderSide: const BorderSide(color: Colors.white),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide:
                            BorderSide(color: ReusableMethods.colorDark),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      hintText: 'Confirm password',
                      fillColor: Colors.grey[100],
                      filled: true,
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  ElevatedButton(
                    onPressed: () async {
                      if (mailController.text.isEmpty ||
                          passwordController.text.isEmpty ||
                          confirmPasswordController.text.isEmpty) {
                        Flushbar(
                          message: "Please fill all necessary fields.",
                          duration: const Duration(seconds: 3),
                          margin: EdgeInsets.only(
                              bottom: MediaQuery.of(context).viewInsets.bottom +
                                  50),
                        ).show(context);
                      } else if (!isClicked) {
                        Flushbar(
                          message: "Please select a role.",
                          duration: const Duration(seconds: 3),
                          margin: EdgeInsets.only(
                              bottom: MediaQuery.of(context).viewInsets.bottom +
                                  50),
                        ).show(context);
                      } else {
                        if (ReusableMethods.isValidEmail(mailController.text)) {
                          if (!passwordConfirmed()) {
                            Flushbar(
                              message: "Given passwords do not match!",
                              duration: const Duration(seconds: 3),
                              margin: EdgeInsets.only(
                                  bottom:
                                      MediaQuery.of(context).viewInsets.bottom +
                                          50),
                            ).show(context);
                          } else {
                            if (passwordController.text.length > 5) {
                              try {
                                await register();
                                Navigator.of(context).push(
                                  MaterialPageRoute(
                                    builder: (context) => const HiddenDrawer(),
                                  ),
                                );
                              } catch (e) {
                                print(e);
                              }
                            } else {
                              Flushbar(
                                message:
                                    "The password should be at least 6 characters.",
                                duration: const Duration(seconds: 3),
                                margin: EdgeInsets.only(
                                    bottom: MediaQuery.of(context)
                                            .viewInsets
                                            .bottom +
                                        50),
                              ).show(context);
                            }
                          }
                        } else {
                          Flushbar(
                            message: "The email address is badly formatted.",
                            duration: const Duration(seconds: 3),
                            margin: EdgeInsets.only(
                                bottom:
                                    MediaQuery.of(context).viewInsets.bottom +
                                        50),
                          ).show(context);
                        }
                      }
                    },
                    style: ButtonStyle(
                      shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                          RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12.0),
                      )),
                      backgroundColor:
                          MaterialStateProperty.all(ReusableMethods.colorDark),
                    ),
                    child: Container(
                      padding: const EdgeInsets.all(20),
                      child: const Center(
                        child: Text(
                          'Register',
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 18,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        'Already have an account?',
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Color(0xff153243),
                            fontSize: 16),
                      ),
                      GestureDetector(
                        onTap: () {
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const LoginPage()),
                          );
                        },
                        child: const Text(
                          ' Login now',
                          style: TextStyle(
                              fontSize: 16,
                              color: Colors.blue,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 30,
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
