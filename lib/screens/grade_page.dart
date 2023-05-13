// ignore_for_file: avoid_print
import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../resources/reusable_methods.dart';
import 'package:http/http.dart' as http;

class GradePage extends StatefulWidget {
  const GradePage({Key? key, required this.courseID, required this.sectionID, required this.semester, required this.year}) : super(key: key);

  // parameters
  final String courseID;
  final String sectionID;
  final String semester;
  final String year;

  @override
  State<GradePage> createState() => _GradePageState();
}

class _GradePageState extends State<GradePage> {
  // variables
  late String role;

  late List<dynamic> people;
  List<dynamic> students = [];

  // dropdown menu list
  List<String> grades = [
    "NA",
    "A",
    "A-",
    "B+",
    "B",
    "B-",
    "C+",
    "C",
    "C-",
    "D+",
    "D",
    "F"
  ];

  // accessor methods
  Future<List<dynamic>> getStudents() async {
    String parCourseID = widget.courseID;
    String parSectionID = widget.sectionID;
    String parSemester = widget.semester;
    String parYear = widget.year;
    final url =
        'http://10.0.2.2/graded/getpeople.php?courseID=$parCourseID&sectionID=$parSectionID&semester=$parSemester&year=$parYear';
    final response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      people = json.decode(response.body);
      students = people.sublist(1);
      return students;
    } else {
      throw Exception('Failed to load students');
    }
  }

  Future<String> getRole() async {
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
    } else {
      // If the response is not successful
      return '-1';
    }
  }

  // manipulation methods
  Future<void> updateTakes(String parStudentID, String grade) async {
    String parCourseID = widget.courseID;
    String parSectionID = widget.sectionID;
    String parSemester = widget.semester;
    String parYear = widget.year;
    try {
      // Prepare the request body as a Map
      final requestBody = {
        'studentID': parStudentID,
        'courseID': parCourseID,
        'sectionID': parSectionID,
        'semester': parSemester,
        'year': parYear,
        'grade': grade
      };

      // Send a POST request to the related file on server
      final response = await http.post(
        Uri.parse('http://10.0.2.2/graded/updatetakes.php'),
        body: requestBody,
      );

      if (response.statusCode == 200) {
        // Course created successfully
        print('Grade changed successfully');
      } else {
        // Handle any errors from the server
        print('Failed to change grade: ${response.body}');
      }
    } catch (e) {
      // Handle any errors locally
      print('Failed to change grade: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: ReusableMethods.colorGrades,
        title: Text(
          "Grades",
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
                0.9,
              ],
              colors: [
                ReusableMethods.colorGrade2,
                ReusableMethods.colorGrade1,
              ],
            ),
          ),
        ),
      ),
      backgroundColor: ReusableMethods.colorLight,
      extendBodyBehindAppBar: true,
      body: FutureBuilder(
        future: Future.wait([getRole(), getStudents()]),
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
              return role == 'Instructor' ? SafeArea(
                child: SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Center(
                      child: students.isEmpty
                          ?
                      Image.asset(
                        'assets/images/no_students.png',
                        width: double.infinity,
                        fit: BoxFit.fill,
                      ) :Card(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20)),
                        color: ReusableMethods.colorLight,
                        elevation: 3.0,
                        shadowColor: ReusableMethods.colorGrade1,
                        child: Container(
                          width: double.infinity,
                          margin: const EdgeInsets.all(8.0),
                          child: Column(
                            children: [
                              Card(
                                shape: RoundedRectangleBorder(
                                    borderRadius:
                                    BorderRadius.circular(20)),
                                color: ReusableMethods.colorLight,
                                elevation: 2.0,
                                shadowColor: ReusableMethods.colorGrade1,
                                child: Container(
                                  margin: const EdgeInsets.all(5.0),
                                  width: double.infinity,
                                  child: Padding(
                                    padding: const EdgeInsets.all(5.0),
                                    child: Row(
                                      mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                      children: [
                                        Container(
                                          decoration: BoxDecoration(
                                            border: Border.all(
                                                width: 2.0,
                                                color: ReusableMethods
                                                    .colorDark),
                                            borderRadius:
                                            BorderRadius.circular(20.0),
                                            gradient: LinearGradient(
                                              begin: Alignment.topRight,
                                              end: Alignment.bottomLeft,
                                              stops: const [
                                                0.1,
                                                0.9,
                                              ],
                                              colors: [
                                                ReusableMethods
                                                    .colorGrade2,
                                                ReusableMethods
                                                    .colorGrade1,
                                              ],
                                            ),
                                          ),
                                          child: ClipRRect(
                                            borderRadius:
                                            BorderRadius.circular(20.0),
                                            child: Image.asset(
                                              'assets/images/student.png',
                                              width: 512 / 8,
                                              height: 512 / 8,
                                              fit: BoxFit.fill,
                                            ),
                                          ),
                                        ),
                                        const Spacer(),
                                        Expanded(
                                          child: Text(
                                            "Students",
                                            style: TextStyle(
                                              color:
                                              ReusableMethods.colorDark,
                                              fontSize: 20,
                                              fontWeight: FontWeight.w900,
                                            ),
                                          ),
                                        ),
                                        const Spacer(),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                              ListView.builder(
                                shrinkWrap: true,
                                physics:
                                const NeverScrollableScrollPhysics(),
                                itemCount: students.length,
                                itemBuilder:
                                    (BuildContext context, int index) {
                                  return Padding(
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 3),
                                    child: Card(
                                      shape: RoundedRectangleBorder(
                                          borderRadius:
                                          BorderRadius.circular(20)),
                                      color: ReusableMethods.colorLight,
                                      elevation: 2.0,
                                      shadowColor:
                                      ReusableMethods.colorGrade1,
                                      child: Container(
                                        margin: const EdgeInsets.all(8.0),
                                        width: double.infinity,
                                        child: Column(
                                          crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                          children: [
                                            Row(
                                              mainAxisAlignment:
                                              MainAxisAlignment.start,
                                              children: [
                                                const SizedBox(
                                                  width: 16,
                                                ),
                                                ShaderMask(
                                                  blendMode:
                                                  BlendMode.srcIn,
                                                  shaderCallback:
                                                      (Rect bounds) =>
                                                      RadialGradient(
                                                        center:
                                                        Alignment.topCenter,
                                                        stops: const [.9, 1],
                                                        colors: [
                                                          ReusableMethods
                                                              .colorGrade1,
                                                          ReusableMethods
                                                              .colorGrade2,
                                                        ],
                                                      ).createShader(bounds),
                                                  child: Icon(
                                                      CupertinoIcons
                                                          .person_solid,
                                                      size: 36,
                                                      color: ReusableMethods
                                                          .colorGrades),
                                                ),
                                                const SizedBox(
                                                  width: 48,
                                                ),
                                                Text(
                                                  "${students[index]['name']} ${students[index]['surname']}",
                                                  style: const TextStyle(
                                                      fontWeight:
                                                      FontWeight.bold,
                                                      fontSize: 17,
                                                      color: CupertinoColors
                                                          .systemGrey),
                                                ),
                                              ],
                                            ),
                                            const SizedBox(
                                              height: 8.0,
                                            ),
                                            Row(
                                              mainAxisAlignment:
                                              MainAxisAlignment.start,
                                              children: [
                                                const SizedBox(
                                                  width: 16,
                                                ),
                                                ShaderMask(
                                                  blendMode:
                                                  BlendMode.srcIn,
                                                  shaderCallback:
                                                      (Rect bounds) =>
                                                      RadialGradient(
                                                        center:
                                                        Alignment.topCenter,
                                                        stops: const [.9, 1],
                                                        colors: [
                                                          ReusableMethods
                                                              .colorGrade1,
                                                          ReusableMethods
                                                              .colorGrade2,
                                                        ],
                                                      ).createShader(bounds),
                                                  child: Icon(
                                                      CupertinoIcons
                                                          .mail_solid,
                                                      size: 36,
                                                      color: ReusableMethods
                                                          .colorGrades),
                                                ),
                                                const SizedBox(
                                                  width: 48,
                                                ),
                                                Text(
                                                  students[index]['mail'],
                                                  style: const TextStyle(
                                                      fontWeight:
                                                      FontWeight.bold,
                                                      fontSize: 17,
                                                      color: CupertinoColors
                                                          .systemGrey),
                                                ),
                                              ],
                                            ),
                                            const SizedBox(
                                              height: 8.0,
                                            ),
                                            Row(
                                              mainAxisAlignment:
                                              MainAxisAlignment.start,
                                              children: [
                                                const SizedBox(
                                                  width: 16,
                                                ),
                                                ShaderMask(
                                                  blendMode:
                                                  BlendMode.srcIn,
                                                  shaderCallback:
                                                      (Rect bounds) =>
                                                      RadialGradient(
                                                        center:
                                                        Alignment.topCenter,
                                                        stops: const [.9, 1],
                                                        colors: [
                                                          ReusableMethods
                                                              .colorGrade1,
                                                          ReusableMethods
                                                              .colorGrade2,
                                                        ],
                                                      ).createShader(bounds),
                                                  child: Icon(
                                                      CupertinoIcons.chart_bar_alt_fill,
                                                      size: 36,
                                                      color: ReusableMethods
                                                          .colorGrades),
                                                ),
                                                const SizedBox(
                                                  width: 48,
                                                ),
                                                SizedBox(
                                                  width: 100,
                                                    child: DropdownButtonFormField(
                                                        dropdownColor: ReusableMethods.colorLight,
                                                        borderRadius: BorderRadius.circular(20),
                                                        decoration: InputDecoration(
                                                            border: OutlineInputBorder(
                                                                borderRadius: BorderRadius.circular(20),
                                                                borderSide: BorderSide(width: 1, color: ReusableMethods.colorDark)
                                                            )
                                                        ),
                                                        value: students[index]['grade'],
                                                        items: grades.map((item) => DropdownMenuItem(
                                                            value: item,
                                                            child: Text(
                                                              item,
                                                              style: const TextStyle(
                                                                  fontWeight:
                                                                  FontWeight.bold,
                                                                  fontSize: 17,
                                                                  color: CupertinoColors.systemGrey
                                                              ),
                                                            )
                                                        )).toList(),
                                                        onChanged: (item) async {
                                                          setState(() {
                                                            updateTakes(students[index]['id'], item! as String);
                                                          });
                                                        }
                                                    )
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  );
                                },
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              )
                :
              Container()
              ;
          }
        },
      ),
    );
  }
}