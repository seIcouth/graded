import 'package:flutter/material.dart';
import 'package:flutter_flushbar/flutter_flushbar.dart';
import 'package:graded/screens/auth_screens/login.dart';
import 'package:http/http.dart' as http;

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({Key? key}) : super(key: key);

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {

  // controllers
  final mail = TextEditingController();
  final pass = TextEditingController();
  final confirmPass = TextEditingController();
  //final role = TextEditingController();
  bool isStudent = true;
  bool isClicked = false;

  @override
  void dispose() {
    mail.dispose();
    pass.dispose();
    confirmPass.dispose();
    //role.dispose();
    super.dispose();
  }

  Future<String> register() async{
    final response = await http.post(Uri.parse("http://10.0.2.2/graded/register.php"), body: {
      "mail": mail.text,
      "password": pass.text,
      "role": isStudent ? "student" : "instructor"
      //"role": role.text,
    });

    return response.body;
  }

  bool passwordConfirmed(){
    return pass.text.trim() == confirmPass.text.trim();
  }

  bool isValidEmail(String email) {
    RegExp emailRegExp = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    return emailRegExp.hasMatch(email);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xfffff4f0),
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
                  const Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      'Create your GRADED account below',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Color(0xff0e1e40),
                      ),
                    ),
                  ),
                  const SizedBox(height: 14,),
                  Container(
                    decoration: BoxDecoration(
                      color: const Color(0xfff5f5f5),
                      border: Border.all(
                        color: const Color(0xff0e1e40),
                      ),
                      borderRadius: BorderRadius.circular(12.0),
                    ),
                    child: SizedBox(
                      width: double.infinity,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 20),
                        child: Column(
                          children: [
                            const Text(
                              'Register as',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 18,
                                color: Color(0xff0e1e40),
                              ),
                            ),
                            const SizedBox(height: 8,),
                            Flex(
                              direction: Axis.horizontal,
                              children: [
                                Expanded(
                                  child: ElevatedButton(
                                    style: ButtonStyle(
                                      shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                                          RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(12.0),
                                          )
                                      ),
                                      backgroundColor: (isClicked && isStudent) ? MaterialStateProperty.all(const Color(0xff808080)) : MaterialStateProperty.all(const Color(0xff0e1e40)),
                                    ),
                                    onPressed: () {
                                      setState(() {
                                        isClicked = true;
                                        isStudent = true;
                                      });
                                      // handle button 1 press
                                    },
                                    child: const Text('Student'),
                                  ),
                                ),
                                const SizedBox(
                                  width: 16.0,
                                ),
                                Expanded(
                                  child: ElevatedButton(
                                    style: ButtonStyle(
                                      shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                                          RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(12.0),
                                          )
                                      ),
                                      backgroundColor: (isClicked && !isStudent) ? MaterialStateProperty.all(const Color(0xff808080)) : MaterialStateProperty.all(const Color(0xff0e1e40)),
                                    ),
                                    onPressed: () {
                                      setState(() {
                                        isClicked = true;
                                        isStudent = false;
                                      });
                                      // handle button 2 press
                                    },
                                    child: const Text('Instructor'),
                                  ),
                                ),
                              ],
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 14,),
                  TextField(
                    cursorHeight: 16,
                    cursorWidth: 1.5,
                    cursorColor: const Color(0xff0e1e40),
                    controller: mail,
                    decoration: InputDecoration(
                      enabledBorder: OutlineInputBorder(
                        borderSide: const BorderSide(color: Colors.white),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: const BorderSide(color: Color(0xff0e1e40)),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      hintText: 'Email',
                      fillColor: Colors.grey[100],
                      filled: true,
                    ),
                  ),
                  /*
                  const SizedBox(
                    height: 10,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 30),
                    child: TextField(
                      cursorHeight: 16,
                      cursorWidth: 1.5,
                      cursorColor: const Color(0xff0e1e40),
                      controller: role,
                      decoration: InputDecoration(
                        enabledBorder: OutlineInputBorder(
                          borderSide: const BorderSide(color: Colors.white),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: const BorderSide(color: Color(0xff0e1e40)),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        hintText: 'Role',
                        fillColor: Colors.grey[100],
                        filled: true,
                      ),
                    ),
                  ),
                   */
                  const SizedBox(
                    height: 10,
                  ),
                  TextField(
                    obscureText: true,
                    cursorHeight: 16,
                    cursorWidth: 1.5,
                    cursorColor: const Color(0xff0e1e40),
                    controller: pass,
                    decoration: InputDecoration(
                      enabledBorder: OutlineInputBorder(
                        borderSide: const BorderSide(color: Colors.white),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: const BorderSide(color: Color(0xff0e1e40)),
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
                    cursorColor: const Color(0xff0e1e40),
                    controller: confirmPass,
                    decoration: InputDecoration(
                      enabledBorder: OutlineInputBorder(
                        borderSide: const BorderSide(color: Colors.white),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: const BorderSide(color: Color(0xff0e1e40)),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      hintText: 'Confirm password',
                      fillColor: Colors.grey[100],
                      filled: true,
                    ),
                  ),
                  const SizedBox(height: 10,),
                  ElevatedButton(
                    onPressed: () async {
                      if(mail.text.isEmpty || pass.text.isEmpty || confirmPass.text.isEmpty){
                        Flushbar(
                          message: "Please fill all necessary fields.",
                          duration: const Duration(seconds: 3),
                          margin: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom + 50),
                        ).show(context);
                      } else if(!isClicked){
                        Flushbar(
                          message: "Please select a role.",
                          duration: const Duration(seconds: 3),
                          margin: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom + 50),
                        ).show(context);
                      }
                      else{
                        if(isValidEmail(mail.text)){
                          if(!passwordConfirmed()) {
                            Flushbar(
                              message: "Given passwords do not match!",
                              duration: const Duration(seconds: 3),
                              margin: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom + 50),
                            ).show(context);
                          }
                          else{
                            if(pass.text.length>5){
                              try{
                                await register();
                                Navigator.of(context).push(
                                  MaterialPageRoute(
                                    builder: (context) => const Page1(),
                                  ),
                                );
                              } catch(e){print(e);}
                            }else{
                              Flushbar(
                                message: "The password should be at least 6 characters.",
                                duration: const Duration(seconds: 3),
                                margin: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom + 50),
                              ).show(context);
                            }
                          }
                        } else{
                          Flushbar(
                            message: "The email address is badly formatted.",
                            duration: const Duration(seconds: 3),
                            margin: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom + 50),
                          ).show(context);
                        }
                      }

                    },
                    style: ButtonStyle(
                      shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                          RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12.0),
                          )
                      ),
                      backgroundColor: MaterialStateProperty.all(const Color(0xff0e1e40)),
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
                          fontSize: 16
                        ),
                      ),
                      GestureDetector(
                        onTap: (){
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(builder: (context) => const LoginPage()),
                          );
                        },
                        child: const Text(
                          ' Login now',
                          style: TextStyle(
                              fontSize: 16,
                              color: Colors.blue,
                              fontWeight: FontWeight.bold
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
