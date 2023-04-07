import 'package:flutter/material.dart';
import 'package:graded/models/home_notification.dart';
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

  List<Widget> dummyNotifications = [];
  List<HomeNotification> homeNotifications = [
    AnnouncementNotification(
      title: "First Lecture",
      content:
          "Hello everyone, we will start the lectures on Monday. Lectures will be held on F0D11. See you at the class.",
      courseCode: "COMP101",
      courseName: "Art of Computing",
    ),
    AssignmentNotification(
        title: "First Lecture",
        content:
            "You're expected to implement a java method that finds whether a given number is a prime number or not.",
        courseCode: "COMP101",
        courseName: "Art of Computing",
        dueDate: formatDate(DateTime.now())),
    AnnouncementNotification(
        title: "First Lecture",
        content:
            "Hello everyone, we will start the lectures on Wednesday. Lectures will be held on F0D15. See you at the class.",
        courseCode: "MATH151",
        courseName: "Calculus I"),
    AnnouncementNotification(
      title: "First Lecture",
      content:
          "Hello everyone, we will start the lectures on Tuesday. Lectures will be held on F0D13. See you at the class.",
      courseCode: "TURK101",
      courseName: "Turkish I",
    ),
    AnnouncementNotification(
      title: "First Lecture",
      content:
          "Hello everyone, we will start the lectures on Friday. Lectures will be held on F0D17. See you at the class.",
      courseCode: "PHYS101",
      courseName: "Physics I",
    ),
  ];

  final Color colorLight = const Color(0xfffff4f0);
  final Color colorDark = const Color(0xff0e1e40);

  @override
  Widget build(BuildContext context) {
    for (int i = 0; i < homeNotifications.length; i++) {
      if (homeNotifications[i] is AssignmentNotification) {
        AssignmentNotification s =
            homeNotifications[i] as AssignmentNotification;
        dummyNotifications.add(assignmentNotificationCard(context, s.title,
            s.content, s.courseCode, s.courseName, s.dueDate));
      } else {
        AnnouncementNotification n =
            homeNotifications[i] as AnnouncementNotification;
        dummyNotifications.add(announcementNotificationCard(
            context, n.title, n.content, n.courseCode, n.courseName));
      }
    }

    return Scaffold(
      backgroundColor: colorLight,
      extendBodyBehindAppBar: true,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(8.0, 8.0, 8.0, 8.0),
          child: Center(
            child: Column(
              children: [
                Card(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20)),
                  color: colorLight,
                  elevation: 2.0,
                  shadowColor: colorDark,
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
                                  color: colorDark,
                                ),
                                Text(
                                  "Recent Notifications",
                                  style: TextStyle(
                                    color: colorDark,
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                  textAlign: TextAlign.left,
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
    Color announcementColor = Colors.teal;

    return Card(
      color: announcementColor,
      elevation: 6,
      shadowColor: colorDark,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        color: colorLight,
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
                                color: announcementColor,
                              ),
                              Expanded(
                                child: Text(
                                  title,
                                  style: TextStyle(
                                    color: announcementColor,
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
                              color: announcementColor,
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
    Color assignmentColor = Colors.deepOrangeAccent;

    return Card(
      color: assignmentColor,
      elevation: 6,
      shadowColor: colorDark,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        color: colorLight,
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
                                color: assignmentColor,
                              ),
                              Expanded(
                                child: Text(
                                  title,
                                  style: TextStyle(
                                    color: assignmentColor,
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
                              color: assignmentColor,
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                            softWrap: false,
                            maxLines: 2,
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
