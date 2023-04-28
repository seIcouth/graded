import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:graded/screens/people_page.dart';
import 'package:intl/intl.dart';
import '../resources/reusable_methods.dart';
import 'package:graded/models/home_notification.dart' as ntf;
import '../resources/reusable_widgets.dart';

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
  static String formatDate(DateTime date) =>
      DateFormat("MMMM d - hh:mm").format(date);

  // dummy list (will change)
  List<Widget> dummyNotifications = [];

  List<ntf.Notification> recentNotifications = [
    ntf.AnnouncementNotification(
      title: "First Lecture",
      content:
      "Hello everyone, we will start the lectures on Monday. Lectures will be held on F0D11. See you at the class.",
      courseCode: "COMP101",
      courseName: "Art of Computing",
    ),
    ntf.AssignmentNotification(
        title: "First Lecture",
        content:
        "You're expected to implement a java method that finds whether a given number is a prime number or not.",
        courseCode: "COMP101",
        courseName: "Art of Computing",
        dueDate: formatDate(DateTime.now())),
    ntf.AnnouncementNotification(
        title: "Hyflex Lectures",
        content:
        "We will have hyflex lectures during this semester according to YOK's new regulations. Get prepared.",
        courseCode: "MATH151",
        courseName: "Calculus I"),
    ntf.AnnouncementNotification(
      title: "About Week-1",
      content:
      "Read the discussions and try to answer the question before the lecture. Also, don't forget to watch the recorded videos.",
      courseCode: "TURK101",
      courseName: "Turkish I",
    ),
    ntf.AnnouncementNotification(
      title: "First Quiz",
      content:
      "We will have our first quiz on monday, second lecture. Good luck.",
      courseCode: "PHYS101",
      courseName: "Physics I",
    ),
  ];

  @override
  Widget build(BuildContext context) {
    for (int i = 0; i < recentNotifications.length; i++) {
      if (recentNotifications[i] is ntf.AssignmentNotification) {
        ntf.AssignmentNotification s =
        recentNotifications[i] as ntf.AssignmentNotification;
        dummyNotifications.add(ReusableWidgets.assignmentNotificationCard(context, s.title,
            s.content, s.courseCode, s.courseName, s.dueDate));
      } else {
        ntf.AnnouncementNotification n =
        recentNotifications[i] as ntf.AnnouncementNotification;
        dummyNotifications.add(ReusableWidgets.announcementNotificationCard(
            context, n.title, n.content, n.courseCode, n.courseName));
      }
    }

    return Scaffold(
      appBar: AppBar(
        backgroundColor: ReusableMethods.colorPeople,
        title: Text(
          widget.courseName.toUpperCase(),
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
                0.5,
                0.9
              ],
              colors: [
                ReusableMethods.colorCourse_3,
                ReusableMethods.colorCourse_2,
                ReusableMethods.colorCourse_1,
              ],
            ),
          ),
        ),
      ),
      backgroundColor: ReusableMethods.colorLight,
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
                    color: ReusableMethods.colorLight,
                    elevation: 2.0,
                    shadowColor: ReusableMethods.colorDark,
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
                                    color: ReusableMethods.colorDark,
                                  ),
                                  const SizedBox(
                                    width: 8,
                                  ),
                                  Text(
                                    " Course Information",
                                    style: TextStyle(
                                      color: ReusableMethods.colorDark,
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
                                          color: ReusableMethods.colorCourse_1,
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
                                        color: Colors
                                            .grey, //color of divider
                                        height:
                                        5, //height spacing of divider
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
                                          shaderCallback:
                                              (Rect bounds) =>
                                              RadialGradient(
                                                center: Alignment.topCenter,
                                                stops: const [.9, 1],
                                                colors: [
                                                  ReusableMethods.colorCourse_2,
                                                  ReusableMethods.colorCourse_3,
                                                ],
                                              ).createShader(bounds),
                                          child: const Icon(
                                              CupertinoIcons
                                                  .person_solid,
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
                                                fontWeight:
                                                FontWeight.bold,
                                                fontSize: 17,
                                                color: CupertinoColors
                                                    .systemGrey),
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
                                          shaderCallback:
                                              (Rect bounds) =>
                                              RadialGradient(
                                                center: Alignment.topCenter,
                                                stops: const [.9, 1],
                                                colors: [
                                                  ReusableMethods.colorCourse_2,
                                                  ReusableMethods.colorCourse_3,
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
                                                fontWeight:
                                                FontWeight.bold,
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
                                          shaderCallback:
                                              (Rect bounds) =>
                                              RadialGradient(
                                                center: Alignment.topCenter,
                                                stops: const [.9, 1],
                                                colors: [
                                                  ReusableMethods.colorCourse_2,
                                                  ReusableMethods.colorCourse_3,
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
                                              fontWeight:
                                              FontWeight.bold,
                                              fontSize: 17,
                                              color: CupertinoColors
                                                  .systemGrey
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
                                          shaderCallback:
                                              (Rect bounds) =>
                                              RadialGradient(
                                                center: Alignment.topCenter,
                                                stops: const [.9, 1],
                                                colors: [
                                                  ReusableMethods.colorCourse_2,
                                                  ReusableMethods.colorCourse_3,
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
                  const SizedBox(height: 12,),
                  Card(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20)),
                    color: ReusableMethods.colorLight,
                    elevation: 2.0,
                    shadowColor: ReusableMethods.colorDark,
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
                                        ReusableMethods.colorAnnouncement
                                    ),
                                    const SizedBox(width: 8,),
                                    buttonContainer(
                                      Icons.assignment_outlined,
                                      'Assignments',
                                      ReusableMethods.colorAssignment,
                                    ),
                                  ],
                                ),
                                Row(
                                  children: [
                                    buttonContainer(
                                      CupertinoIcons.person_2_fill,
                                      'People',
                                      ReusableMethods.colorPeople,
                                    ),
                                    const SizedBox(width: 8,),
                                    buttonContainer(
                                      CupertinoIcons.chart_bar_alt_fill,
                                      'Grades',
                                      ReusableMethods.colorGrades,
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
                  const SizedBox(height: 12,),
                  Card(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20)),
                    color: ReusableMethods.colorLight,
                    elevation: 2.0,
                    shadowColor: ReusableMethods.colorDark,
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
                                    color: ReusableMethods.colorDark,
                                  ),
                                  const SizedBox(
                                    width: 8,
                                  ),
                                  Text(
                                    " Recently on ${widget.courseID}",
                                    style: TextStyle(
                                      color: ReusableMethods.colorDark,
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                    ),
                                    textAlign: TextAlign.left,
                                  ),
                                ],
                              ),
                            ),
                          ),
                          CarouselSlider(
                            options: CarouselOptions(
                              autoPlay: true,
                              aspectRatio: 2.1,
                              enlargeCenterPage: true,
                              enableInfiniteScroll: false,
                              initialPage: 0,
                            ),
                            items: dummyNotifications,
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

  Widget buttonContainer(IconData iconData, String title, Color color){
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 3.0),
      child: InkWell(
        onTap: (){
          if(title=='People'){
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => PeoplePage(courseID: widget.courseID, sectionID: widget.courseSectionID, semester: widget.courseSemester, year: widget.courseYear,),
              ),
            );
          }
        },
        child: Container(
          width: (MediaQuery.of(context).size.width - 56)/2,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            color: color
          ),
          child: Card(
            shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
            color: ReusableMethods.colorLight,
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
