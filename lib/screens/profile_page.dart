import 'package:flutter/material.dart';
import '../resources/reusable_methods.dart';
import 'auth_screens/login.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

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
      role = user['role'];
      mail = user['mail'];

      //print("$name - $surname - $deptName - $role - $mail");
    } else {
      // If the response is not successful
      print('Failed to get user info. Status code: ${response.statusCode}');
    }
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
            role == "student"
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
      padding: const EdgeInsets.all(0.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Align(
            alignment: Alignment.center,
            child: Text(
              "$name $surname",
              style: TextStyle(
                fontSize: 24,
                color: ReusableMethods.colorDark,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Align(
            alignment: Alignment.center,
            child: Text(
              role,
              style: const TextStyle(
                fontSize: 18,
                color: Colors.grey,
              ),
            ),
          ),
          const SizedBox(
            height: 10.0,
          ),
          Divider(
            color: ReusableMethods.colorDark, //color of divider
            height: 5, //height spacing of divider
            thickness: 2.0, //thickness of divider line
            indent: 50, //spacing at the start of divider
            endIndent: 50, //spacing at the end of divider
          ),
          const SizedBox(
            height: 10.0,
          ),
          Container(
            child: Column(
              children: [
                ListTile(
                  leading: Icon(Icons.mail_rounded,
                      color: ReusableMethods.colorDark),
                  shape: RoundedRectangleBorder(
                    side:
                        BorderSide(width: 1, color: ReusableMethods.colorDark),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  title: Text(
                    mail,
                    style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 17,
                        color: Colors.grey),
                  ),
                ),
                ListTile(
                  leading: Icon(Icons.mail_rounded,
                      color: ReusableMethods.colorDark),
                  shape: RoundedRectangleBorder(
                    side:
                        BorderSide(width: 1, color: ReusableMethods.colorDark),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  title: Text(
                    deptName,
                    style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 17,
                        color: Colors.grey),
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
