import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
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
  final double coverHeight = 240;
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
      role = user['role'] == 'student' ? 'Student':'Instructor';
      mail = user['mail'];

      //print("$name - $surname - $deptName - $role - $mail");
    } else {
      // If the response is not successful
      print('Failed to get user info. Status code: ${response.statusCode}');
    }
  }

  void logout() async{
    await ReusableMethods.setLoggedInFalse();
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => const LoginPage(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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

  Widget buildCoverImage() => Container(
        color: ReusableMethods.colorLight,
        child: Image.asset(
          'assets/images/university_cartoon.jpg',
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
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: Column(
        children: [
          const SizedBox(height: 36,),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              const SizedBox(width: 16,),
              Icon(
                  Icons.account_circle_rounded,
                  size: 36,
                  color: ReusableMethods.colorPeople,
              ),
              const SizedBox(width: 48,),
              Text(
                "$name $surname",
                style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 17,
                    color: CupertinoColors.systemGrey
                ),
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
              const SizedBox(width: 16,),
              Icon(
                  Icons.school_rounded,
                  size: 36,
                  color: ReusableMethods.colorPeople
              ),
              const SizedBox(width: 48,),
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
              const SizedBox(width: 16,),
              Icon(
                  Icons.mail_rounded,
                  size: 36,
                  color: ReusableMethods.colorPeople
              ),
              const SizedBox(width: 48,),
              Text(
                mail,
                style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 17,
                    color: CupertinoColors.systemGrey
                ),
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
              const SizedBox(width: 16,),
              Icon(
                  Icons.school_rounded,
                  size: 36,
                  color: ReusableMethods.colorPeople
              ),
              const SizedBox(width: 48,),
              Text(
                deptName,
                style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 17,
                    color: CupertinoColors.systemGrey
                ),
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
            onPressed: (){
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    title: const Text('Warning'),
                    content: const Text('Are you sure you want to logout?'),
                    actions: [
                      MaterialButton(
                        child: const Text('No'),
                        onPressed: () => Navigator.of(context).pop(false),
                      ),
                      MaterialButton(
                        child: const Text('Yes'),
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
              backgroundColor: MaterialStateProperty.all<Color>(Colors.transparent),
              // Set overlayColor to Colors.transparent to remove the purple shadow
              overlayColor: MaterialStateProperty.all<Color>(Colors.transparent),
              elevation: MaterialStateProperty.all<double>(0),
            ),
            child: Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Colors.deepPurple[800]!,
                    Colors.deepPurple[500]!,
                    Colors.deepPurple[300]!,
                  ],
                  begin: Alignment.centerLeft,
                  end: Alignment.centerRight,
                ),
                borderRadius: BorderRadius.circular(20.0),
              ),
              child: const Center(
                child: Text(
                  'Logout',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(height: 30,)
        ],
      ),
    );
  }
}
