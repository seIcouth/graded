// ignore_for_file: use_build_context_synchronously
import 'dart:convert';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:graded/screens/course_screens/announcement_page.dart';
import 'package:graded/screens/course_screens/assignment_page.dart';
import 'package:graded/screens/course_screens/people_page.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:graded/resources/reusable_widgets.dart';
import 'package:http/http.dart' as http;
import 'grade_page.dart';

class CoursePage extends StatefulWidget {
  const CoursePage({
    Key? key,
    required this.courseID,
    required this.courseName,
    required this.courseDeptName,
    required this.courseCredit,
    required this.courseSectionID,
    required this.courseSemester,
    required this.courseYear,
    required this.instructorName,
    required this.instructorSurname,
  }) : super(key: key);

  // parameters
  final String courseID;
  final String courseName;
  final String courseDeptName;
  final String courseCredit;
  final String courseSectionID;
  final String courseSemester;
  final String courseYear;
  final String instructorName;
  final String instructorSurname;

  @override
  State<CoursePage> createState() => _CoursePageState();
}

class _CoursePageState extends State<CoursePage> {
  late List<dynamic> courseAnnouncements;
  late List<dynamic> courseAssignments;
  // dummy list (will change)
  List<Widget> courseNotificationsToDisplay = [];
  List<dynamic> courseNotifications = [];

  // accessor methods
  Future<void> formNotifications() async {
    courseNotifications = [];
    courseNotificationsToDisplay = [];

    List<dynamic> announcements = await getAnnouncements();
    List<dynamic> assignments = await getAssignments();

    // merge the announcements and assignments into one list
    courseNotifications.addAll(announcements);
    courseNotifications.addAll(assignments);

    // sort the notifications based on the publish date
    courseNotifications
        .sort((a, b) => b['publishDate'].compareTo(a['publishDate']));

    // get the recent 10 notifications
    List<dynamic> recentNotifications = courseNotifications.take(10).toList();

    for (int i = 0; i < recentNotifications.length; i++) {
      Map<String, dynamic> notification = recentNotifications[i];

      if (notification.containsKey('dueDate')) {
        // this is an assignment
        courseNotificationsToDisplay.add(
          ReusableWidgets.assignmentNotificationCard(
            context,
            notification['title'],
            notification['content'],
            notification['courseID'],
            notification['dueDate'],
            notification['publishDate'],
          ),
        );
      } else {
        // this is an announcement
        courseNotificationsToDisplay.add(
          ReusableWidgets.announcementNotificationCard(
            context,
            notification['title'],
            notification['content'],
            notification['courseID'],
            notification['publishDate'],
          ),
        );
      }
    }
  }

  Future<List<dynamic>> getAnnouncements() async {
    String parCourseID = widget.courseID;
    String parSectionID = widget.courseSectionID;
    String parSemester = widget.courseSemester;
    String parYear = widget.courseYear;
    final url =
        'http://10.0.2.2/graded/getannouncements.php?courseID=$parCourseID&sectionID=$parSectionID&semester=$parSemester&year=$parYear';
    final response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      courseAnnouncements = json.decode(response.body);
      courseAnnouncements = courseAnnouncements.reversed.toList();

      return courseAnnouncements;
    } else {
      throw Exception('Failed to load announcements');
    }
  }

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
          widget.courseName.toUpperCase(),
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
              stops: const [0.1, 0.5, 0.9],
              colors: [
                ReusableWidgets.colorCourse3,
                ReusableWidgets.colorCourse2,
                ReusableWidgets.colorCourse1,
              ],
            ),
          ),
        ),
      ),
      backgroundColor: ReusableWidgets.colorLight,
      extendBodyBehindAppBar: true,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Center(
              child: Column(
                children: [
                  Card(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20)),
                    color: ReusableWidgets.colorLight,
                    elevation: 2.0,
                    shadowColor: ReusableWidgets.colorDark,
                    child: Container(
                      width: double.infinity,
                      margin: const EdgeInsets.all(8.0),
                      child: Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(5.0),
                            child: SizedBox(
                              width: double.infinity,
                              child: Row(
                                children: [
                                  Icon(
                                    CupertinoIcons.info,
                                    size: 30,
                                    color: ReusableWidgets.colorDark,
                                  ),
                                  const SizedBox(
                                    width: 8,
                                  ),
                                  Text(
                                    " Course Information",
                                    style: TextStyle(
                                      color: ReusableWidgets.colorDark,
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                    ),
                                    textAlign: TextAlign.left,
                                  ),
                                ],
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 3),
                            child: Card(
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20)),
                              color: ReusableWidgets.colorLight,
                              elevation: 2.0,
                              shadowColor: ReusableWidgets.colorPeople1,
                              child: Container(
                                margin: const EdgeInsets.all(8.0),
                                width: double.infinity,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Align(
                                      alignment: Alignment.center,
                                      child: Text(
                                        widget.courseID,
                                        style: const TextStyle(
                                          color: Colors.grey,
                                        ),
                                      ),
                                    ),
                                    const SizedBox(
                                      height: 3.0,
                                    ),
                                    Align(
                                      alignment: Alignment.center,
                                      child: Text(
                                        widget.courseName.toUpperCase(),
                                        style: TextStyle(
                                          color: ReusableWidgets.colorCourse1,
                                          fontSize: 20,
                                          fontWeight: FontWeight.w900,
                                        ),
                                      ),
                                    ),
                                    const SizedBox(
                                      height: 10.0,
                                    ),
                                    const Align(
                                      alignment: Alignment.center,
                                      child: Divider(
                                        color: Colors.grey, //color of divider
                                        height: 5, //height spacing of divider
                                        thickness:
                                            2.0, //thickness of divider line
                                        indent:
                                            5, //spacing at the start of divider
                                        endIndent:
                                            5, //spacing at the end of divider
                                      ),
                                    ),
                                    const SizedBox(
                                      height: 10.0,
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
                                          shaderCallback: (Rect bounds) =>
                                              RadialGradient(
                                            center: Alignment.topCenter,
                                            stops: const [.9, 1],
                                            colors: [
                                              ReusableWidgets.colorCourse2,
                                              ReusableWidgets.colorCourse3,
                                            ],
                                          ).createShader(bounds),
                                          child: const Icon(
                                            CupertinoIcons.person_solid,
                                            size: 36,
                                          ),
                                        ),
                                        const SizedBox(
                                          width: 48,
                                        ),
                                        Flexible(
                                          child: Text(
                                            "${widget.instructorName} ${widget.instructorSurname}",
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                            style: const TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 17,
                                                color:
                                                    CupertinoColors.systemGrey),
                                          ),
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
                                          shaderCallback: (Rect bounds) =>
                                              RadialGradient(
                                            center: Alignment.topCenter,
                                            stops: const [.9, 1],
                                            colors: [
                                              ReusableWidgets.colorCourse2,
                                              ReusableWidgets.colorCourse3,
                                            ],
                                          ).createShader(bounds),
                                          child: const Icon(
                                            Icons.school_rounded,
                                            size: 36,
                                          ),
                                        ),
                                        const SizedBox(
                                          width: 48,
                                        ),
                                        Flexible(
                                          child: Text(
                                            widget.courseDeptName,
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                            style: const TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 17,
                                              color: CupertinoColors.systemGrey,
                                            ),
                                          ),
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
                                          shaderCallback: (Rect bounds) =>
                                              RadialGradient(
                                            center: Alignment.topCenter,
                                            stops: const [.9, 1],
                                            colors: [
                                              ReusableWidgets.colorCourse2,
                                              ReusableWidgets.colorCourse3,
                                            ],
                                          ).createShader(bounds),
                                          child: const Icon(
                                            Icons.credit_score_rounded,
                                            size: 36,
                                          ),
                                        ),
                                        const SizedBox(
                                          width: 48,
                                        ),
                                        Text(
                                          widget.courseCredit,
                                          style: const TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 17,
                                              color:
                                                  CupertinoColors.systemGrey),
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
                                          shaderCallback: (Rect bounds) =>
                                              RadialGradient(
                                            center: Alignment.topCenter,
                                            stops: const [.9, 1],
                                            colors: [
                                              ReusableWidgets.colorCourse2,
                                              ReusableWidgets.colorCourse3,
                                            ],
                                          ).createShader(bounds),
                                          child: const Icon(
                                            Icons.date_range_rounded,
                                            size: 36,
                                          ),
                                        ),
                                        const SizedBox(
                                          width: 48,
                                        ),
                                        Text(
                                          "${widget.courseSemester} ${widget.courseYear}",
                                          style: const TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 17,
                                              color:
                                                  CupertinoColors.systemGrey),
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
                  const SizedBox(
                    height: 12,
                  ),
                  Card(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20)),
                    color: ReusableWidgets.colorLight,
                    elevation: 2.0,
                    shadowColor: ReusableWidgets.colorDark,
                    child: Container(
                      width: double.infinity,
                      margin: const EdgeInsets.all(4.0),
                      child: Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Column(
                              children: [
                                Row(
                                  children: [
                                    buttonContainer(
                                        Icons.announcement_rounded,
                                        'Announcements',
                                        ReusableWidgets.colorAnnouncement),
                                    const SizedBox(
                                      width: 8,
                                    ),
                                    buttonContainer(
                                      Icons.assignment_outlined,
                                      'Assignments',
                                      ReusableWidgets.colorAssignment,
                                    ),
                                  ],
                                ),
                                Row(
                                  children: [
                                    buttonContainer(
                                      CupertinoIcons.person_2_fill,
                                      'People',
                                      ReusableWidgets.colorPeople,
                                    ),
                                    const SizedBox(
                                      width: 8,
                                    ),
                                    buttonContainer(
                                      CupertinoIcons.chart_bar_alt_fill,
                                      'Grades',
                                      ReusableWidgets.colorGrades,
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 12,
                  ),
                  Card(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20)),
                    color: ReusableWidgets.colorLight,
                    elevation: 2.0,
                    shadowColor: ReusableWidgets.colorDark,
                    child: Container(
                      width: double.infinity,
                      margin: const EdgeInsets.all(8.0),
                      child: Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(5.0),
                            child: SizedBox(
                              width: double.infinity,
                              child: Row(
                                children: [
                                  Icon(
                                    CupertinoIcons.bell,
                                    size: 30,
                                    color: ReusableWidgets.colorDark,
                                  ),
                                  const SizedBox(
                                    width: 8,
                                  ),
                                  Text(
                                    " Recently on ${widget.courseID}",
                                    style: TextStyle(
                                      color: ReusableWidgets.colorDark,
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                    ),
                                    textAlign: TextAlign.left,
                                  ),
                                ],
                              ),
                            ),
                          ),
                          FutureBuilder(
                            future: formNotifications(),
                            builder: (context, AsyncSnapshot<void> snapshot) {
                              if (snapshot.hasError) {
                                return Text('Error: ${snapshot.error}');
                              }
                              switch (snapshot.connectionState) {
                                case ConnectionState.waiting:
                                  return Center(
                                    child: LoadingAnimationWidget.newtonCradle(
                                        color: ReusableWidgets.colorDark,
                                        size: 125),
                                  );
                                default:
                                  return courseNotificationsToDisplay.isEmpty
                                      ? Image.asset(
                                          'assets/images/no_notifications.png',
                                          width: double.infinity,
                                          fit: BoxFit.fill,
                                        )
                                      : CarouselSlider(
                                          options: CarouselOptions(
                                            autoPlay: true,
                                            aspectRatio: 2.1,
                                            enlargeCenterPage: true,
                                            enableInfiniteScroll: false,
                                            initialPage: 0,
                                          ),
                                          items: courseNotificationsToDisplay,
                                        );
                              }
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
      ),
    );
  }

  Widget buttonContainer(IconData iconData, String title, Color color) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 3.0),
      child: InkWell(
        onTap: () {
          if (title == 'Announcements') {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => AnnouncementPage(
                  courseID: widget.courseID,
                  courseSectionID: widget.courseSectionID,
                  courseSemester: widget.courseSemester,
                  courseYear: widget.courseYear,
                  courseName: widget.courseName,
                ),
              ),
            );
          } else if (title == 'Assignments') {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => AssignmentPage(
                  courseID: widget.courseID,
                  courseSectionID: widget.courseSectionID,
                  courseSemester: widget.courseSemester,
                  courseYear: widget.courseYear,
                  courseName: widget.courseName,
                ),
              ),
            );
          } else if (title == 'People') {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => PeoplePage(
                  courseID: widget.courseID,
                  sectionID: widget.courseSectionID,
                  semester: widget.courseSemester,
                  year: widget.courseYear,
                ),
              ),
            );
          } else {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => GradePage(
                  courseID: widget.courseID,
                  sectionID: widget.courseSectionID,
                  semester: widget.courseSemester,
                  year: widget.courseYear,
                ),
              ),
            );
          }
        },
        child: Container(
          width: (MediaQuery.of(context).size.width - 56) / 2,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20), color: color),
          child: Card(
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
            color: ReusableWidgets.colorLight,
            elevation: 2.0,
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 12),
              width: double.infinity,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    iconData,
                    color: color,
                  ),
                  const SizedBox(
                    height: 6.0,
                  ),
                  Text(
                    title,
                    style: TextStyle(
                      color: color,
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                    ),
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
