// ignore_for_file: avoid_print
// ignore_for_file: use_build_context_synchronously
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:graded/resources/reusable_methods.dart';
import 'package:graded/resources/reusable_widgets.dart';
import 'package:graded/screens/course_screens/grade_page.dart';
import 'package:graded/screens/course_screens/course_page.dart';
import 'package:graded/screens/course_screens/people_page.dart';
import 'package:graded/screens/course_screens/assignment_page.dart';
import 'package:graded/screens/course_screens/announcement_page.dart';
import 'package:http/http.dart' as http;
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:hidden_drawer_menu/controllers/simple_hidden_drawer_controller.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  // variables
  late int instructorID;
  String? courseID;
  String? name;
  String? deptName;
  int credit = 0;
  String semester = 'Select a semester';
  int year = 2020;
  String? studentMail;
  String inviteCourseID = 'Select a course';
  String removeCourseID = 'Select a course';

  String? announcementTitle;
  String? announcementContent;

  String? assignmentTitle;
  String? assignmentContent;
  DateTime assignmentDueDate = DateTime.now();
  bool isDateSelected = false;

  late String role;
  late List<dynamic> courses;
  List<String> inviteCourses = ['Select a course'];
  List<String> studentMails = [];

  // lists for dropdown buttons
  List<String> semesters = [
    'Select a semester',
    'Fall',
    'Winter',
    'Spring',
    'Summer'
  ];
  List<int> years = [
    2020,
    2021,
    2022,
    2023,
    2024,
    2025,
    2026,
    2027,
    2028,
    2029,
    2030
  ];
  List<int> credits = [0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10];

  // accessor methods
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
      print('Failed to get user info. Status code: ${response.statusCode}');
      return '-1';
    }
  }

  Future<List<dynamic>> getCourses() async {
    int? id = await ReusableMethods.getUserId();
    await getRole();

    // Construct the URL with the user ID
    String url = role == 'Student'
        ? 'http://10.0.2.2/graded/getcoursesbystudentid.php?studentID=$id'
        : 'http://10.0.2.2/graded/getcoursesbyinstructorid.php?instructorID=$id';

    // Make an HTTP GET request to the PHP script
    http.Response response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      // If the response is successful (status code 200)
      // Parse the response body as JSON
      courses = json.decode(response.body);

      inviteCourses = ['Select a course'];
      for (int i = 0; i < courses.length; i++) {
        inviteCourses.add(courses[i]['courseID']);
      }

      // Return the list of courses
      return courses;
    } else {
      // If the response is not successful
      print('Failed to get courses. Status code: ${response.statusCode}');
      return [];
    }
  }

  Future<List<dynamic>> getStudentMails(String parCourseID, String parSectionID,
      String parSemester, String parYear) async {
    final url =
        'http://10.0.2.2/graded/getpeople.php?courseID=$parCourseID&sectionID=$parSectionID&semester=$parSemester&year=$parYear';
    final response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      List<dynamic> people = json.decode(response.body);
      for (var person in people) {
        if (person['type'] == 'student') {
          // Add the person to the students list
          studentMails.add(person['mail']);
        }
      }
      return Future.value(studentMails);
    } else {
      throw Exception('Failed to load student mails');
    }
  }

  Future<String> getInviteCourseSemester(String inviteCourseID) async {
    for (int i = 0; i < courses.length; i++) {
      if (courses[i]['courseID'] == inviteCourseID) {
        return courses[i]['semester'];
      }
    }
    return '';
  }

  Future<int> getInviteCourseYear(String inviteCourseID) async {
    for (int i = 0; i < courses.length; i++) {
      if (courses[i]['courseID'] == inviteCourseID) {
        return int.parse(courses[i]['year']);
      }
    }
    return -1;
  }

  Future<String> getInviteCourseSectionID(String inviteCourseID) async {
    for (int i = 0; i < courses.length; i++) {
      if (courses[i]['courseID'] == inviteCourseID) {
        return courses[i]['sectionID'];
      }
    }
    return '';
  }

  // manipulation methods
  Future<void> createCourse(
      int parInstructorID,
      String parCourseID,
      String parName,
      String parDeptName,
      int parCredit,
      String parSemester,
      int parYear) async {
    try {
      // Prepare the request body as a Map
      final requestBody = {
        'instructorID': parInstructorID.toString(), // Convert to String
        'courseID': parCourseID,
        'name': parName,
        'deptName': parDeptName,
        'credit': parCredit.toString(), // Convert to String
        'sectionID': '1',
        'semester': parSemester,
        'year': parYear.toString(), // Convert to String
      };

      // Send a POST request to the related file on server
      final response = await http.post(
        Uri.parse('http://10.0.2.2/graded/createcourse.php'),
        body: requestBody,
      );

      if (response.statusCode == 200) {
        // Course created successfully
        print('Course created successfully');
      } else {
        // Handle any errors from the server
        print('Failed to create course: ${response.body}');
      }
    } catch (e) {
      // Handle any errors locally
      print('Failed to create course: $e');
    }
  }

  Future<void> sendInvite(
      int parInstructorID,
      String parStudentEmail,
      String parCourseID,
      String parSectionID,
      String parSemester,
      int parYear) async {
    try {
      await getStudentMails(
          parCourseID, parSectionID, parSemester, parYear.toString());
      // Prepare the request body as a Map
      final requestBody = {
        'instructorID': parInstructorID.toString(),
        'studentEmail': parStudentEmail,
        'courseID': parCourseID,
        'sectionID': parSectionID,
        'semester': parSemester,
        'year': parYear.toString(),
      };

      // Send a POST request to the invites.php file on the server
      final response = await http.post(
        Uri.parse('http://10.0.2.2/graded/invite.php'),
        body: requestBody,
      );

      if (response.statusCode == 200) {
        // Invite sent successfully
        print('Invite sent successfully');
      } else {
        // Handle any errors from the server
        print('Failed to send invite: ${response.body}');
      }
    } catch (e) {
      // Handle any errors locally
      print('Failed to send invite: $e');
    }
  }

  Future<void> removeStudent(String parStudentEmail, String parCourseID,
      String parSectionID, String parSemester, int parYear) async {
    try {
      // Prepare the request body as a Map
      final requestBody = {
        'studentEmail': parStudentEmail,
        'courseID': parCourseID,
        'sectionID': parSectionID,
        'semester': parSemester,
        'year': parYear.toString(),
      };

      // Send a POST request to the related file on server
      final response = await http.post(
        Uri.parse(
            'http://10.0.2.2/graded/removestudent.php?studentEmail=$parStudentEmail&courseID=$parCourseID&sectionID=$parSectionID&semester=$parSemester&year=$parYear'),
        body: requestBody,
      );

      if (response.statusCode == 200) {
        // Student removed successfully
        print('Student removed successfully');
      } else {
        // Handle any errors from the server
        print('Failed to remove student: ${response.body}');
      }
    } catch (e) {
      // Handle any errors locally
      print('Failed to remove student: $e');
    }
  }

  Future<void> publishAnnouncement(
      String parCourseID,
      String parSectionID,
      String parSemester,
      int parYear,
      String parTitle,
      String parContent,
      String parPublishDate) async {
    try {
      // Prepare the request body as a Map
      final requestBody = {
        'courseID': parCourseID,
        'sectionID': parSectionID,
        'semester': parSemester,
        'year': parYear.toString(),
        'title': parTitle,
        'content': parContent,
        'publishDate': parPublishDate,
      };

      // Send a POST request to the publishannouncement.php file on the server
      final response = await http.post(
        Uri.parse('http://10.0.2.2/graded/publishannouncement.php'),
        body: requestBody,
      );

      if (response.statusCode == 200) {
        // Announcement published successfully
        print('Announcement published successfully');
      } else {
        // Handle any errors from the server
        print('Failed to publish announcement: ${response.body}');
      }
    } catch (e) {
      // Handle any errors locally
      print('Failed to publish announcement: $e');
    }
  }

  Future<void> publishAssignment(
      String parCourseID,
      String parSectionID,
      String parSemester,
      int parYear,
      String parTitle,
      String parContent,
      String parPublishDate,
      String parDueDate) async {
    try {
      // Prepare the request body as a Map
      final requestBody = {
        'courseID': parCourseID,
        'sectionID': parSectionID,
        'semester': parSemester,
        'year': parYear.toString(),
        'title': parTitle,
        'content': parContent,
        'publishDate': parPublishDate,
        'dueDate': parDueDate,
      };

      // Send a POST request to the publish-assignment.php file on the server
      final response = await http.post(
        Uri.parse('http://10.0.2.2/graded/publishassignment.php'),
        body: requestBody,
      );

      if (response.statusCode == 200) {
        // Assignment published successfully
        print('Assignment published successfully');
      } else {
        // Handle any errors from the server
        print('Failed to publish assignment: ${response.body}');
      }
    } catch (e) {
      // Handle any errors locally
      print('Failed to publish assignment: $e');
    }
  }

  // form notifications
  List<dynamic> courseAnnouncements = [];
  List<dynamic> courseAssignments = [];
  List<dynamic> courseNotifications = [];
  List<Widget> courseNotificationsToDisplay = [];

  Future<void> formNotifications() async {
    await getCourses();

    courseNotifications = [];
    courseNotificationsToDisplay = [];

    for (int i = 0; i < courses.length; i++) {
      List<dynamic> announcements = await getAnnouncements(
          courses[i]['courseID'],
          courses[i]['sectionID'],
          courses[i]['semester'],
          courses[i]['year']);
      List<dynamic> assignments = await getAssignments(courses[i]['courseID'],
          courses[i]['sectionID'], courses[i]['semester'], courses[i]['year']);

      // merge the announcements and assignments into one list
      courseNotifications.addAll(announcements);
      courseNotifications.addAll(assignments);
    }

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
              notification['publishDate']),
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

  Future<List<dynamic>> getAssignments(
      String assignmentCourseID,
      String assignmentSectionID,
      String assignmentSemester,
      String assignmentYear) async {
    String parCourseID = assignmentCourseID;
    String parSectionID = assignmentSectionID;
    String parSemester = assignmentSemester;
    String parYear = assignmentYear;
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

  Future<List<dynamic>> getAnnouncements(
      String announcementCourseID,
      String announcementSectionID,
      String announcementSemester,
      String announcementYear) async {
    String parCourseID = announcementCourseID;
    String parSectionID = announcementSectionID;
    String parSemester = announcementSemester;
    String parYear = announcementYear;
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(4.0),
          child: Container(
            color: ReusableWidgets.colorDark,
            height: 3.0,
          ),
        ),
        backgroundColor: ReusableWidgets.colorLight,
        leading: IconButton(
          icon: Icon(
            CupertinoIcons.bars,
            color: ReusableWidgets.colorDark,
          ),
          onPressed: () {
            SimpleHiddenDrawerController.of(context).open();
          },
        ),
        centerTitle: true,
        shadowColor: ReusableWidgets.colorDark,
        title: Text(
          "Home",
          style: TextStyle(
            color: ReusableWidgets.colorDark,
            fontWeight: FontWeight.bold,
            fontSize: 20,
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
                                    CupertinoIcons.bell,
                                    size: 30,
                                    color: ReusableWidgets.colorDark,
                                  ),
                                  const SizedBox(
                                    width: 8,
                                  ),
                                  Text(
                                    " Recent Notifications",
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
                            future: Future.wait([formNotifications()]),
                            builder: (context, AsyncSnapshot<void> snapshot) {
                              if (snapshot.hasError) {
                                return Text('Error: ${snapshot.error}');
                              }
                              switch (snapshot.connectionState) {
                                case ConnectionState.waiting:
                                  return Center(
                                    child: ReusableWidgets.loadingAnimation(
                                        ReusableWidgets.colorDark),
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
                            padding: const EdgeInsets.symmetric(
                              horizontal: 5.0,
                              vertical: 8.0,
                            ),
                            child: SizedBox(
                              width: double.infinity,
                              child: Row(
                                children: [
                                  Icon(
                                    CupertinoIcons.collections,
                                    color: ReusableWidgets.colorDark,
                                  ),
                                  const SizedBox(
                                    width: 8,
                                  ),
                                  Text(
                                    " Courses",
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
                            future: getCourses(),
                            builder: (context, AsyncSnapshot<void> snapshot) {
                              if (snapshot.hasError) {
                                return Text('Error: ${snapshot.error}');
                              }
                              switch (snapshot.connectionState) {
                                case ConnectionState.waiting:
                                  return Center(
                                    child: ReusableWidgets.loadingAnimation(
                                        ReusableWidgets.colorDark),
                                  );
                                default:
                                  return courses.isEmpty
                                      ? Image.asset(
                                          role == "Instructor"
                                              ? 'assets/images/no_course_inst.png'
                                              : 'assets/images/no_course_std.png',
                                          width: double.infinity,
                                          fit: BoxFit.fill,
                                        )
                                      : ListView.builder(
                                          shrinkWrap: true,
                                          physics:
                                              const NeverScrollableScrollPhysics(),
                                          itemCount: courses.length,
                                          itemBuilder: (context, i) {
                                            return courseCard(
                                              context,
                                              courses[i]['courseID'],
                                              courses[i]['name'],
                                              courses[i]['deptName'],
                                              courses[i]['credit'],
                                              courses[i]['sectionID'],
                                              courses[i]['semester'],
                                              courses[i]['year'],
                                              courses[i]['instructorName'],
                                              courses[i]['surname'],
                                            );
                                          },
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
      floatingActionButton: FutureBuilder(
        future: Future.wait([getRole(), initializeSpeedDialChildren()]),
        builder: (context, AsyncSnapshot<List<dynamic>> snapshot) {
          if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}');
          }
          switch (snapshot.connectionState) {
            case ConnectionState.waiting:
              return const Text("");
            default:
              return Visibility(
                visible: snapshot.data![0] == 'Instructor',
                child: SpeedDial(
                  icon: Icons.mode_edit_rounded,
                  activeIcon: CupertinoIcons.multiply,
                  foregroundColor: ReusableWidgets.colorLight,
                  overlayColor: ReusableWidgets.colorDark,
                  overlayOpacity: 0.5,
                  children: speedDialChildren,
                ),
              );
          }
        },
      ),
    );
  }

  Widget courseCard(
      BuildContext context,
      String courseID,
      String courseName,
      String deptName,
      String credit,
      String sectionID,
      String semester,
      String year,
      String instructorName,
      String instructorSurname) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 3.0),
      child: InkWell(
        onTap: () {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => CoursePage(
                courseID: courseID,
                courseName: courseName,
                courseDeptName: deptName,
                courseCredit: credit,
                courseSectionID: sectionID,
                courseSemester: semester,
                courseYear: year,
                instructorName: instructorName,
                instructorSurname: instructorSurname,
              ),
            ),
          );
        },
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            gradient: LinearGradient(
              begin: Alignment.topRight,
              end: Alignment.bottomLeft,
              stops: const [
                0.1,
                0.4,
                0.6,
                0.9,
              ],
              colors: [
                ReusableWidgets.colorGrades,
                ReusableWidgets.colorPeople,
                ReusableWidgets.colorAssignment,
                ReusableWidgets.colorAnnouncement,
              ],
            ),
          ),
          child: Card(
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
            color: ReusableWidgets.colorLight,
            elevation: 2.0,
            child: Container(
              margin: const EdgeInsets.all(8.0),
              width: double.infinity,
              child: Stack(
                children: [
                  Column(
                    children: [
                      Text(
                        courseID,
                        style: const TextStyle(
                          color: Colors.grey,
                        ),
                      ),
                      const SizedBox(
                        height: 3.0,
                      ),
                      Text(
                        courseName,
                        style: TextStyle(
                          color: ReusableWidgets.colorDark,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(
                        height: 10.0,
                      ),
                      const Divider(
                        color: Colors.grey,
                        //color of divider
                        height: 5,
                        //height spacing of divider
                        thickness: 2.0,
                        //thickness of divider line
                        indent: 5,
                        //spacing at the start of divider
                        endIndent: 5, //spacing at the end of divider
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          IconButton(
                            onPressed: () {
                              Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (context) => AnnouncementPage(
                                    courseID: courseID,
                                    courseSectionID: sectionID,
                                    courseSemester: semester,
                                    courseYear: year,
                                    courseName: courseName,
                                  ),
                                ),
                              );
                            },
                            icon: Icon(
                              //CupertinoIcons.news_solid,
                              Icons.announcement_rounded,
                              color: ReusableWidgets.colorAnnouncement,
                            ),
                            tooltip: "announcements",
                          ),
                          IconButton(
                            onPressed: () {
                              Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (context) => AssignmentPage(
                                    courseID: courseID,
                                    courseSectionID: sectionID,
                                    courseSemester: semester,
                                    courseYear: year,
                                    courseName: courseName,
                                  ),
                                ),
                              );
                            },
                            icon: Icon(
                              Icons.assignment_outlined,
                              color: ReusableWidgets.colorAssignment,
                            ),
                            tooltip: "assignments",
                          ),
                          IconButton(
                            onPressed: () {
                              Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (context) => PeoplePage(
                                    courseID: courseID,
                                    sectionID: sectionID,
                                    semester: semester,
                                    year: year,
                                  ),
                                ),
                              );
                            },
                            icon: Icon(
                              CupertinoIcons.person_2_fill,
                              color: ReusableWidgets.colorPeople,
                            ),
                            tooltip: "people",
                          ),
                          IconButton(
                            onPressed: () {
                              Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (context) => GradePage(
                                    courseID: courseID,
                                    sectionID: sectionID,
                                    semester: semester,
                                    year: year,
                                  ),
                                ),
                              );
                            },
                            icon: Icon(
                              CupertinoIcons.chart_bar_alt_fill,
                              color: ReusableWidgets.colorGrades,
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
      ),
    );
  }

  List<SpeedDialChild> speedDialChildren = [];

  Future<void> initializeSpeedDialChildren() async {
    await getCourses();
    speedDialChildren = [];
    speedDialChildren.add(
      SpeedDialChild(
          child: Icon(
            Icons.library_add_outlined,
            color: ReusableWidgets.colorDark,
            size: 30,
          ),
          label: 'Add Course',
          labelStyle: TextStyle(color: ReusableWidgets.colorDark),
          labelBackgroundColor: ReusableWidgets.colorLight,
          backgroundColor: ReusableWidgets.colorLight,
          onTap: () => showDialog(
              context: context,
              builder: (BuildContext context) {
                return AlertDialog(
                  backgroundColor: ReusableWidgets.colorLight,
                  shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(20.0))),
                  content: Stack(
                    children: [
                      SingleChildScrollView(
                        child: Column(
                          children: [
                            Align(
                              alignment: Alignment.center,
                              child: Text(
                                'Create a Course',
                                style: TextStyle(
                                  fontWeight: FontWeight.w800,
                                  fontSize: 24.0,
                                  color: ReusableWidgets.colorDark,
                                ),
                              ),
                            ),
                            const SizedBox(
                              height: 20.0,
                            ),
                            Form(
                              child: Column(
                                children: [
                                  TextFormField(
                                    onChanged: (value) {
                                      courseID = value;
                                    },
                                    keyboardType: TextInputType.name,
                                    decoration: InputDecoration(
                                      border: OutlineInputBorder(
                                        borderSide: BorderSide(
                                          width: 5,
                                          color: ReusableWidgets.colorDark,
                                        ),
                                        borderRadius:
                                            BorderRadius.circular(20.0),
                                      ),
                                      labelText: 'Course Code',
                                    ),
                                  ),
                                  const SizedBox(height: 15.0),
                                  TextFormField(
                                    onChanged: (value) {
                                      name = value;
                                    },
                                    keyboardType: TextInputType.name,
                                    decoration: InputDecoration(
                                        border: OutlineInputBorder(
                                          borderSide: BorderSide(
                                            width: 5,
                                            color: ReusableWidgets.colorDark,
                                          ),
                                          borderRadius:
                                              BorderRadius.circular(20.0),
                                        ),
                                        labelText: 'Course Name'),
                                  ),
                                  const SizedBox(height: 15.0),
                                  TextFormField(
                                    onChanged: (value) {
                                      deptName = value;
                                    },
                                    keyboardType: TextInputType.name,
                                    decoration: InputDecoration(
                                      border: OutlineInputBorder(
                                        borderSide: BorderSide(
                                          width: 5,
                                          color: ReusableWidgets.colorDark,
                                        ),
                                        borderRadius:
                                            BorderRadius.circular(20.0),
                                      ),
                                      labelText: 'Department Name',
                                    ),
                                  ),
                                  const SizedBox(height: 15.0),
                                  DropdownButtonFormField(
                                      dropdownColor: ReusableWidgets.colorLight,
                                      borderRadius: BorderRadius.circular(20),
                                      decoration: InputDecoration(
                                          border: OutlineInputBorder(
                                              borderRadius:
                                                  BorderRadius.circular(20),
                                              borderSide: BorderSide(
                                                  width: 1,
                                                  color: ReusableWidgets
                                                      .colorDark))),
                                      value: semester,
                                      items: semesters
                                          .map((item) => DropdownMenuItem(
                                                value: item,
                                                child: Text(item,
                                                    style: const TextStyle(
                                                        fontSize: 16)),
                                              ))
                                          .toList(),
                                      onChanged: (item) => setState(
                                            () => semester = item!,
                                          )),
                                  const SizedBox(height: 15.0),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      const Text(
                                        'Credits:  ',
                                        style: TextStyle(fontSize: 14),
                                      ),
                                      SizedBox(
                                        width: 65,
                                        child: DropdownButtonFormField(
                                            dropdownColor:
                                                ReusableWidgets.colorLight,
                                            borderRadius:
                                                BorderRadius.circular(20),
                                            decoration: InputDecoration(
                                                border: OutlineInputBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            20),
                                                    borderSide: BorderSide(
                                                        width: 1,
                                                        color: ReusableWidgets
                                                            .colorDark))),
                                            value: credit,
                                            items: credits
                                                .map((item) => DropdownMenuItem(
                                                      value: item,
                                                      child: Text('$item',
                                                          style:
                                                              const TextStyle(
                                                                  fontSize:
                                                                      14)),
                                                    ))
                                                .toList(),
                                            onChanged: (item) => setState(
                                                  () => credit = item!,
                                                )),
                                      ),
                                      const SizedBox(
                                        width: 10,
                                      ),
                                      const Text(
                                        'Year:  ',
                                        style: TextStyle(fontSize: 14),
                                      ),
                                      SizedBox(
                                        width: 86,
                                        child: DropdownButtonFormField(
                                            dropdownColor:
                                                ReusableWidgets.colorLight,
                                            borderRadius:
                                                BorderRadius.circular(20),
                                            decoration: InputDecoration(
                                                border: OutlineInputBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            20),
                                                    borderSide: BorderSide(
                                                        width: 1,
                                                        color: ReusableWidgets
                                                            .colorDark))),
                                            value: year,
                                            items: years
                                                .map((item) => DropdownMenuItem(
                                                      value: item,
                                                      child: Text('$item',
                                                          style:
                                                              const TextStyle(
                                                                  fontSize:
                                                                      14)),
                                                    ))
                                                .toList(),
                                            onChanged: (item) => setState(
                                                  () => year = item!,
                                                )),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 20.0),
                                  ElevatedButton(
                                    onPressed: () async {
                                      if (name != null &&
                                          courseID != null &&
                                          deptName != null &&
                                          semester != 'Select a semester') {
                                        int? id =
                                            await ReusableMethods.getUserId();
                                        await createCourse(
                                            id!,
                                            courseID!,
                                            name!,
                                            deptName!,
                                            credit,
                                            semester,
                                            year);
                                        setState(() {
                                          Navigator.of(context).pop();
                                        });
                                        ReusableWidgets.flushbar(
                                            "$courseID created successfully",
                                            context);
                                      } else if (name != null &&
                                          courseID != null &&
                                          deptName != null &&
                                          semester == 'Select a semester') {
                                        ReusableWidgets.flushbar(
                                            "Please select a semester",
                                            context);
                                      } else {
                                        ReusableWidgets.flushbar(
                                            "Please fill all necessary fields",
                                            context);
                                      }
                                    },
                                    style: ButtonStyle(
                                      shape: MaterialStateProperty.all<
                                          RoundedRectangleBorder>(
                                        RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(20.0),
                                        ),
                                      ),
                                      backgroundColor:
                                          MaterialStateProperty.all<Color>(
                                              Colors.transparent),
                                      // Set overlayColor to Colors.transparent to remove the purple shadow
                                      overlayColor:
                                          MaterialStateProperty.all<Color>(
                                              Colors.transparent),
                                      elevation:
                                          MaterialStateProperty.all<double>(0),
                                    ),
                                    child: Container(
                                      width: double.infinity,
                                      padding: const EdgeInsets.all(15),
                                      decoration: BoxDecoration(
                                        gradient: LinearGradient(
                                          colors: [
                                            ReusableWidgets.colorProfile1,
                                            ReusableWidgets.colorProfile2,
                                            ReusableWidgets.colorProfile3,
                                          ],
                                          begin: Alignment.centerLeft,
                                          end: Alignment.centerRight,
                                        ),
                                        borderRadius:
                                            BorderRadius.circular(20.0),
                                      ),
                                      child: const Align(
                                        alignment: Alignment.center,
                                        child: Text(
                                          'Create',
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 18,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                  //const SizedBox(height: 10.0),
                                ],
                              ),
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                );
              })),
    );

    if (courses.isNotEmpty) {
      speedDialChildren.add(
        SpeedDialChild(
            child: Icon(
              CupertinoIcons.person_badge_plus_fill,
              color: ReusableWidgets.colorDark,
              size: 28,
            ),
            label: 'Invite Student',
            labelStyle: TextStyle(color: ReusableWidgets.colorDark),
            labelBackgroundColor: ReusableWidgets.colorLight,
            backgroundColor: ReusableWidgets.colorLight,
            onTap: () => showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    backgroundColor: ReusableWidgets.colorLight,
                    shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(20.0))),
                    content: Stack(
                      children: [
                        SingleChildScrollView(
                          child: Column(
                            children: [
                              Align(
                                alignment: Alignment.center,
                                child: Text(
                                  'Invite a Student',
                                  style: TextStyle(
                                    fontWeight: FontWeight.w800,
                                    fontSize: 24.0,
                                    color: ReusableWidgets.colorDark,
                                  ),
                                ),
                              ),
                              const SizedBox(
                                height: 20.0,
                              ),
                              Form(
                                child: Column(
                                  children: [
                                    TextFormField(
                                      onChanged: (value) {
                                        studentMail = value;
                                      },
                                      keyboardType: TextInputType.name,
                                      decoration: InputDecoration(
                                        border: OutlineInputBorder(
                                          borderSide: BorderSide(
                                            width: 5,
                                            color: ReusableWidgets.colorDark,
                                          ),
                                          borderRadius:
                                              BorderRadius.circular(20.0),
                                        ),
                                        labelText: 'Student Mail',
                                      ),
                                    ),
                                    const SizedBox(height: 15.0),
                                    DropdownButtonFormField(
                                        dropdownColor:
                                            ReusableWidgets.colorLight,
                                        borderRadius: BorderRadius.circular(20),
                                        decoration: InputDecoration(
                                            border: OutlineInputBorder(
                                                borderRadius:
                                                    BorderRadius.circular(20),
                                                borderSide: BorderSide(
                                                    width: 1,
                                                    color: ReusableWidgets
                                                        .colorDark))),
                                        value: inviteCourseID,
                                        items: inviteCourses
                                            .map((item) => DropdownMenuItem(
                                                  value: item,
                                                  child: Text(item,
                                                      style: const TextStyle(
                                                          fontSize: 16)),
                                                ))
                                            .toList(),
                                        onChanged: (item) => setState(
                                              () => inviteCourseID = item!,
                                            )),
                                    const SizedBox(height: 20.0),
                                    ElevatedButton(
                                      onPressed: () async {
                                        if (studentMail != null &&
                                            inviteCourseID !=
                                                'Select a course') {
                                          if (ReusableMethods.isValidEmail(
                                              studentMail!)) {
                                            int? id = await ReusableMethods
                                                .getUserId();
                                            String inviteCourseSemester =
                                                await getInviteCourseSemester(
                                                    inviteCourseID);
                                            int inviteCourseYear =
                                                await getInviteCourseYear(
                                                    inviteCourseID);
                                            String inviteCourseSectionID =
                                                await getInviteCourseSectionID(
                                                    inviteCourseID);
                                            await getStudentMails(
                                                inviteCourseID,
                                                inviteCourseSectionID,
                                                inviteCourseSemester,
                                                inviteCourseYear.toString());
                                            if (studentMails
                                                .contains(studentMail)) {
                                              ReusableWidgets.flushbar(
                                                  "$studentMail is already enrolled in $inviteCourseID",
                                                  context);
                                            } else {
                                              await sendInvite(
                                                  id!,
                                                  studentMail!,
                                                  inviteCourseID,
                                                  inviteCourseSectionID,
                                                  inviteCourseSemester,
                                                  inviteCourseYear);
                                              setState(() {
                                                Navigator.of(context).pop();
                                              });
                                              ReusableWidgets.flushbar(
                                                  "Invite sent to $studentMail for $inviteCourseID",
                                                  context);
                                            }
                                          } else {
                                            ReusableWidgets.flushbar(
                                                "Student mail is badly formatted",
                                                context);
                                          }
                                        } else if (studentMail != null &&
                                            inviteCourseID ==
                                                'Select a course') {
                                          ReusableWidgets.flushbar(
                                              "Please select a course",
                                              context);
                                        } else {
                                          ReusableWidgets.flushbar(
                                              "Please fill all necessary fields",
                                              context);
                                        }
                                      },
                                      style: ButtonStyle(
                                        shape: MaterialStateProperty.all<
                                            RoundedRectangleBorder>(
                                          RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(20.0),
                                          ),
                                        ),
                                        backgroundColor:
                                            MaterialStateProperty.all<Color>(
                                                Colors.transparent),
                                        // Set overlayColor to Colors.transparent to remove the purple shadow
                                        overlayColor:
                                            MaterialStateProperty.all<Color>(
                                                Colors.transparent),
                                        elevation:
                                            MaterialStateProperty.all<double>(
                                                0),
                                      ),
                                      child: Container(
                                        width: double.infinity,
                                        padding: const EdgeInsets.all(15),
                                        decoration: BoxDecoration(
                                          gradient: LinearGradient(
                                            colors: [
                                              ReusableWidgets.colorProfile1,
                                              ReusableWidgets.colorProfile2,
                                              ReusableWidgets.colorProfile3,
                                            ],
                                            begin: Alignment.centerLeft,
                                            end: Alignment.centerRight,
                                          ),
                                          borderRadius:
                                              BorderRadius.circular(20.0),
                                        ),
                                        child: const Align(
                                          alignment: Alignment.center,
                                          child: Text(
                                            'Invite',
                                            style: TextStyle(
                                              color: Colors.white,
                                              fontWeight: FontWeight.bold,
                                              fontSize: 18,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                    //const SizedBox(height: 10.0),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        )
                      ],
                    ),
                  );
                })),
      );
      speedDialChildren.add(
        SpeedDialChild(
            child: Icon(
              CupertinoIcons.person_badge_minus_fill,
              color: ReusableWidgets.colorDark,
              size: 28,
            ),
            label: 'Remove Student',
            labelStyle: TextStyle(color: ReusableWidgets.colorDark),
            labelBackgroundColor: ReusableWidgets.colorLight,
            backgroundColor: ReusableWidgets.colorLight,
            onTap: () => showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    backgroundColor: ReusableWidgets.colorLight,
                    shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(20.0))),
                    content: Stack(
                      children: [
                        SingleChildScrollView(
                          child: Column(
                            children: [
                              Align(
                                alignment: Alignment.center,
                                child: Text(
                                  'Remove a Student',
                                  style: TextStyle(
                                    fontWeight: FontWeight.w800,
                                    fontSize: 24.0,
                                    color: ReusableWidgets.colorDark,
                                  ),
                                ),
                              ),
                              const SizedBox(
                                height: 20.0,
                              ),
                              Form(
                                child: Column(
                                  children: [
                                    TextFormField(
                                      onChanged: (value) {
                                        studentMail = value;
                                      },
                                      keyboardType: TextInputType.name,
                                      decoration: InputDecoration(
                                        border: OutlineInputBorder(
                                          borderSide: BorderSide(
                                            width: 5,
                                            color: ReusableWidgets.colorDark,
                                          ),
                                          borderRadius:
                                              BorderRadius.circular(20.0),
                                        ),
                                        labelText: 'Student Mail',
                                      ),
                                    ),
                                    const SizedBox(height: 15.0),
                                    DropdownButtonFormField(
                                        dropdownColor:
                                            ReusableWidgets.colorLight,
                                        borderRadius: BorderRadius.circular(20),
                                        decoration: InputDecoration(
                                            border: OutlineInputBorder(
                                                borderRadius:
                                                    BorderRadius.circular(20),
                                                borderSide: BorderSide(
                                                    width: 1,
                                                    color: ReusableWidgets
                                                        .colorDark))),
                                        value: removeCourseID,
                                        items: inviteCourses
                                            .map((item) => DropdownMenuItem(
                                                  value: item,
                                                  child: Text(item,
                                                      style: const TextStyle(
                                                          fontSize: 16)),
                                                ))
                                            .toList(),
                                        onChanged: (item) => setState(
                                              () => removeCourseID = item!,
                                            )),
                                    const SizedBox(height: 20.0),
                                    ElevatedButton(
                                      onPressed: () async {
                                        if (studentMail != null &&
                                            removeCourseID !=
                                                'Select a course') {
                                          if (ReusableMethods.isValidEmail(
                                              studentMail!)) {
                                            String removeCourseSemester =
                                                await getInviteCourseSemester(
                                                    removeCourseID);
                                            int removeCourseYear =
                                                await getInviteCourseYear(
                                                    removeCourseID);
                                            String removeCourseSectionID =
                                                await getInviteCourseSectionID(
                                                    removeCourseID);
                                            await getStudentMails(
                                                removeCourseID,
                                                removeCourseSectionID,
                                                removeCourseSemester,
                                                removeCourseYear.toString());
                                            if (studentMails
                                                .contains(studentMail)) {
                                              await removeStudent(
                                                  studentMail!,
                                                  removeCourseID,
                                                  removeCourseSectionID,
                                                  removeCourseSemester,
                                                  removeCourseYear);
                                              setState(() {
                                                Navigator.of(context).pop();
                                              });
                                              ReusableWidgets.flushbar(
                                                  "$studentMail removed from $removeCourseID",
                                                  context);
                                            } else {
                                              ReusableWidgets.flushbar(
                                                  "$studentMail cannot be removed since it doesn't exist in $removeCourseID",
                                                  context);
                                            }
                                          } else {
                                            ReusableWidgets.flushbar(
                                                "Student mail is badly formatted",
                                                context);
                                          }
                                        } else if (studentMail != null &&
                                            removeCourseID ==
                                                'Select a course') {
                                          ReusableWidgets.flushbar(
                                              "Please select a course",
                                              context);
                                        } else {
                                          ReusableWidgets.flushbar(
                                              "Please fill all necessary fields",
                                              context);
                                        }
                                      },
                                      style: ButtonStyle(
                                        shape: MaterialStateProperty.all<
                                            RoundedRectangleBorder>(
                                          RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(20.0),
                                          ),
                                        ),
                                        backgroundColor:
                                            MaterialStateProperty.all<Color>(
                                                Colors.transparent),
                                        // Set overlayColor to Colors.transparent to remove the purple shadow
                                        overlayColor:
                                            MaterialStateProperty.all<Color>(
                                                Colors.transparent),
                                        elevation:
                                            MaterialStateProperty.all<double>(
                                                0),
                                      ),
                                      child: Container(
                                        width: double.infinity,
                                        padding: const EdgeInsets.all(15),
                                        decoration: BoxDecoration(
                                          gradient: LinearGradient(
                                            colors: [
                                              ReusableWidgets.colorProfile1,
                                              ReusableWidgets.colorProfile2,
                                              ReusableWidgets.colorProfile3,
                                            ],
                                            begin: Alignment.centerLeft,
                                            end: Alignment.centerRight,
                                          ),
                                          borderRadius:
                                              BorderRadius.circular(20.0),
                                        ),
                                        child: const Align(
                                          alignment: Alignment.center,
                                          child: Text(
                                            'Remove',
                                            style: TextStyle(
                                              color: Colors.white,
                                              fontWeight: FontWeight.bold,
                                              fontSize: 18,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                    //const SizedBox(height: 10.0),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        )
                      ],
                    ),
                  );
                })),
      );
      speedDialChildren.add(
        SpeedDialChild(
            child: Icon(
              Icons.announcement_rounded,
              color: ReusableWidgets.colorDark,
              size: 30,
            ),
            label: 'Make Announcement',
            labelStyle: TextStyle(color: ReusableWidgets.colorDark),
            labelBackgroundColor: ReusableWidgets.colorLight,
            backgroundColor: ReusableWidgets.colorLight,
            onTap: () => showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    backgroundColor: ReusableWidgets.colorLight,
                    shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(20.0))),
                    content: Stack(
                      children: [
                        SingleChildScrollView(
                          child: Column(
                            children: [
                              Align(
                                alignment: Alignment.center,
                                child: Text(
                                  'Make an Announcement',
                                  style: TextStyle(
                                    fontWeight: FontWeight.w800,
                                    fontSize: 24.0,
                                    color: ReusableWidgets.colorDark,
                                  ),
                                ),
                              ),
                              const SizedBox(
                                height: 20.0,
                              ),
                              Form(
                                child: Column(
                                  children: [
                                    DropdownButtonFormField(
                                        dropdownColor:
                                            ReusableWidgets.colorLight,
                                        borderRadius: BorderRadius.circular(20),
                                        decoration: InputDecoration(
                                            border: OutlineInputBorder(
                                                borderRadius:
                                                    BorderRadius.circular(20),
                                                borderSide: BorderSide(
                                                    width: 1,
                                                    color: ReusableWidgets
                                                        .colorDark))),
                                        value: inviteCourseID,
                                        items: inviteCourses
                                            .map((item) => DropdownMenuItem(
                                                  value: item,
                                                  child: Text(item,
                                                      style: const TextStyle(
                                                          fontSize: 16)),
                                                ))
                                            .toList(),
                                        onChanged: (item) => setState(
                                              () => inviteCourseID = item!,
                                            )),
                                    const SizedBox(height: 20.0),
                                    TextFormField(
                                      onChanged: (value) {
                                        announcementTitle = value;
                                      },
                                      keyboardType: TextInputType.name,
                                      maxLines: null,
                                      maxLength: 80,
                                      decoration: InputDecoration(
                                        border: OutlineInputBorder(
                                          borderSide: BorderSide(
                                            width: 5,
                                            color: ReusableWidgets.colorDark,
                                          ),
                                          borderRadius:
                                              BorderRadius.circular(20.0),
                                        ),
                                        labelText: 'Title',
                                      ),
                                    ),
                                    const SizedBox(height: 15.0),
                                    TextFormField(
                                      onChanged: (value) {
                                        announcementContent = value;
                                      },
                                      keyboardType: TextInputType.name,
                                      minLines: 3,
                                      maxLines: null,
                                      maxLength: 400,
                                      decoration: InputDecoration(
                                        border: OutlineInputBorder(
                                          borderSide: BorderSide(
                                            width: 5,
                                            color: ReusableWidgets.colorDark,
                                          ),
                                          borderRadius:
                                              BorderRadius.circular(20.0),
                                        ),
                                        alignLabelWithHint:
                                            true, // Add this line to align the hint text with the top
                                        labelText:
                                            'Enter your announcement here',
                                      ),
                                    ),
                                    const SizedBox(height: 20.0),
                                    ElevatedButton(
                                      onPressed: () async {
                                        if (announcementContent != null &&
                                            announcementTitle != null &&
                                            inviteCourseID !=
                                                'Select a course') {
                                          String inviteCourseSemester =
                                              await getInviteCourseSemester(
                                                  inviteCourseID);
                                          int inviteCourseYear =
                                              await getInviteCourseYear(
                                                  inviteCourseID);
                                          String inviteCourseSectionID =
                                              await getInviteCourseSectionID(
                                                  inviteCourseID);
                                          await publishAnnouncement(
                                            inviteCourseID,
                                            inviteCourseSectionID,
                                            inviteCourseSemester,
                                            inviteCourseYear,
                                            announcementTitle!,
                                            announcementContent!,
                                            DateTime.now().toString(),
                                          );
                                          setState(() {
                                            Navigator.of(context).pop();
                                          });
                                          ReusableWidgets.flushbar(
                                              "Announcement published in $inviteCourseID",
                                              context);
                                        } else if (announcementContent !=
                                                null &&
                                            announcementTitle != null &&
                                            inviteCourseID ==
                                                'Select a course') {
                                          ReusableWidgets.flushbar(
                                              "Please select a course",
                                              context);
                                        } else {
                                          ReusableWidgets.flushbar(
                                              "Please fill all necessary fields",
                                              context);
                                        }
                                      },
                                      style: ButtonStyle(
                                        shape: MaterialStateProperty.all<
                                            RoundedRectangleBorder>(
                                          RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(20.0),
                                          ),
                                        ),
                                        backgroundColor:
                                            MaterialStateProperty.all<Color>(
                                                Colors.transparent),
                                        // Set overlayColor to Colors.transparent to remove the purple shadow
                                        overlayColor:
                                            MaterialStateProperty.all<Color>(
                                                Colors.transparent),
                                        elevation:
                                            MaterialStateProperty.all<double>(
                                                0),
                                      ),
                                      child: Container(
                                        width: double.infinity,
                                        padding: const EdgeInsets.all(15),
                                        decoration: BoxDecoration(
                                          gradient: LinearGradient(
                                            colors: [
                                              ReusableWidgets.colorProfile1,
                                              ReusableWidgets.colorProfile2,
                                              ReusableWidgets.colorProfile3,
                                            ],
                                            begin: Alignment.centerLeft,
                                            end: Alignment.centerRight,
                                          ),
                                          borderRadius:
                                              BorderRadius.circular(20.0),
                                        ),
                                        child: const Align(
                                          alignment: Alignment.center,
                                          child: Text(
                                            'Publish',
                                            style: TextStyle(
                                              color: Colors.white,
                                              fontWeight: FontWeight.bold,
                                              fontSize: 18,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                    //const SizedBox(height: 10.0),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        )
                      ],
                    ),
                  );
                })),
      );
      speedDialChildren.add(
        SpeedDialChild(
            child: Icon(
              Icons.assignment_outlined,
              color: ReusableWidgets.colorDark,
              size: 30,
            ),
            label: 'Create Assignment',
            labelStyle: TextStyle(color: ReusableWidgets.colorDark),
            labelBackgroundColor: ReusableWidgets.colorLight,
            backgroundColor: ReusableWidgets.colorLight,
            onTap: () => showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    backgroundColor: ReusableWidgets.colorLight,
                    shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(20.0))),
                    content: Stack(
                      children: [
                        SingleChildScrollView(
                          child: Column(
                            children: [
                              Align(
                                alignment: Alignment.center,
                                child: Text(
                                  'Create an Assignment',
                                  style: TextStyle(
                                    fontWeight: FontWeight.w800,
                                    fontSize: 24.0,
                                    color: ReusableWidgets.colorDark,
                                  ),
                                ),
                              ),
                              const SizedBox(
                                height: 20.0,
                              ),
                              Form(
                                child: Column(
                                  children: [
                                    DropdownButtonFormField(
                                        dropdownColor:
                                            ReusableWidgets.colorLight,
                                        borderRadius: BorderRadius.circular(20),
                                        decoration: InputDecoration(
                                            border: OutlineInputBorder(
                                                borderRadius:
                                                    BorderRadius.circular(20),
                                                borderSide: BorderSide(
                                                    width: 1,
                                                    color: ReusableWidgets
                                                        .colorDark))),
                                        value: inviteCourseID,
                                        items: inviteCourses
                                            .map((item) => DropdownMenuItem(
                                                  value: item,
                                                  child: Text(item,
                                                      style: const TextStyle(
                                                          fontSize: 16)),
                                                ))
                                            .toList(),
                                        onChanged: (item) => setState(
                                              () => inviteCourseID = item!,
                                            )),
                                    const SizedBox(height: 20.0),
                                    TextFormField(
                                      onChanged: (value) {
                                        assignmentTitle = value;
                                      },
                                      keyboardType: TextInputType.name,
                                      maxLines: null,
                                      maxLength: 80,
                                      decoration: InputDecoration(
                                        border: OutlineInputBorder(
                                          borderSide: BorderSide(
                                            width: 5,
                                            color: ReusableWidgets.colorDark,
                                          ),
                                          borderRadius:
                                              BorderRadius.circular(20.0),
                                        ),
                                        labelText: 'Title',
                                      ),
                                    ),
                                    const SizedBox(height: 15.0),
                                    TextFormField(
                                      onChanged: (value) {
                                        assignmentContent = value;
                                      },
                                      keyboardType: TextInputType.name,
                                      minLines: 3,
                                      maxLines: null,
                                      maxLength: 400,
                                      decoration: InputDecoration(
                                        border: OutlineInputBorder(
                                          borderSide: BorderSide(
                                            width: 5,
                                            color: ReusableWidgets.colorDark,
                                          ),
                                          borderRadius:
                                              BorderRadius.circular(20.0),
                                        ),
                                        alignLabelWithHint:
                                            true, // Add this line to align the hint text with the top
                                        labelText: 'Enter your assignment here',
                                      ),
                                    ),
                                    const SizedBox(height: 15.0),
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          'Select a due date',
                                          style: TextStyle(
                                            color: Colors.grey.shade600,
                                            fontSize: 14,
                                          ),
                                          textAlign: TextAlign.left,
                                        ),
                                        const SizedBox(height: 4.0),
                                        SizedBox(
                                          height: 100,
                                          child: Container(
                                            decoration: BoxDecoration(
                                              border: Border.all(
                                                color: Colors.grey,
                                                width: 1,
                                              ),
                                              borderRadius:
                                                  BorderRadius.circular(20.0),
                                            ),
                                            child: CupertinoTheme(
                                              data: CupertinoThemeData(
                                                textTheme:
                                                    CupertinoTextThemeData(
                                                  dateTimePickerTextStyle:
                                                      TextStyle(
                                                    color: ReusableWidgets
                                                        .colorDark,
                                                    fontSize: 15,
                                                  ),
                                                ),
                                              ),
                                              child: CupertinoDatePicker(
                                                minimumDate: DateTime.now()
                                                    .subtract(const Duration(
                                                        minutes: 2)),
                                                use24hFormat: true,
                                                initialDateTime:
                                                    assignmentDueDate,
                                                onDateTimeChanged: (value) {
                                                  setState(() {
                                                    assignmentDueDate = value;
                                                    isDateSelected = true;
                                                  });
                                                },
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 20.0),
                                    ElevatedButton(
                                      onPressed: () async {
                                        if (assignmentContent != null &&
                                            assignmentTitle != null &&
                                            inviteCourseID !=
                                                'Select a course') {
                                          String inviteCourseSemester =
                                              await getInviteCourseSemester(
                                                  inviteCourseID);
                                          int inviteCourseYear =
                                              await getInviteCourseYear(
                                                  inviteCourseID);
                                          String inviteCourseSectionID =
                                              await getInviteCourseSectionID(
                                                  inviteCourseID);
                                          await publishAssignment(
                                            inviteCourseID,
                                            inviteCourseSectionID,
                                            inviteCourseSemester,
                                            inviteCourseYear,
                                            assignmentTitle!,
                                            assignmentContent!,
                                            DateTime.now().toString(),
                                            assignmentDueDate.toString(),
                                          );
                                          setState(() {
                                            Navigator.of(context).pop();
                                          });
                                          ReusableWidgets.flushbar(
                                              "Assignment published in $inviteCourseID",
                                              context);
                                        } else if (assignmentContent != null &&
                                            assignmentTitle != null &&
                                            inviteCourseID ==
                                                'Select a course') {
                                          ReusableWidgets.flushbar(
                                              "Please select a course",
                                              context);
                                        } else {
                                          ReusableWidgets.flushbar(
                                              "Please fill all necessary fields",
                                              context);
                                        }
                                      },
                                      style: ButtonStyle(
                                        shape: MaterialStateProperty.all<
                                            RoundedRectangleBorder>(
                                          RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(20.0),
                                          ),
                                        ),
                                        backgroundColor:
                                            MaterialStateProperty.all<Color>(
                                                Colors.transparent),
                                        // Set overlayColor to Colors.transparent to remove the purple shadow
                                        overlayColor:
                                            MaterialStateProperty.all<Color>(
                                                Colors.transparent),
                                        elevation:
                                            MaterialStateProperty.all<double>(
                                                0),
                                      ),
                                      child: Container(
                                        width: double.infinity,
                                        padding: const EdgeInsets.all(15),
                                        decoration: BoxDecoration(
                                          gradient: LinearGradient(
                                            colors: [
                                              ReusableWidgets.colorProfile1,
                                              ReusableWidgets.colorProfile2,
                                              ReusableWidgets.colorProfile3,
                                            ],
                                            begin: Alignment.centerLeft,
                                            end: Alignment.centerRight,
                                          ),
                                          borderRadius:
                                              BorderRadius.circular(20.0),
                                        ),
                                        child: const Align(
                                          alignment: Alignment.center,
                                          child: Text(
                                            'Publish',
                                            style: TextStyle(
                                              color: Colors.white,
                                              fontWeight: FontWeight.bold,
                                              fontSize: 18,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        )
                      ],
                    ),
                  );
                })),
      );
      speedDialChildren = speedDialChildren.reversed.toList();
    }
  }
}
