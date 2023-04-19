import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_flushbar/flutter_flushbar.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;
import 'package:graded/models/home_notification.dart' as N;
import 'package:graded/resources/reusable_methods.dart';
import 'package:hidden_drawer_menu/controllers/simple_hidden_drawer_controller.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _index = 0;

  late List<dynamic> courses;
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
  List<String> inviteCourses = ['Select a course'];

  late int instructorID;
  String? courseID;
  String? name;
  String? deptName;
  int credit = 0;
  String semester = 'Select a semester';
  int year = 2020;
  String? studentMail;
  String inviteCourseID = 'Select a course';

  Future<List<dynamic>> getCourses() async {
    int? id = await ReusableMethods.getUserId();
    await ReusableMethods.getRole();

    // Construct the URL with the instructor ID
    String url =
        'http://10.0.2.2/graded/getcoursesbyinstructorid.php?instructorID=$id';

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

      //print(courses);
      // Return the list of courses
      return courses;
    } else {
      // If the response is not successful
      print('Failed to get courses. Status code: ${response.statusCode}');
      return [];
    }
  }

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

      // Send a POST request to the createcourse.php file on server
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

  Future<void> sendInvite(
      int parInstructorID,
      String parStudentEmail,
      String parCourseID,
      String parSectionID,
      String parSemester,
      int parYear) async {
    try {
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

  static String formatDate(DateTime date) =>
      DateFormat("MMMM d - hh:mm").format(date);

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
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(
            CupertinoIcons.bars,
            color: ReusableMethods.colorLight,
          ),
          onPressed: () {
            SimpleHiddenDrawerController.of(context).open();
          },
        ),
        title: Text(
          "Home",
          style: TextStyle(
            color: ReusableMethods.colorLight,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
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
                                    CupertinoIcons.bell,
                                    size: 30,
                                    color: ReusableMethods.colorDark,
                                  ),
                                  const SizedBox(
                                    width: 8,
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
                                    icon: const Icon(CupertinoIcons.forward),
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
                                    CupertinoIcons.collections,
                                    color: ReusableMethods.colorDark,
                                  ),
                                  const SizedBox(
                                    width: 8,
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
                                    icon: const Icon(CupertinoIcons.forward),
                                    color: ReusableMethods.colorDark,
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
                                    child: CircularProgressIndicator(
                                      backgroundColor:
                                          ReusableMethods.colorLight,
                                      color: ReusableMethods.colorDark,
                                    ),
                                  );
                                default:
                                  return courses.isEmpty
                                      ? Image.asset(
                                          '${ReusableMethods.getRole()}' ==
                                                  "Instructor"
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
                                                courses[i]['name']);
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
        future: ReusableMethods.getRole(),
        builder: (context, AsyncSnapshot<void> snapshot) {
          if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}');
          }
          switch (snapshot.connectionState) {
            case ConnectionState.waiting:
              return const Text("");
            default:
              return Visibility(
                visible: '${ReusableMethods.getRole()}' == 'Instructor',
                child: SpeedDial(
                  icon: CupertinoIcons.add,
                  activeIcon: CupertinoIcons.multiply,
                  foregroundColor: ReusableMethods.colorLight,
                  overlayColor: ReusableMethods.colorDark,
                  overlayOpacity: 0.5,
                  children: [
                    SpeedDialChild(
                        child: Icon(
                          CupertinoIcons.person_add_solid,
                          color: ReusableMethods.colorDark,
                          size: 28,
                        ),
                        label: 'Invite Student',
                        labelStyle: TextStyle(color: ReusableMethods.colorDark),
                        labelBackgroundColor: ReusableMethods.colorLight,
                        backgroundColor: ReusableMethods.colorLight,
                        onTap: () => showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return AlertDialog(
                                backgroundColor: ReusableMethods.colorLight,
                                shape: const RoundedRectangleBorder(
                                    borderRadius: BorderRadius.all(
                                        Radius.circular(20.0))),
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
                                                color:
                                                    ReusableMethods.colorDark,
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
                                                  keyboardType:
                                                      TextInputType.name,
                                                  decoration: InputDecoration(
                                                    border: OutlineInputBorder(
                                                      borderSide: BorderSide(
                                                        width: 5,
                                                        color: ReusableMethods
                                                            .colorDark,
                                                      ),
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              20.0),
                                                    ),
                                                    labelText: 'Student Mail',
                                                  ),
                                                ),
                                                const SizedBox(height: 15.0),
                                                DropdownButtonFormField(
                                                    dropdownColor:
                                                        ReusableMethods
                                                            .colorLight,
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            20),
                                                    decoration: InputDecoration(
                                                        border: OutlineInputBorder(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        20),
                                                            borderSide: BorderSide(
                                                                width: 1,
                                                                color: ReusableMethods
                                                                    .colorDark))),
                                                    value: inviteCourseID,
                                                    items: inviteCourses
                                                        .map((item) =>
                                                            DropdownMenuItem(
                                                              value: item,
                                                              child: Text(
                                                                  '$item',
                                                                  style: const TextStyle(
                                                                      fontSize:
                                                                          16)),
                                                            ))
                                                        .toList(),
                                                    onChanged: (item) =>
                                                        setState(
                                                          () => inviteCourseID =
                                                              item!,
                                                        )),
                                                const SizedBox(height: 20.0),
                                                ElevatedButton(
                                                  onPressed: () async {
                                                    if (studentMail != null &&
                                                        inviteCourseID !=
                                                            'Select a course') {
                                                      if (ReusableMethods
                                                          .isValidEmail(
                                                              studentMail!)) {
                                                        int? id =
                                                            await ReusableMethods
                                                                .getUserId();
                                                        String
                                                            inviteCourseSemester =
                                                            await getInviteCourseSemester(
                                                                inviteCourseID);
                                                        int inviteCourseYear =
                                                            await getInviteCourseYear(
                                                                inviteCourseID);
                                                        String
                                                            inviteCourseSectionID =
                                                            await getInviteCourseSectionID(
                                                                inviteCourseID);
                                                        await sendInvite(
                                                            id!,
                                                            studentMail!,
                                                            inviteCourseID,
                                                            inviteCourseSectionID,
                                                            inviteCourseSemester,
                                                            inviteCourseYear);
                                                        // ignore: use_build_context_synchronously
                                                        setState(() {
                                                          Navigator.of(context)
                                                              .pop();
                                                        });
                                                        // ignore: use_build_context_synchronously
                                                        Flushbar(
                                                          message:
                                                              "Invite sent to $studentMail for $inviteCourseID",
                                                          duration:
                                                              const Duration(
                                                                  seconds: 3),
                                                          margin:
                                                              EdgeInsets.only(
                                                                  // ignore: use_build_context_synchronously
                                                                  bottom: MediaQuery.of(
                                                                              context)
                                                                          .viewInsets
                                                                          .bottom +
                                                                      20),
                                                        ).show(context);
                                                      } else {
                                                        Flushbar(
                                                          message:
                                                              "Student mail is badly formatted.",
                                                          duration:
                                                              const Duration(
                                                                  seconds: 3),
                                                          margin:
                                                              EdgeInsets.only(
                                                                  // ignore: use_build_context_synchronously
                                                                  bottom: MediaQuery.of(
                                                                              context)
                                                                          .viewInsets
                                                                          .bottom +
                                                                      20),
                                                        ).show(context);
                                                      }
                                                    } else if (studentMail !=
                                                            null &&
                                                        inviteCourseID ==
                                                            'Select a course') {
                                                      Flushbar(
                                                        message:
                                                            "Please select a course.",
                                                        duration:
                                                            const Duration(
                                                                seconds: 3),
                                                        margin: EdgeInsets.only(
                                                            bottom: MediaQuery.of(
                                                                        context)
                                                                    .viewInsets
                                                                    .bottom +
                                                                20),
                                                      ).show(context);
                                                    }
                                                  },
                                                  style: ButtonStyle(
                                                    shape: MaterialStateProperty
                                                        .all<
                                                            RoundedRectangleBorder>(
                                                      RoundedRectangleBorder(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(20.0),
                                                      ),
                                                    ),
                                                    backgroundColor:
                                                        MaterialStateProperty
                                                            .all<Color>(Colors
                                                                .transparent),
                                                    // Set overlayColor to Colors.transparent to remove the purple shadow
                                                    overlayColor:
                                                        MaterialStateProperty
                                                            .all<Color>(Colors
                                                                .transparent),
                                                    elevation:
                                                        MaterialStateProperty
                                                            .all<double>(0),
                                                  ),
                                                  child: Container(
                                                    width: double.infinity,
                                                    padding:
                                                        const EdgeInsets.all(
                                                            15),
                                                    decoration: BoxDecoration(
                                                      gradient: LinearGradient(
                                                        colors: [
                                                          ReusableMethods
                                                              .colorProfile1,
                                                          ReusableMethods
                                                              .colorProfile2,
                                                          ReusableMethods
                                                              .colorProfile3,
                                                        ],
                                                        begin: Alignment
                                                            .centerLeft,
                                                        end: Alignment
                                                            .centerRight,
                                                      ),
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              20.0),
                                                    ),
                                                    child: const Align(
                                                      alignment:
                                                          Alignment.center,
                                                      child: Text(
                                                        'Invite',
                                                        style: TextStyle(
                                                          color: Colors.white,
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          fontSize: 18,
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                ), //const SizedBox(height: 10.0),
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
                    SpeedDialChild(
                        child: Icon(
                          Icons.library_add_outlined,
                          color: ReusableMethods.colorDark,
                          size: 30,
                        ),
                        label: 'Add Course',
                        labelStyle: TextStyle(color: ReusableMethods.colorDark),
                        labelBackgroundColor: ReusableMethods.colorLight,
                        backgroundColor: ReusableMethods.colorLight,
                        onTap: () => showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return AlertDialog(
                                backgroundColor: ReusableMethods.colorLight,
                                shape: const RoundedRectangleBorder(
                                    borderRadius: BorderRadius.all(
                                        Radius.circular(20.0))),
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
                                                color:
                                                    ReusableMethods.colorDark,
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
                                                  keyboardType:
                                                      TextInputType.name,
                                                  decoration: InputDecoration(
                                                    border: OutlineInputBorder(
                                                      borderSide: BorderSide(
                                                        width: 5,
                                                        color: ReusableMethods
                                                            .colorDark,
                                                      ),
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              20.0),
                                                    ),
                                                    labelText: 'Course Code',
                                                  ),
                                                ),
                                                const SizedBox(height: 15.0),
                                                TextFormField(
                                                  onChanged: (value) {
                                                    name = value;
                                                  },
                                                  keyboardType:
                                                      TextInputType.name,
                                                  decoration: InputDecoration(
                                                      border:
                                                          OutlineInputBorder(
                                                        borderSide: BorderSide(
                                                          width: 5,
                                                          color: ReusableMethods
                                                              .colorDark,
                                                        ),
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(20.0),
                                                      ),
                                                      labelText: 'Course Name'),
                                                ),
                                                const SizedBox(height: 15.0),
                                                TextFormField(
                                                  onChanged: (value) {
                                                    deptName = value;
                                                  },
                                                  keyboardType:
                                                      TextInputType.name,
                                                  decoration: InputDecoration(
                                                    border: OutlineInputBorder(
                                                      borderSide: BorderSide(
                                                        width: 5,
                                                        color: ReusableMethods
                                                            .colorDark,
                                                      ),
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              20.0),
                                                    ),
                                                    labelText:
                                                        'Department Name',
                                                  ),
                                                ),
                                                const SizedBox(height: 15.0),
                                                DropdownButtonFormField(
                                                    dropdownColor:
                                                        ReusableMethods
                                                            .colorLight,
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            20),
                                                    decoration: InputDecoration(
                                                        border: OutlineInputBorder(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        20),
                                                            borderSide: BorderSide(
                                                                width: 1,
                                                                color: ReusableMethods
                                                                    .colorDark))),
                                                    value: semester,
                                                    items: semesters
                                                        .map((item) =>
                                                            DropdownMenuItem(
                                                              value: item,
                                                              child: Text(item,
                                                                  style: const TextStyle(
                                                                      fontSize:
                                                                          16)),
                                                            ))
                                                        .toList(),
                                                    onChanged: (item) =>
                                                        setState(
                                                          () =>
                                                              semester = item!,
                                                        )),
                                                const SizedBox(height: 15.0),
                                                Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  children: [
                                                    const Text(
                                                      'Credits:  ',
                                                      style: TextStyle(
                                                          fontSize: 14),
                                                    ),
                                                    SizedBox(
                                                      width: 65,
                                                      child:
                                                          DropdownButtonFormField(
                                                              dropdownColor:
                                                                  ReusableMethods
                                                                      .colorLight,
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          20),
                                                              decoration: InputDecoration(
                                                                  border: OutlineInputBorder(
                                                                      borderRadius:
                                                                          BorderRadius.circular(
                                                                              20),
                                                                      borderSide: BorderSide(
                                                                          width:
                                                                              1,
                                                                          color: ReusableMethods
                                                                              .colorDark))),
                                                              value: credit,
                                                              items: credits
                                                                  .map((item) =>
                                                                      DropdownMenuItem(
                                                                        value:
                                                                            item,
                                                                        child: Text(
                                                                            '$item',
                                                                            style:
                                                                                const TextStyle(fontSize: 14)),
                                                                      ))
                                                                  .toList(),
                                                              onChanged:
                                                                  (item) =>
                                                                      setState(
                                                                        () => credit =
                                                                            item!,
                                                                      )),
                                                    ),
                                                    const SizedBox(
                                                      width: 10,
                                                    ),
                                                    const Text(
                                                      'Year:  ',
                                                      style: TextStyle(
                                                          fontSize: 14),
                                                    ),
                                                    SizedBox(
                                                      width: 86,
                                                      child:
                                                          DropdownButtonFormField(
                                                              dropdownColor:
                                                                  ReusableMethods
                                                                      .colorLight,
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          20),
                                                              decoration: InputDecoration(
                                                                  border: OutlineInputBorder(
                                                                      borderRadius:
                                                                          BorderRadius.circular(
                                                                              20),
                                                                      borderSide: BorderSide(
                                                                          width:
                                                                              1,
                                                                          color: ReusableMethods
                                                                              .colorDark))),
                                                              value: year,
                                                              items: years
                                                                  .map((item) =>
                                                                      DropdownMenuItem(
                                                                        value:
                                                                            item,
                                                                        child: Text(
                                                                            '$item',
                                                                            style:
                                                                                const TextStyle(fontSize: 14)),
                                                                      ))
                                                                  .toList(),
                                                              onChanged:
                                                                  (item) =>
                                                                      setState(
                                                                        () => year =
                                                                            item!,
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
                                                        semester !=
                                                            'Select a semester') {
                                                      int? id =
                                                          await ReusableMethods
                                                              .getUserId();
                                                      await createCourse(
                                                          id!,
                                                          courseID!,
                                                          name!,
                                                          deptName!,
                                                          credit,
                                                          semester,
                                                          year);
                                                      // ignore: use_build_context_synchronously
                                                      setState(() {
                                                        Navigator.of(context)
                                                            .pop();
                                                      });
                                                      // ignore: use_build_context_synchronously
                                                      Flushbar(
                                                        message:
                                                            "$courseID created successfully",
                                                        duration:
                                                            const Duration(
                                                                seconds: 3),
                                                        margin: EdgeInsets.only(
                                                            // ignore: use_build_context_synchronously
                                                            bottom: MediaQuery.of(
                                                                        context)
                                                                    .viewInsets
                                                                    .bottom +
                                                                20),
                                                      ).show(context);
                                                    } else if (name != null &&
                                                        courseID != null &&
                                                        deptName != null &&
                                                        semester ==
                                                            'Select a semester') {
                                                      Flushbar(
                                                        message:
                                                            "Please select a semester.",
                                                        duration:
                                                            const Duration(
                                                                seconds: 3),
                                                        margin: EdgeInsets.only(
                                                            bottom: MediaQuery.of(
                                                                        context)
                                                                    .viewInsets
                                                                    .bottom +
                                                                20),
                                                      ).show(context);
                                                    } else {
                                                      Flushbar(
                                                        message:
                                                            "Please fill all necessary fields.",
                                                        duration:
                                                            const Duration(
                                                                seconds: 3),
                                                        margin: EdgeInsets.only(
                                                            bottom: MediaQuery.of(
                                                                        context)
                                                                    .viewInsets
                                                                    .bottom +
                                                                20),
                                                      ).show(context);
                                                    }
                                                  },
                                                  style: ButtonStyle(
                                                    shape: MaterialStateProperty
                                                        .all<
                                                            RoundedRectangleBorder>(
                                                      RoundedRectangleBorder(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(20.0),
                                                      ),
                                                    ),
                                                    backgroundColor:
                                                        MaterialStateProperty
                                                            .all<Color>(Colors
                                                                .transparent),
                                                    // Set overlayColor to Colors.transparent to remove the purple shadow
                                                    overlayColor:
                                                        MaterialStateProperty
                                                            .all<Color>(Colors
                                                                .transparent),
                                                    elevation:
                                                        MaterialStateProperty
                                                            .all<double>(0),
                                                  ),
                                                  child: Container(
                                                    width: double.infinity,
                                                    padding:
                                                        const EdgeInsets.all(
                                                            15),
                                                    decoration: BoxDecoration(
                                                      gradient: LinearGradient(
                                                        colors: [
                                                          ReusableMethods
                                                              .colorProfile1,
                                                          ReusableMethods
                                                              .colorProfile2,
                                                          ReusableMethods
                                                              .colorProfile3,
                                                        ],
                                                        begin: Alignment
                                                            .centerLeft,
                                                        end: Alignment
                                                            .centerRight,
                                                      ),
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              20.0),
                                                    ),
                                                    child: const Align(
                                                      alignment:
                                                          Alignment.center,
                                                      child: Text(
                                                        'Create',
                                                        style: TextStyle(
                                                          color: Colors.white,
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          fontSize: 18,
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                ), //const SizedBox(height: 10.0),
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
                  ],
                ),
              );
          }
        },
      ),
    );
  }

  Widget courseCard(BuildContext context, String courseID, String courseName) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 3.0),
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
              ReusableMethods.colorGrades,
              ReusableMethods.colorPeople,
              ReusableMethods.colorAssignment,
              ReusableMethods.colorAnnouncement,
            ],
          ),
        ),
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
                            CupertinoIcons.person_2_fill,
                            color: ReusableMethods.colorPeople,
                          ),
                          tooltip: "people",
                        ),
                        IconButton(
                          onPressed: () {},
                          icon: Icon(
                            CupertinoIcons.chart_bar_alt_fill,
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
