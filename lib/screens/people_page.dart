import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../resources/reusable_methods.dart';
import 'package:http/http.dart' as http;

class PeoplePage extends StatefulWidget {
  const PeoplePage(
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
  State<PeoplePage> createState() => _PeoplePageState();
}

class _PeoplePageState extends State<PeoplePage> {
  // variables
  late List<dynamic> people;
  dynamic instructor;
  List<dynamic> students = [];

  // accessor methods
  Future<List<dynamic>> getPeople() async {
    String parCourseID = widget.courseID;
    String parSectionID = widget.sectionID;
    String parSemester = widget.semester;
    String parYear = widget.year;
    final url =
        'http://10.0.2.2/graded/getpeople.php?courseID=$parCourseID&sectionID=$parSectionID&semester=$parSemester&year=$parYear';
    final response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      people = json.decode(response.body);
      for (var person in people) {
        if (person['type'] == 'instructor') {
          // Assign the instructor to the instructor variable
          instructor = person;
        } else {
          // Add the person to the students list
          students.add(person);
        }
      }
      return people;
    } else {
      throw Exception('Failed to load people');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: ReusableMethods.colorPeople,
        title: Text(
          "People",
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
                ReusableMethods.colorPeople2,
                ReusableMethods.colorPeople1,
              ],
            ),
          ),
        ),
      ),
      backgroundColor: ReusableMethods.colorLight,
      extendBodyBehindAppBar: true,
      body: FutureBuilder(
        future: getPeople(),
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
              return SafeArea(
                child: SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Center(
                      child: Column(
                        children: [
                          Card(
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20)),
                            color: ReusableMethods.colorLight,
                            elevation: 3.0,
                            shadowColor: ReusableMethods.colorPeople1,
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
                                    shadowColor: ReusableMethods.colorPeople1,
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
                                                        .colorPeople2,
                                                    ReusableMethods
                                                        .colorPeople1,
                                                  ],
                                                ),
                                              ),
                                              child: ClipRRect(
                                                borderRadius:
                                                    BorderRadius.circular(20.0),
                                                child: Image.asset(
                                                  'assets/images/instructor.png',
                                                  width: 512 / 8,
                                                  height: 512 / 8,
                                                  fit: BoxFit.fill,
                                                ),
                                              ),
                                            ),
                                            const Spacer(),
                                            Expanded(
                                              child: Text(
                                                "Instructor",
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
                                  Padding(
                                    padding:
                                        const EdgeInsets.symmetric(vertical: 3),
                                    child: Card(
                                      shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(20)),
                                      color: ReusableMethods.colorLight,
                                      elevation: 2.0,
                                      shadowColor: ReusableMethods.colorPeople1,
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
                                                  blendMode: BlendMode.srcIn,
                                                  shaderCallback:
                                                      (Rect bounds) =>
                                                          RadialGradient(
                                                    center: Alignment.topCenter,
                                                    stops: const [.9, 1],
                                                    colors: [
                                                      ReusableMethods
                                                          .colorPeople1,
                                                      ReusableMethods
                                                          .colorPeople2,
                                                    ],
                                                  ).createShader(bounds),
                                                  child: Icon(
                                                      CupertinoIcons
                                                          .person_solid,
                                                      size: 36,
                                                      color: ReusableMethods
                                                          .colorPeople),
                                                ),
                                                const SizedBox(
                                                  width: 48,
                                                ),
                                                Text(
                                                  "${instructor['name']} ${instructor['surname']}",
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
                                                  blendMode: BlendMode.srcIn,
                                                  shaderCallback:
                                                      (Rect bounds) =>
                                                          RadialGradient(
                                                    center: Alignment.topCenter,
                                                    stops: const [.9, 1],
                                                    colors: [
                                                      ReusableMethods
                                                          .colorPeople1,
                                                      ReusableMethods
                                                          .colorPeople2,
                                                    ],
                                                  ).createShader(bounds),
                                                  child: Icon(
                                                      CupertinoIcons.mail_solid,
                                                      size: 36,
                                                      color: ReusableMethods
                                                          .colorPeople),
                                                ),
                                                const SizedBox(
                                                  width: 48,
                                                ),
                                                Text(
                                                  instructor['mail'],
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
                                                  blendMode: BlendMode.srcIn,
                                                  shaderCallback:
                                                      (Rect bounds) =>
                                                          RadialGradient(
                                                    center: Alignment.topCenter,
                                                    stops: const [.9, 1],
                                                    colors: [
                                                      ReusableMethods
                                                          .colorPeople1,
                                                      ReusableMethods
                                                          .colorPeople2,
                                                    ],
                                                  ).createShader(bounds),
                                                  child: Icon(
                                                      Icons.school_rounded,
                                                      size: 36,
                                                      color: ReusableMethods
                                                          .colorPeople),
                                                ),
                                                const SizedBox(
                                                  width: 48,
                                                ),
                                                Text(
                                                  instructor['deptName'],
                                                  style: const TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      fontSize: 17,
                                                      color: CupertinoColors
                                                          .systemGrey),
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
                            ),
                          ),
                          Card(
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20)),
                            color: ReusableMethods.colorLight,
                            elevation: 3.0,
                            shadowColor: ReusableMethods.colorPeople1,
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
                                    shadowColor: ReusableMethods.colorPeople1,
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
                                                        .colorPeople2,
                                                    ReusableMethods
                                                        .colorPeople1,
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
                                              ReusableMethods.colorPeople1,
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
                                                              .colorPeople1,
                                                          ReusableMethods
                                                              .colorPeople2,
                                                        ],
                                                      ).createShader(bounds),
                                                      child: Icon(
                                                          CupertinoIcons
                                                              .person_solid,
                                                          size: 36,
                                                          color: ReusableMethods
                                                              .colorPeople),
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
                                                              .colorPeople1,
                                                          ReusableMethods
                                                              .colorPeople2,
                                                        ],
                                                      ).createShader(bounds),
                                                      child: Icon(
                                                          CupertinoIcons
                                                              .mail_solid,
                                                          size: 36,
                                                          color: ReusableMethods
                                                              .colorPeople),
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
                                                              .colorPeople1,
                                                          ReusableMethods
                                                              .colorPeople2,
                                                        ],
                                                      ).createShader(bounds),
                                                      child: Icon(
                                                          Icons.school_rounded,
                                                          size: 36,
                                                          color: ReusableMethods
                                                              .colorPeople),
                                                    ),
                                                    const SizedBox(
                                                      width: 48,
                                                    ),
                                                    Text(
                                                      students[index]
                                                          ['deptName'],
                                                      style: const TextStyle(
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          fontSize: 17,
                                                          color: CupertinoColors
                                                              .systemGrey),
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
}
