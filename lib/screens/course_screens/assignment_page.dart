import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:graded/resources/reusable_widgets.dart';
import 'package:http/http.dart' as http;

class AssignmentPage extends StatefulWidget {
  const AssignmentPage(
      {Key? key,
      required this.courseID,
      required this.courseSectionID,
      required this.courseSemester,
      required this.courseYear,
      required this.courseName})
      : super(key: key);

  final String courseID;
  final String courseName;
  final String courseSectionID;
  final String courseSemester;
  final String courseYear;

  @override
  State<AssignmentPage> createState() => _AssignmentPageState();
}

class _AssignmentPageState extends State<AssignmentPage> {
  // variables
  late List<dynamic> courseAssignments;

  // accessor methods
  Future<List<dynamic>> getAssignments() async {
    String parCourseID = widget.courseID;
    String parSectionID = widget.courseSectionID;
    String parSemester = widget.courseSemester;
    String parYear = widget.courseYear;
    final url =
        'http://10.0.2.2/graded/getassignments.php?courseID=$parCourseID&sectionID=$parSectionID&semester=$parSemester&year=$parYear';
    final response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      courseAssignments = json.decode(response.body);
      courseAssignments = courseAssignments.reversed.toList();

      return courseAssignments;
    } else {
      throw Exception('Failed to load assignments');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: ReusableWidgets.colorPeople,
        title: Text(
          "Assignments",
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
                ReusableWidgets.colorAssignment2,
                ReusableWidgets.colorAssignment1,
              ],
            ),
          ),
        ),
      ),
      backgroundColor: ReusableWidgets.colorLight,
      extendBodyBehindAppBar: true,
      body: FutureBuilder(
        future: getAssignments(),
        builder: (context, AsyncSnapshot<void> snapshot) {
          if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}');
          }
          switch (snapshot.connectionState) {
            case ConnectionState.waiting:
              return Center(
                child: LoadingAnimationWidget.newtonCradle(
                    color: ReusableWidgets.colorAssignment, size: 125),
              );
            default:
              return SafeArea(
                child: SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Center(
                      child: Card(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20)),
                        color: ReusableWidgets.colorLight,
                        elevation: 3.0,
                        shadowColor: ReusableWidgets.colorAssignment1,
                        child: Container(
                          width: double.infinity,
                          margin: const EdgeInsets.all(8.0),
                          child: courseAssignments.isEmpty
                              ? noAssignment()
                              : ListView.builder(
                                  itemCount: courseAssignments.length,
                                  shrinkWrap: true,
                                  padding: const EdgeInsets.all(4.0),
                                  physics: const NeverScrollableScrollPhysics(),
                                  itemBuilder:
                                      (BuildContext context, int index) {
                                    return Padding(
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 4.0),
                                      child: ReusableWidgets.assignmentPageCard(
                                          context,
                                          courseAssignments[index]['title'],
                                          courseAssignments[index]['content'],
                                          widget.courseID,
                                          widget.courseName,
                                          courseAssignments[index]
                                              ['publishDate'],
                                          courseAssignments[index]['dueDate']),
                                    );
                                  },
                                ),
                        ),
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

  Widget noAssignment() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        children: [
          Icon(
            Icons.assignment_outlined,
            color: ReusableWidgets.colorAssignment,
            size: 70,
          ),
          Text(
            'There is no assignment published yet.',
            style: TextStyle(
              color: ReusableWidgets.colorAssignment,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
          )
        ],
      ),
    );
  }
}
