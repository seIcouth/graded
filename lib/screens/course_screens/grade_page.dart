// ignore_for_file: avoid_print
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:graded/resources/reusable_methods.dart';
import 'package:graded/resources/reusable_widgets.dart';
import 'package:http/http.dart' as http;
import 'package:loading_animation_widget/loading_animation_widget.dart';

class GradePage extends StatefulWidget {
  const GradePage(
      {Key? key,
      required this.courseID,
      required this.sectionID,
      required this.semester,
      required this.year})
      : super(key: key);

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

  late double classAverage;
  late String studentGrade;

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

  Future<String> getStudentGrade() async {
    final students = await getStudents();
    int? id = await ReusableMethods.getUserId();
    studentGrade = 'a';
    for (final student in students) {
      if (student['id'] == id.toString()) {
        studentGrade = student['grade'];
      }
    }
    return studentGrade;
  }

  Future<double> getClassAverageGrade() async {
    final students = await getStudents();
    double sum = 0;
    int count = 0;
    for (final student in students) {
      final grade = student['grade'];
      if (grade != 'NA') {
        switch (grade) {
          case 'A':
            sum += 4.0;
            break;
          case 'A-':
            sum += 3.7;
            break;
          case 'B+':
            sum += 3.3;
            break;
          case 'B':
            sum += 3.0;
            break;
          case 'B-':
            sum += 2.7;
            break;
          case 'C+':
            sum += 2.3;
            break;
          case 'C':
            sum += 2.0;
            break;
          case 'C-':
            sum += 1.7;
            break;
          case 'D+':
            sum += 1.3;
            break;
          case 'D':
            sum += 1.0;
            break;
          default:
            sum += 0.0;
            break;
        }
        count++;
      }
    }
    classAverage = count > 0 ? sum / count : 0.0;
    return classAverage;
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
        backgroundColor: ReusableWidgets.colorGrades,
        title: Text(
          "Grades",
          style: TextStyle(
            color: ReusableWidgets.colorLight,
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
                ReusableWidgets.colorGrade2,
                ReusableWidgets.colorGrade1,
              ],
            ),
          ),
        ),
      ),
      backgroundColor: ReusableWidgets.colorLight,
      extendBodyBehindAppBar: true,
      body: FutureBuilder(
        future: Future.wait([
          getRole(),
          getStudents(),
          getClassAverageGrade(),
          getStudentGrade()
        ]),
        builder: (context, AsyncSnapshot<void> snapshot) {
          if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}');
          }
          switch (snapshot.connectionState) {
            case ConnectionState.waiting:
              return Center(
                child: LoadingAnimationWidget.newtonCradle(
                    color: ReusableWidgets.colorGrades, size: 125),
              );
            default:
              return role == 'Instructor'
                  ? SafeArea(
                      child: SingleChildScrollView(
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Center(
                            child: students.isEmpty
                                ? Image.asset(
                                    'assets/images/no_students.png',
                                    width: double.infinity,
                                    fit: BoxFit.fill,
                                  )
                                : Column(
                                    children: [
                                      classAverageCard(),
                                      Card(
                                        shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(20)),
                                        color: ReusableWidgets.colorLight,
                                        elevation: 3.0,
                                        shadowColor:
                                            ReusableWidgets.colorGrade1,
                                        child: Container(
                                          width: double.infinity,
                                          margin: const EdgeInsets.all(8.0),
                                          child: Column(
                                            children: [
                                              Card(
                                                shape: RoundedRectangleBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            20)),
                                                color:
                                                    ReusableWidgets.colorLight,
                                                elevation: 2.0,
                                                shadowColor:
                                                    ReusableWidgets.colorGrade1,
                                                child: Container(
                                                  margin:
                                                      const EdgeInsets.all(5.0),
                                                  width: double.infinity,
                                                  child: Padding(
                                                    padding:
                                                        const EdgeInsets.all(
                                                            5.0),
                                                    child: Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .spaceEvenly,
                                                      children: [
                                                        Container(
                                                          decoration:
                                                              BoxDecoration(
                                                            border: Border.all(
                                                                width: 2.0,
                                                                color: ReusableWidgets
                                                                    .colorDark),
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        20.0),
                                                            gradient:
                                                                LinearGradient(
                                                              begin: Alignment
                                                                  .topRight,
                                                              end: Alignment
                                                                  .bottomLeft,
                                                              stops: const [
                                                                0.1,
                                                                0.9,
                                                              ],
                                                              colors: [
                                                                ReusableWidgets
                                                                    .colorGrade2,
                                                                ReusableWidgets
                                                                    .colorGrade1,
                                                              ],
                                                            ),
                                                          ),
                                                          child: ClipRRect(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        20.0),
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
                                                                  ReusableWidgets
                                                                      .colorDark,
                                                              fontSize: 20,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w900,
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
                                                    (BuildContext context,
                                                        int index) {
                                                  return Padding(
                                                    padding: const EdgeInsets
                                                        .symmetric(vertical: 3),
                                                    child: Card(
                                                      shape:
                                                          RoundedRectangleBorder(
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          20)),
                                                      color: ReusableWidgets
                                                          .colorLight,
                                                      elevation: 2.0,
                                                      shadowColor:
                                                          ReusableWidgets
                                                              .colorGrade1,
                                                      child: Container(
                                                        margin: const EdgeInsets
                                                            .all(8.0),
                                                        width: double.infinity,
                                                        child: Column(
                                                          crossAxisAlignment:
                                                              CrossAxisAlignment
                                                                  .start,
                                                          children: [
                                                            Row(
                                                              mainAxisAlignment:
                                                                  MainAxisAlignment
                                                                      .start,
                                                              children: [
                                                                const SizedBox(
                                                                  width: 16,
                                                                ),
                                                                ShaderMask(
                                                                  blendMode:
                                                                      BlendMode
                                                                          .srcIn,
                                                                  shaderCallback: (Rect
                                                                          bounds) =>
                                                                      RadialGradient(
                                                                    center: Alignment
                                                                        .topCenter,
                                                                    stops: const [
                                                                      .9,
                                                                      1
                                                                    ],
                                                                    colors: [
                                                                      ReusableWidgets
                                                                          .colorGrade1,
                                                                      ReusableWidgets
                                                                          .colorGrade2,
                                                                    ],
                                                                  ).createShader(
                                                                          bounds),
                                                                  child: Icon(
                                                                      CupertinoIcons
                                                                          .person_solid,
                                                                      size: 36,
                                                                      color: ReusableWidgets
                                                                          .colorGrades),
                                                                ),
                                                                const SizedBox(
                                                                  width: 48,
                                                                ),
                                                                Text(
                                                                  "${students[index]['name']} ${students[index]['surname']}",
                                                                  style: const TextStyle(
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .bold,
                                                                      fontSize:
                                                                          17,
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
                                                                  MainAxisAlignment
                                                                      .start,
                                                              children: [
                                                                const SizedBox(
                                                                  width: 16,
                                                                ),
                                                                ShaderMask(
                                                                  blendMode:
                                                                      BlendMode
                                                                          .srcIn,
                                                                  shaderCallback: (Rect
                                                                          bounds) =>
                                                                      RadialGradient(
                                                                    center: Alignment
                                                                        .topCenter,
                                                                    stops: const [
                                                                      .9,
                                                                      1
                                                                    ],
                                                                    colors: [
                                                                      ReusableWidgets
                                                                          .colorGrade1,
                                                                      ReusableWidgets
                                                                          .colorGrade2,
                                                                    ],
                                                                  ).createShader(
                                                                          bounds),
                                                                  child: Icon(
                                                                      CupertinoIcons
                                                                          .mail_solid,
                                                                      size: 36,
                                                                      color: ReusableWidgets
                                                                          .colorGrades),
                                                                ),
                                                                const SizedBox(
                                                                  width: 48,
                                                                ),
                                                                Text(
                                                                  students[
                                                                          index]
                                                                      ['mail'],
                                                                  style: const TextStyle(
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .bold,
                                                                      fontSize:
                                                                          17,
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
                                                                  MainAxisAlignment
                                                                      .start,
                                                              children: [
                                                                const SizedBox(
                                                                  width: 16,
                                                                ),
                                                                ShaderMask(
                                                                  blendMode:
                                                                      BlendMode
                                                                          .srcIn,
                                                                  shaderCallback: (Rect
                                                                          bounds) =>
                                                                      RadialGradient(
                                                                    center: Alignment
                                                                        .topCenter,
                                                                    stops: const [
                                                                      .9,
                                                                      1
                                                                    ],
                                                                    colors: [
                                                                      ReusableWidgets
                                                                          .colorGrade1,
                                                                      ReusableWidgets
                                                                          .colorGrade2,
                                                                    ],
                                                                  ).createShader(
                                                                          bounds),
                                                                  child: Icon(
                                                                      CupertinoIcons
                                                                          .chart_bar_alt_fill,
                                                                      size: 36,
                                                                      color: ReusableWidgets
                                                                          .colorGrades),
                                                                ),
                                                                const SizedBox(
                                                                  width: 48,
                                                                ),
                                                                SizedBox(
                                                                    width: 100,
                                                                    child: DropdownButtonFormField(
                                                                        dropdownColor: ReusableWidgets.colorLight,
                                                                        borderRadius: BorderRadius.circular(20),
                                                                        decoration: InputDecoration(border: OutlineInputBorder(borderRadius: BorderRadius.circular(20), borderSide: BorderSide(width: 1, color: ReusableWidgets.colorDark))),
                                                                        value: students[index]['grade'],
                                                                        items: grades
                                                                            .map((item) => DropdownMenuItem(
                                                                                value: item,
                                                                                child: Text(
                                                                                  item,
                                                                                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 17, color: CupertinoColors.systemGrey),
                                                                                )))
                                                                            .toList(),
                                                                        onChanged: (item) async {
                                                                          setState(
                                                                              () {
                                                                            updateTakes(students[index]['id'],
                                                                                item! as String);
                                                                          });
                                                                        })),
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
                                      classAverageInfoCard(),
                                    ],
                                  ),
                          ),
                        ),
                      ),
                    )
                  : SafeArea(
                      child: SingleChildScrollView(
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Center(
                            child: Column(
                              children: [
                                classAverageCard(),
                                Card(
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(20)),
                                  color: ReusableWidgets.colorLight,
                                  elevation: 3.0,
                                  shadowColor: ReusableWidgets.colorGrade1,
                                  child: Container(
                                    width: double.infinity,
                                    margin: const EdgeInsets.symmetric(
                                        horizontal: 8.0, vertical: 12.0),
                                    child: Column(
                                      children: [
                                        Card(
                                          shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(20)),
                                          color: ReusableWidgets.colorLight,
                                          elevation: 2.0,
                                          shadowColor:
                                              ReusableWidgets.colorGrade1,
                                          child: Container(
                                            margin: const EdgeInsets.all(5.0),
                                            width: double.infinity,
                                            child: Padding(
                                              padding:
                                                  const EdgeInsets.all(5.0),
                                              child: Center(
                                                child: Text(
                                                  "Your Grade",
                                                  style: TextStyle(
                                                    color: ReusableWidgets
                                                        .colorDark,
                                                    fontSize: 20,
                                                    fontWeight: FontWeight.w900,
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            Card(
                                              shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          20)),
                                              color: ReusableWidgets.colorLight,
                                              elevation: 2.0,
                                              shadowColor:
                                                  ReusableWidgets.colorGrade1,
                                              child: Container(
                                                margin:
                                                    const EdgeInsets.all(5.0),
                                                width: MediaQuery.of(context)
                                                        .size
                                                        .width -
                                                    58,
                                                child: Padding(
                                                  padding:
                                                      const EdgeInsets.all(5.0),
                                                  child: Column(
                                                    children: [
                                                      Row(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .spaceEvenly,
                                                        children: [
                                                          ShaderMask(
                                                            blendMode:
                                                                BlendMode.srcIn,
                                                            shaderCallback: (Rect
                                                                    bounds) =>
                                                                RadialGradient(
                                                              center: Alignment
                                                                  .topCenter,
                                                              stops: const [
                                                                .9,
                                                                1
                                                              ],
                                                              colors: [
                                                                ReusableWidgets
                                                                    .colorGrade1,
                                                                ReusableWidgets
                                                                    .colorGrade2,
                                                              ],
                                                            ).createShader(
                                                                    bounds),
                                                            child: Icon(
                                                                CupertinoIcons
                                                                    .chart_bar_alt_fill,
                                                                size: 36,
                                                                color: ReusableWidgets
                                                                    .colorGrades),
                                                          ),
                                                          const Spacer(),
                                                          Expanded(
                                                            child: Text(
                                                              studentGrade,
                                                              style: TextStyle(
                                                                  color: ReusableWidgets
                                                                      .colorDark,
                                                                  fontSize: 20,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold),
                                                            ),
                                                          ),
                                                          const Spacer(),
                                                        ],
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                classAverageInfoCard(),
                              ],
                            ),
                          ),
                        ),
                      ),
                    );
          }
        },
      ),
    );
  }

  Widget classAverageCard() {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      color: ReusableWidgets.colorLight,
      elevation: 3.0,
      shadowColor: ReusableWidgets.colorGrade1,
      child: Container(
        width: double.infinity,
        margin: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 12.0),
        child: Column(
          children: [
            Card(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20)),
              color: ReusableWidgets.colorLight,
              elevation: 2.0,
              shadowColor: ReusableWidgets.colorGrade1,
              child: Container(
                margin: const EdgeInsets.all(5.0),
                width: double.infinity,
                child: Padding(
                  padding: const EdgeInsets.all(5.0),
                  child: Center(
                    child: Text(
                      "Class Average",
                      style: TextStyle(
                        color: ReusableWidgets.colorDark,
                        fontSize: 20,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                  ),
                ),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              mainAxisSize: MainAxisSize.min,
              children: [
                Card(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20)),
                  color: ReusableWidgets.colorLight,
                  elevation: 2.0,
                  shadowColor: ReusableWidgets.colorGrade1,
                  child: Container(
                    margin: const EdgeInsets.all(5.0),
                    width: MediaQuery.of(context).size.width - 58,
                    child: Padding(
                      padding: const EdgeInsets.all(5.0),
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              ShaderMask(
                                blendMode: BlendMode.srcIn,
                                shaderCallback: (Rect bounds) => RadialGradient(
                                  center: Alignment.topCenter,
                                  stops: const [.9, 1],
                                  colors: [
                                    ReusableWidgets.colorGrade1,
                                    ReusableWidgets.colorGrade2,
                                  ],
                                ).createShader(bounds),
                                child: Icon(CupertinoIcons.chart_bar_alt_fill,
                                    size: 36,
                                    color: ReusableWidgets.colorGrades),
                              ),
                              const Spacer(),
                              Expanded(
                                child: Text(
                                  '$classAverage',
                                  style: TextStyle(
                                      color: ReusableWidgets.colorDark,
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                              const Spacer(),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget classAverageInfoCard() {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      color: ReusableWidgets.colorLight,
      elevation: 3.0,
      shadowColor: ReusableWidgets.colorGrade1,
      child: Container(
        width: double.infinity,
        margin: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 12.0),
        child: Container(
          width: double.infinity,
          margin: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              Card(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20)),
                color: ReusableWidgets.colorLight,
                elevation: 2.0,
                shadowColor: ReusableWidgets.colorGrade1,
                child: Container(
                  margin: const EdgeInsets.all(5.0),
                  width: double.infinity,
                  child: Padding(
                    padding: const EdgeInsets.all(5.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        ShaderMask(
                          blendMode: BlendMode.srcIn,
                          shaderCallback: (Rect bounds) => RadialGradient(
                            center: Alignment.topCenter,
                            stops: const [.9, 1],
                            colors: [
                              ReusableWidgets.colorGrade1,
                              ReusableWidgets.colorGrade2,
                            ],
                          ).createShader(bounds),
                          child: Icon(CupertinoIcons.info,
                              size: 36, color: ReusableWidgets.colorGrades),
                        ),
                        Text(
                          "Grading Table",
                          style: TextStyle(
                            color: ReusableWidgets.colorDark,
                            fontSize: 20,
                            fontWeight: FontWeight.w900,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Card(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20)),
                    color: ReusableWidgets.colorLight,
                    elevation: 2.0,
                    shadowColor: ReusableWidgets.colorGrade1,
                    child: Container(
                      margin: const EdgeInsets.all(5.0),
                      width: MediaQuery.of(context).size.width / 2 - 46,
                      child: Padding(
                        padding: const EdgeInsets.all(5.0),
                        child: Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                Text(
                                  'A',
                                  style: TextStyle(
                                    color: ReusableWidgets.colorDark,
                                    fontSize: 17,
                                  ),
                                ),
                                const Spacer(),
                                Text(
                                  '4.0',
                                  style: TextStyle(
                                      color: ReusableWidgets.colorDark,
                                      fontSize: 17,
                                      fontWeight: FontWeight.bold),
                                ),
                              ],
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                Text(
                                  'A-',
                                  style: TextStyle(
                                    color: ReusableWidgets.colorDark,
                                    fontSize: 17,
                                  ),
                                ),
                                const Spacer(),
                                Text(
                                  '3.7',
                                  style: TextStyle(
                                      color: ReusableWidgets.colorDark,
                                      fontSize: 17,
                                      fontWeight: FontWeight.bold),
                                ),
                              ],
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                Text(
                                  'B+',
                                  style: TextStyle(
                                    color: ReusableWidgets.colorDark,
                                    fontSize: 17,
                                  ),
                                ),
                                const Spacer(),
                                Text(
                                  '3.3',
                                  style: TextStyle(
                                      color: ReusableWidgets.colorDark,
                                      fontSize: 17,
                                      fontWeight: FontWeight.bold),
                                ),
                              ],
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                Text(
                                  'B',
                                  style: TextStyle(
                                    color: ReusableWidgets.colorDark,
                                    fontSize: 17,
                                  ),
                                ),
                                const Spacer(),
                                Text(
                                  '3.0',
                                  style: TextStyle(
                                      color: ReusableWidgets.colorDark,
                                      fontSize: 17,
                                      fontWeight: FontWeight.bold),
                                ),
                              ],
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                Text(
                                  'B-',
                                  style: TextStyle(
                                    color: ReusableWidgets.colorDark,
                                    fontSize: 17,
                                  ),
                                ),
                                const Spacer(),
                                Text(
                                  '2.7',
                                  style: TextStyle(
                                      color: ReusableWidgets.colorDark,
                                      fontSize: 17,
                                      fontWeight: FontWeight.bold),
                                ),
                              ],
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                Text(
                                  'C+',
                                  style: TextStyle(
                                    color: ReusableWidgets.colorDark,
                                    fontSize: 17,
                                  ),
                                ),
                                const Spacer(),
                                Text(
                                  '2.3',
                                  style: TextStyle(
                                      color: ReusableWidgets.colorDark,
                                      fontSize: 17,
                                      fontWeight: FontWeight.bold),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  Card(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20)),
                    color: ReusableWidgets.colorLight,
                    elevation: 2.0,
                    shadowColor: ReusableWidgets.colorGrade1,
                    child: Container(
                      margin: const EdgeInsets.all(5.0),
                      width: MediaQuery.of(context).size.width / 2 - 46,
                      child: Padding(
                        padding: const EdgeInsets.all(5.0),
                        child: Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                Text(
                                  'C',
                                  style: TextStyle(
                                    color: ReusableWidgets.colorDark,
                                    fontSize: 17,
                                  ),
                                ),
                                const Spacer(),
                                Text(
                                  '2.0',
                                  style: TextStyle(
                                      color: ReusableWidgets.colorDark,
                                      fontSize: 17,
                                      fontWeight: FontWeight.bold),
                                ),
                              ],
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                Text(
                                  'C-',
                                  style: TextStyle(
                                    color: ReusableWidgets.colorDark,
                                    fontSize: 17,
                                  ),
                                ),
                                const Spacer(),
                                Text(
                                  '1.7',
                                  style: TextStyle(
                                      color: ReusableWidgets.colorDark,
                                      fontSize: 17,
                                      fontWeight: FontWeight.bold),
                                ),
                              ],
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                Text(
                                  'D+',
                                  style: TextStyle(
                                    color: ReusableWidgets.colorDark,
                                    fontSize: 17,
                                  ),
                                ),
                                const Spacer(),
                                Text(
                                  '1.3',
                                  style: TextStyle(
                                      color: ReusableWidgets.colorDark,
                                      fontSize: 17,
                                      fontWeight: FontWeight.bold),
                                ),
                              ],
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                Text(
                                  'D',
                                  style: TextStyle(
                                    color: ReusableWidgets.colorDark,
                                    fontSize: 17,
                                  ),
                                ),
                                const Spacer(),
                                Text(
                                  '1.0',
                                  style: TextStyle(
                                      color: ReusableWidgets.colorDark,
                                      fontSize: 17,
                                      fontWeight: FontWeight.bold),
                                ),
                              ],
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                Text(
                                  'F',
                                  style: TextStyle(
                                    color: ReusableWidgets.colorDark,
                                    fontSize: 17,
                                  ),
                                ),
                                const Spacer(),
                                Text(
                                  '0.0',
                                  style: TextStyle(
                                      color: ReusableWidgets.colorDark,
                                      fontSize: 17,
                                      fontWeight: FontWeight.bold),
                                ),
                              ],
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                Text(
                                  'NA',
                                  style: TextStyle(
                                    color: ReusableWidgets.colorDark,
                                    fontSize: 17,
                                  ),
                                ),
                                const Spacer(),
                                Text(
                                  '0.0',
                                  style: TextStyle(
                                      color: ReusableWidgets.colorDark,
                                      fontSize: 17,
                                      fontWeight: FontWeight.bold),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
