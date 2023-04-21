// ignore_for_file: avoid_print

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hidden_drawer_menu/controllers/simple_hidden_drawer_controller.dart';
import '../resources/reusable_methods.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'auth_screens/login.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final double coverHeight = 150;
  final double profileHeight = 144;
  late String name;
  late String surname;
  late String deptName;
  late String role;
  late String mail;

  Future<void> getUserInfo() async {
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
      name = user['name'];
      surname = user['surname'];
      deptName = user['deptName'];
      role = user['role'] == 'student' ? 'Student' : 'Instructor';
      mail = user['mail'];

      //print("$name - $surname - $deptName - $role - $mail");
    } else {
      // If the response is not successful
      print('Failed to get user info. Status code: ${response.statusCode}');
    }
  }

  void logout() async {
    await ReusableMethods.setLoggedInFalse();
    // ignore: use_build_context_synchronously
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => const LoginPage(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(
            CupertinoIcons.bars,
            color: ReusableMethods.colorLight,
          ),
          onPressed: () {
            SimpleHiddenDrawerController.of(context).open();
          },
        ),
        title: Text(
          "Profile",
          style: TextStyle(
            color: ReusableMethods.colorLight,
            fontWeight: FontWeight.bold,
          ),
        ),
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topRight,
              end: Alignment.bottomLeft,
              stops: const [
                0.1,
                0.4,
                0.9,
              ],
              colors: [
                ReusableMethods.colorProfile3,
                ReusableMethods.colorProfile2,
                ReusableMethods.colorProfile1,
              ],
            ),
          ),
        ),
      ),
      backgroundColor: ReusableMethods.colorLight,
      body: FutureBuilder(
        future: getUserInfo(),
        builder: (context, AsyncSnapshot<void> snapshot) {
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
              return ListView(
                padding: EdgeInsets.zero,
                children: [
                  buildTop(),
                  buildContent(),
                ],
              );
          }
        },
      ),
    );
  }

  Widget buildProfileImage() => Container(
        decoration: BoxDecoration(
          border: Border.all(width: 3.5, color: ReusableMethods.colorDark),
          borderRadius: BorderRadius.circular(30.0),
          gradient: LinearGradient(
            begin: Alignment.topRight,
            end: Alignment.bottomLeft,
            stops: const [
              0.1,
              0.4,
              0.9,
            ],
            colors: [
              ReusableMethods.colorProfile3,
              ReusableMethods.colorProfile2,
              ReusableMethods.colorProfile1,
            ],
          ),
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(30.0),
          child: Image.asset(
            role == "Student"
                ? 'assets/images/student.png'
                : 'assets/images/instructor.png',
            width: 512 / 4,
            height: 512 / 4,
            fit: BoxFit.fill,
          ),
        ),
      );

  Widget buildTop() {
    final top = coverHeight - profileHeight / 2;
    return Stack(
      clipBehavior: Clip.none,
      alignment: Alignment.center,
      children: [
        Container(
          height: coverHeight,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topRight,
              end: Alignment.bottomLeft,
              stops: const [
                0.1,
                0.4,
                0.9,
              ],
              colors: [
                ReusableMethods.colorProfile3,
                ReusableMethods.colorProfile2,
                ReusableMethods.colorProfile1,
              ],
            ),
            borderRadius: BorderRadius.vertical(
                bottom: Radius.elliptical(
                    MediaQuery.of(context).size.width, 120.0)),
          ),
        ),
        Positioned(
          top: top,
          child: buildProfileImage(),
        ),
      ],
    );
  }

  Widget buildContent() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(8.0, 50.0, 8.0, 0.0),
      child: Column(
        children: [
          const SizedBox(
            height: 36,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              const SizedBox(
                width: 16,
              ),
              ShaderMask(
                blendMode: BlendMode.srcIn,
                shaderCallback: (Rect bounds) => RadialGradient(
                  center: Alignment.topCenter,
                  stops: const [.9, 1],
                  colors: [
                    ReusableMethods.colorProfile1,
                    ReusableMethods.colorProfile2,
                  ],
                ).createShader(bounds),
                child: Icon(
                  CupertinoIcons.person_solid,
                  size: 36,
                  color: ReusableMethods.colorPeople,
                ),
              ),
              const SizedBox(
                width: 48,
              ),
              Text(
                "$name $surname",
                style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 17,
                    color: CupertinoColors.systemGrey),
              ),
            ],
          ),
          const SizedBox(
            height: 8.0,
          ),
          const Divider(
            color: Colors.grey, //color of divider
            height: 5, //height spacing of divider
            thickness: 2.0, //thickness of divider line
            indent: 0, //spacing at the start of divider
            endIndent: 0, //spacing at the end of divider
          ),
          const SizedBox(
            height: 24.0,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              const SizedBox(
                width: 16,
              ),
              ShaderMask(
                blendMode: BlendMode.srcIn,
                shaderCallback: (Rect bounds) => RadialGradient(
                  center: Alignment.topCenter,
                  stops: const [.9, 1],
                  colors: [
                    ReusableMethods.colorProfile1,
                    ReusableMethods.colorProfile2,
                  ],
                ).createShader(bounds),
                child: Icon(CupertinoIcons.briefcase_fill,
                    size: 36, color: ReusableMethods.colorPeople),
              ),
              const SizedBox(
                width: 48,
              ),
              Text(
                role,
                style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 17,
                    color: CupertinoColors.systemGrey),
              ),
            ],
          ),
          const SizedBox(
            height: 8.0,
          ),
          const Divider(
            color: Colors.grey, //color of divider
            height: 5, //height spacing of divider
            thickness: 2.0, //thickness of divider line
            indent: 0, //spacing at the start of divider
            endIndent: 0, //spacing at the end of divider
          ),
          const SizedBox(
            height: 24.0,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              const SizedBox(
                width: 16,
              ),
              ShaderMask(
                blendMode: BlendMode.srcIn,
                shaderCallback: (Rect bounds) => RadialGradient(
                  center: Alignment.topCenter,
                  stops: const [.9, 1],
                  colors: [
                    ReusableMethods.colorProfile1,
                    ReusableMethods.colorProfile2,
                  ],
                ).createShader(bounds),
                child: Icon(CupertinoIcons.mail_solid,
                    size: 36, color: ReusableMethods.colorPeople),
              ),
              const SizedBox(
                width: 48,
              ),
              Text(
                mail,
                style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 17,
                    color: CupertinoColors.systemGrey),
              ),
            ],
          ),
          const SizedBox(
            height: 8.0,
          ),
          const Divider(
            color: Colors.grey, //color of divider
            height: 5, //height spacing of divider
            thickness: 2.0, //thickness of divider line
            indent: 0, //spacing at the start of divider
            endIndent: 0, //spacing at the end of divider
          ),
          const SizedBox(
            height: 24.0,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              const SizedBox(
                width: 16,
              ),
              ShaderMask(
                blendMode: BlendMode.srcIn,
                shaderCallback: (Rect bounds) => RadialGradient(
                  center: Alignment.topCenter,
                  stops: const [.9, 1],
                  colors: [
                    ReusableMethods.colorProfile1,
                    ReusableMethods.colorProfile2,
                  ],
                ).createShader(bounds),
                child: Icon(Icons.school_rounded,
                    size: 36, color: ReusableMethods.colorPeople),
              ),
              const SizedBox(
                width: 48,
              ),
              Text(
                deptName,
                style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 17,
                    color: CupertinoColors.systemGrey),
              ),
            ],
          ),
          const SizedBox(
            height: 8.0,
          ),
          const Divider(
            color: Colors.grey, //color of divider
            height: 5, //height spacing of divider
            thickness: 2.0, //thickness of divider line
            indent: 0, //spacing at the start of divider
            endIndent: 0, //spacing at the end of divider
          ),
          const SizedBox(
            height: 36.0,
          ),
          ElevatedButton(
            onPressed: () {
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    actionsAlignment: MainAxisAlignment.center,
                    shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(20.0))),
                    backgroundColor: ReusableMethods.colorLight,
                    contentTextStyle:
                        TextStyle(color: ReusableMethods.colorDark),
                    title: Text(
                      'Warning',
                      style: TextStyle(
                          color: ReusableMethods.colorDark,
                          fontWeight: FontWeight.bold),
                    ),
                    content: const Text('Are you sure you want to logout?'),
                    actions: [
                      MaterialButton(
                        shape: const RoundedRectangleBorder(
                            borderRadius:
                                BorderRadius.all(Radius.circular(15.0))),
                        child: Text(
                          'Cancel',
                          style: TextStyle(
                              color: ReusableMethods.colorDark,
                              fontWeight: FontWeight.bold),
                        ),
                        onPressed: () => Navigator.of(context).pop(false),
                      ),
                      MaterialButton(
                        shape: const RoundedRectangleBorder(
                            borderRadius:
                                BorderRadius.all(Radius.circular(15.0))),
                        color: ReusableMethods.colorProfile2,
                        child: Text(
                          'Logout',
                          style: TextStyle(
                              color: ReusableMethods.colorLight,
                              fontWeight: FontWeight.bold),
                        ),
                        onPressed: () => Navigator.of(context).pop(true),
                      ),
                    ],
                  );
                },
              ).then((value) {
                if (value) {
                  // Perform the delete action here
                  logout();
                  Navigator.pop(context);
                }
              });
            },
            style: ButtonStyle(
              shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20.0),
                ),
              ),
              backgroundColor:
                  MaterialStateProperty.all<Color>(Colors.transparent),
              // Set overlayColor to Colors.transparent to remove the purple shadow
              overlayColor:
                  MaterialStateProperty.all<Color>(Colors.transparent),
              elevation: MaterialStateProperty.all<double>(0),
            ),
            child: Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    ReusableMethods.colorProfile1,
                    ReusableMethods.colorProfile2,
                    ReusableMethods.colorProfile3,
                  ],
                  begin: Alignment.centerLeft,
                  end: Alignment.centerRight,
                ),
                borderRadius: BorderRadius.circular(20.0),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [
                  Text(
                    'Logout',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                    ),
                  ),
                  SizedBox(
                    width: 10.0,
                  ),
                  Icon(
                    CupertinoIcons.square_arrow_right,
                    color: Colors.white,
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(
            height: 20,
          )
        ],
      ),
    );
  }
}
