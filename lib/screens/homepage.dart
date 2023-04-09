import 'package:flutter/material.dart';
import 'package:graded/models/home_course.dart';
import 'package:graded/models/home_notification.dart' as N;
import 'package:graded/resources/reusable_methods.dart';
import 'package:intl/intl.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _index = 0;

  static String formatDate(DateTime date) =>
      DateFormat("MMMM d - hh:mm").format(date);

  List<HomeCourse> dummyCourses = [
    HomeCourse(courseName: "Art of Computing", courseCode: "COMP101"),
    HomeCourse(courseName: "Calculus I", courseCode: "MATH151"),
    HomeCourse(courseName: "Turkish I", courseCode: "TURK101"),
    HomeCourse(courseName: "Physics I", courseCode: "PHYS101"),
    HomeCourse(courseName: "French I", courseCode: "FRCH101"),
    HomeCourse(courseName: "AGU WAYS I", courseCode: "GLB101"),
  ];

  List<Widget> dummyNotifications = [];
  List<N.Notification> recentNotifications = [
    N.AnnouncementNotification(
      title: "First Lecture",
      content:
          "Hello everyone, we will start the lectures on Monday. Lectures will be held on F0D11. See you at the class.",
      courseCode: "COMP101",
      courseName: "Art of Computing",
    ),
    N.AssignmentNotification(
        title: "First Lecture",
        content:
            "You're expected to implement a java method that finds whether a given number is a prime number or not.",
        courseCode: "COMP101",
        courseName: "Art of Computing",
        dueDate: formatDate(DateTime.now())),
    N.AnnouncementNotification(
        title: "Hyflex Lectures",
        content:
            "We will have hyflex lectures during this semester according to YOK's new regulations. Get prepared.",
        courseCode: "MATH151",
        courseName: "Calculus I"),
    N.AnnouncementNotification(
      title: "About Week-1",
      content:
          "Read the discussions and try to answer the question before the lecture. Also, don't forget to watch the recorded videos.",
      courseCode: "TURK101",
      courseName: "Turkish I",
    ),
    N.AnnouncementNotification(
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
      if (recentNotifications[i] is N.AssignmentNotification) {
        N.AssignmentNotification s =
            recentNotifications[i] as N.AssignmentNotification;
        dummyNotifications.add(assignmentNotificationCard(context, s.title,
            s.content, s.courseCode, s.courseName, s.dueDate));
      } else {
        N.AnnouncementNotification n =
            recentNotifications[i] as N.AnnouncementNotification;
        dummyNotifications.add(announcementNotificationCard(
            context, n.title, n.content, n.courseCode, n.courseName));
      }
    }

    return Scaffold(
      backgroundColor: ReusableMethods.colorLight,
      extendBodyBehindAppBar: true,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(8.0, 8.0, 8.0, 8.0),
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
                                    Icons.notifications_none_outlined,
                                    color: ReusableMethods.colorDark,
                                  ),
                                  Text(
                                    " Recent Notifications",
                                    style: TextStyle(
                                      color: ReusableMethods.colorDark,
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                    ),
                                    textAlign: TextAlign.left,
                                  ),
                                  const Spacer(),
                                  IconButton(
                                    onPressed: () {},
                                    icon: const Icon(
                                        Icons.arrow_forward_ios_rounded),
                                    color: ReusableMethods.colorDark,
                                  ),
                                ],
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 170, // card height
                            child: PageView.builder(
                              itemCount: 5,
                              controller: PageController(viewportFraction: 0.7),
                              onPageChanged: (int index) =>
                                  setState(() => _index = index),
                              itemBuilder: (_, i) {
                                return Transform.scale(
                                  scale: i == _index ? 1 : 0.85,
                                  child: dummyNotifications[i],
                                );
                              },
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
                                    Icons.library_books_outlined,
                                    color: ReusableMethods.colorDark,
                                  ),
                                  Text(
                                    " Courses",
                                    style: TextStyle(
                                      color: ReusableMethods.colorDark,
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                    ),
                                    textAlign: TextAlign.left,
                                  ),
                                  const Spacer(),
                                  IconButton(
                                    onPressed: () {},
                                    icon: const Icon(
                                        Icons.arrow_forward_ios_rounded),
                                    color: ReusableMethods.colorDark,
                                  ),
                                ],
                              ),
                            ),
                          ),
                          ListView.builder(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemCount: dummyCourses.length,
                            itemBuilder: (context, i) {
                              return courseCard(context, dummyCourses[i]);
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

  Widget courseCard(BuildContext context, HomeCourse homeCourse) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 3.0),
      child: Card(
        color: ReusableMethods.colorDark,
        elevation: 6,
        shadowColor: ReusableMethods.colorDark,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        child: Card(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          color: ReusableMethods.colorLight,
          elevation: 2.0,
          child: Container(
            margin: const EdgeInsets.all(8.0),
            width: double.infinity,
            child: Stack(
              children: [
                Column(
                  children: [
                    Text(
                      homeCourse.courseCode,
                      style: const TextStyle(
                        color: Colors.grey,
                      ),
                    ),
                    const SizedBox(
                      height: 3.0,
                    ),
                    Text(
                      homeCourse.courseName,
                      style: TextStyle(
                        color: ReusableMethods.colorDark,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(
                      height: 10.0,
                    ),
                    const Divider(
                      color: Colors.grey, //color of divider
                      height: 5, //height spacing of divider
                      thickness: 2.0, //thickness of divider line
                      indent: 5, //spacing at the start of divider
                      endIndent: 5, //spacing at the end of divider
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        IconButton(
                          onPressed: () {},
                          icon: Icon(
                            Icons.announcement_rounded,
                            color: ReusableMethods.colorAnnouncement,
                          ),
                          tooltip: "announcements",
                        ),
                        IconButton(
                          onPressed: () {},
                          icon: Icon(
                            Icons.assignment_outlined,
                            color: ReusableMethods.colorAssignment,
                          ),
                          tooltip: "assignments",
                        ),
                        IconButton(
                          onPressed: () {},
                          icon: Icon(
                            Icons.people,
                            color: ReusableMethods.colorPeople,
                          ),
                          tooltip: "people",
                        ),
                        IconButton(
                          onPressed: () {},
                          icon: Icon(
                            Icons.leaderboard_rounded,
                            color: ReusableMethods.colorGrades,
                          ),
                          tooltip: "grades",
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget announcementNotificationCard(
    BuildContext context,
    String title,
    String content,
    String courseCode,
    String courseName,
  ) {
    return Card(
      color: ReusableMethods.colorAnnouncement,
      elevation: 6,
      shadowColor: ReusableMethods.colorDark,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        color: ReusableMethods.colorLight,
        elevation: 2.0,
        child: Container(
          margin: const EdgeInsets.all(8.0),
          child: Stack(
            children: [
              Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(5.0),
                    child: SizedBox(
                      width: double.infinity,
                      child: Column(
                        children: [
                          Row(
                            children: [
                              Icon(
                                Icons.announcement_rounded,
                                color: ReusableMethods.colorAnnouncement,
                              ),
                              Expanded(
                                child: Text(
                                  title,
                                  style: TextStyle(
                                    color: ReusableMethods.colorAnnouncement,
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                  softWrap: false,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  textAlign: TextAlign.center,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(
                            height: 10.0,
                          ),
                          const Divider(
                            color: Colors.grey, //color of divider
                            height: 5, //height spacing of divider
                            thickness: 1.5, //thickness of divider line
                            indent: 5, //spacing at the start of divider
                            endIndent: 5, //spacing at the end of divider
                          ),
                          const SizedBox(
                            height: 10.0,
                          ),
                          Text(
                            content,
                            style: TextStyle(
                              color: ReusableMethods.colorAnnouncement,
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                            softWrap: false,
                            maxLines: 3,
                            overflow: TextOverflow.ellipsis,
                            textAlign: TextAlign.left,
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(5.0, 5.0, 5.0, 2.0),
                child: Align(
                  alignment: Alignment.bottomLeft,
                  child: Text(
                    "$courseCode • $courseName",
                    style: const TextStyle(
                      color: Colors.grey,
                      fontSize: 12,
                      fontWeight: FontWeight.normal,
                    ),
                    softWrap: false,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    textAlign: TextAlign.left,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget assignmentNotificationCard(
    BuildContext context,
    String title,
    String content,
    String courseCode,
    String courseName,
    String dueDate,
  ) {
    return Card(
      color: ReusableMethods.colorAssignment,
      elevation: 6,
      shadowColor: ReusableMethods.colorDark,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        color: ReusableMethods.colorLight,
        elevation: 2.0,
        child: Container(
          margin: const EdgeInsets.all(8.0),
          child: Stack(
            children: [
              Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(5.0),
                    child: SizedBox(
                      width: double.infinity,
                      child: Column(
                        children: [
                          Row(
                            children: [
                              Icon(
                                Icons.assignment_outlined,
                                color: ReusableMethods.colorAssignment,
                              ),
                              Expanded(
                                child: Text(
                                  title,
                                  style: TextStyle(
                                    color: ReusableMethods.colorAssignment,
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                  softWrap: false,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  textAlign: TextAlign.center,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(
                            height: 10.0,
                          ),
                          const Divider(
                            color: Colors.grey, //color of divider
                            height: 5, //height spacing of divider
                            thickness: 1.5, //thickness of divider line
                            indent: 5, //spacing at the start of divider
                            endIndent: 5, //spacing at the end of divider
                          ),
                          const SizedBox(
                            height: 10.0,
                          ),
                          Text(
                            content,
                            style: TextStyle(
                              color: ReusableMethods.colorAssignment,
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                            softWrap: false,
                            maxLines: 3,
                            overflow: TextOverflow.ellipsis,
                            textAlign: TextAlign.left,
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(5.0, 5.0, 5.0, 2.0),
                child: Align(
                  alignment: Alignment.bottomLeft,
                  child: Text(
                    "$courseCode • DUE: $dueDate",
                    style: const TextStyle(
                      color: Colors.grey,
                      fontSize: 12,
                      fontWeight: FontWeight.normal,
                    ),
                    softWrap: false,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    textAlign: TextAlign.left,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
