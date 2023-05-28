// ignore_for_file: avoid_print
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:graded/resources/reusable_methods.dart';
import 'package:graded/resources/reusable_widgets.dart';
import 'package:http/http.dart' as http;
import 'package:hidden_drawer_menu/hidden_drawer_menu.dart';

class InvitationsPage extends StatefulWidget {
  const InvitationsPage({super.key});

  @override
  State<InvitationsPage> createState() => _InvitationsPageState();
}

class _InvitationsPageState extends State<InvitationsPage> {
  // text styles
  final textStyleKey = TextStyle(
    fontWeight: FontWeight.bold,
    fontSize: 18,
    color: ReusableWidgets.colorProfile1,
  );

  final textStyleValue = TextStyle(
      fontWeight: FontWeight.w600,
      fontSize: 18,
      color: ReusableWidgets.colorProfile3_1);

  // variables
  late String role;
  late List<dynamic> invitations;

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
      //print("$name - $surname - $deptName - $role - $mail");
    } else {
      return '-1';
      // If the response is not successful
      //print('Failed to get user info. Status code: ${response.statusCode}');
    }
  }

  Future<List<dynamic>> getInvitations() async {
    int? id = await ReusableMethods.getUserId();
    await getRole();

    // Construct the URL with the student ID
    String url = 'http://10.0.2.2/graded/getinvites.php?studentID=$id';

    // Make an HTTP GET request to the PHP script
    http.Response response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      // If the response is successful (status code 200)
      // Parse the response body as JSON
      invitations = json.decode(response.body);

      // Return the list of invitations
      return invitations;
    } else {
      // If the response is not successful
      print('Failed to get invitations. Status code: ${response.statusCode}');
      return [];
    }
  }

  // manipulation methods
  Future<void> updateInvites(
      int parInstructorID,
      int parStudentID,
      String parCourseID,
      String parSectionID,
      String parSemester,
      int parYear,
      int parStatus) async {
    try {
      // Prepare the request body as a Map
      final requestBody = {
        'instructorID': parInstructorID.toString(), // Convert to String
        'studentID': parStudentID.toString(),
        'courseID': parCourseID,
        'sectionID': parSectionID,
        'semester': parSemester,
        'year': parYear.toString(),
        'status': parStatus.toString()
      };

      // Send a POST request to the related file on server
      final response = await http.post(
        Uri.parse('http://10.0.2.2/graded/updateinvites.php'),
        body: requestBody,
      );

      if (response.statusCode == 200) {
        // Course created successfully
        print('Invitation responded successfully');
      } else {
        // Handle any errors from the server
        print('Failed to respond invitation: ${response.body}');
      }
    } catch (e) {
      // Handle any errors locally
      print('Failed to respond invitation: $e');
    }
  }

  String abbreviateDepartmentName(String departmentName) {
    List<String> words = departmentName.split(' ');
    String abbreviation = '';
    for (String word in words) {
      if (word.isNotEmpty) {
        abbreviation += word[0].toUpperCase();
      }
    }
    return abbreviation;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(
            CupertinoIcons.bars,
            color: ReusableWidgets.colorLight,
          ),
          onPressed: () {
            SimpleHiddenDrawerController.of(context).open();
          },
        ),
        title: Text(
          "Invitations",
          style: TextStyle(
            color: ReusableWidgets.colorLight,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      backgroundColor: ReusableWidgets.colorLight,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Center(
              child: Builder(builder: (context) {
                return FutureBuilder(
                  future: getInvitations(),
                  builder: (context, AsyncSnapshot<void> snapshot) {
                    if (snapshot.hasError) {
                      return Text('Error: ${snapshot.error}');
                    }
                    switch (snapshot.connectionState) {
                      case ConnectionState.waiting:
                        return SizedBox(
                          height: MediaQuery.of(context).size.height,
                          child: Center(
                            child: ReusableWidgets.loadingAnimation(
                                ReusableWidgets.colorDark),
                          ),
                        );
                      default:
                        return invitations.isEmpty
                            ? Image.asset(
                                'assets/images/no_invitation.png',
                                width: double.infinity,
                                fit: BoxFit.fill,
                              )
                            : ListView.builder(
                                shrinkWrap: true,
                                itemCount: invitations.length,
                                physics: const NeverScrollableScrollPhysics(),
                                itemBuilder: (context, index) {
                                  return Padding(
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 3.0),
                                    child: Container(
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(20),
                                        gradient: LinearGradient(
                                          begin: Alignment.topRight,
                                          end: Alignment.bottomLeft,
                                          stops: const [
                                            0.1,
                                            0.5,
                                            0.9,
                                          ],
                                          colors: [
                                            ReusableWidgets.colorProfile3_1,
                                            ReusableWidgets.colorProfile2_1,
                                            ReusableWidgets.colorProfile1,
                                          ],
                                        ),
                                      ),
                                      child: Card(
                                        shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(20)),
                                        color: ReusableWidgets.colorLight,
                                        elevation: 2.0,
                                        child: Container(
                                          margin: const EdgeInsets.all(8.0),
                                          width: double.infinity,
                                          child: Column(
                                            children: [
                                              Text(
                                                invitations[index]['courseID'],
                                                style: const TextStyle(
                                                  color: Colors.grey,
                                                ),
                                              ),
                                              const SizedBox(
                                                height: 3.0,
                                              ),
                                              Text(
                                                invitations[index]
                                                    ['courseName'],
                                                style: TextStyle(
                                                  color: ReusableWidgets
                                                      .colorProfile2_1,
                                                  fontSize: 20,
                                                  fontWeight: FontWeight.w900,
                                                ),
                                              ),
                                              const SizedBox(
                                                height: 10.0,
                                              ),
                                              const Divider(
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
                                              const SizedBox(
                                                height: 10.0,
                                              ),
                                              Padding(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                        horizontal: 16.0),
                                                child: Column(
                                                  children: [
                                                    Row(
                                                      children: [
                                                        Text('Instructor:',
                                                            style:
                                                                textStyleKey),
                                                        const Spacer(),
                                                        Align(
                                                          alignment: Alignment
                                                              .centerRight,
                                                          child: Text(
                                                            '${invitations[index]['instructorName']} ${invitations[index]['surname']}',
                                                            style:
                                                                textStyleValue,
                                                            textAlign:
                                                                TextAlign.right,
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                    const SizedBox(
                                                      height: 10.0,
                                                    ),
                                                    Row(
                                                      children: [
                                                        Text(
                                                          'Department:',
                                                          style: textStyleKey,
                                                        ),
                                                        const Spacer(),
                                                        Flexible(
                                                          child: Align(
                                                            alignment: Alignment
                                                                .centerRight,
                                                            child:
                                                                LayoutBuilder(
                                                              builder: (context,
                                                                  constraints) {
                                                                String
                                                                    deptName =
                                                                    invitations[
                                                                            index]
                                                                        [
                                                                        'deptName'];
                                                                TextPainter
                                                                    painter =
                                                                    TextPainter(
                                                                  text:
                                                                      TextSpan(
                                                                    text:
                                                                        deptName,
                                                                    style:
                                                                        textStyleValue,
                                                                  ),
                                                                  maxLines: 1,
                                                                  textDirection:
                                                                      TextDirection
                                                                          .ltr,
                                                                )..layout(
                                                                        maxWidth:
                                                                            constraints.maxWidth);
                                                                if (painter
                                                                    .didExceedMaxLines) {
                                                                  deptName =
                                                                      abbreviateDepartmentName(
                                                                          deptName);
                                                                }
                                                                return Text(
                                                                  deptName,
                                                                  style:
                                                                      textStyleValue,
                                                                  overflow:
                                                                      TextOverflow
                                                                          .ellipsis,
                                                                  maxLines: 1,
                                                                  textAlign:
                                                                      TextAlign
                                                                          .right,
                                                                );
                                                              },
                                                            ),
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                    const SizedBox(
                                                      height: 10.0,
                                                    ),
                                                    Row(
                                                      children: [
                                                        Text(
                                                          'Credits:',
                                                          style: textStyleKey,
                                                        ),
                                                        const Spacer(),
                                                        Text(
                                                            invitations[index]
                                                                ['credit'],
                                                            style:
                                                                textStyleValue),
                                                      ],
                                                    ),
                                                    const SizedBox(
                                                      height: 10.0,
                                                    ),
                                                    Row(
                                                      children: [
                                                        Text(
                                                          'Semester:',
                                                          style: textStyleKey,
                                                        ),
                                                        const Spacer(),
                                                        Text(
                                                            invitations[index]
                                                                ['semester'],
                                                            style:
                                                                textStyleValue),
                                                      ],
                                                    ),
                                                    const SizedBox(
                                                      height: 10.0,
                                                    ),
                                                    Row(
                                                      children: [
                                                        Text(
                                                          'Year:',
                                                          style: textStyleKey,
                                                        ),
                                                        const Spacer(),
                                                        Text(
                                                            invitations[index]
                                                                ['year'],
                                                            style:
                                                                textStyleValue),
                                                      ],
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              const SizedBox(
                                                height: 16.0,
                                              ),
                                              Visibility(
                                                visible: invitations[index]
                                                        ['status'] ==
                                                    '0',
                                                child: Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceEvenly,
                                                  children: [
                                                    ElevatedButton.icon(
                                                        //Handle button press event
                                                        onPressed: () async {
                                                          int parInstructorID =
                                                              int.parse(invitations[
                                                                      index][
                                                                  'instructorID']);
                                                          int? parStudentID =
                                                              await ReusableMethods
                                                                  .getUserId();
                                                          String parCourseID =
                                                              invitations[index]
                                                                  ['courseID'];
                                                          String parSectionID =
                                                              invitations[index]
                                                                  ['sectionID'];
                                                          String parSemester =
                                                              invitations[index]
                                                                  ['semester'];
                                                          int parYear =
                                                              int.parse(
                                                                  invitations[
                                                                          index]
                                                                      ['year']);
                                                          int parStatus = -1;
                                                          await updateInvites(
                                                              parInstructorID,
                                                              parStudentID!,
                                                              parCourseID,
                                                              parSectionID,
                                                              parSemester,
                                                              parYear,
                                                              parStatus);
                                                          setState(() {});
                                                        },
                                                        //Contents of the button
                                                        style: ElevatedButton
                                                            .styleFrom(
                                                          shape: RoundedRectangleBorder(
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          35.0)),
                                                          side: const BorderSide(
                                                              color: Colors.red,
                                                              width: 1.0,
                                                              style: BorderStyle
                                                                  .solid),
                                                          //Change font size
                                                          textStyle:
                                                              const TextStyle(
                                                            fontSize: 18,
                                                          ),
                                                          //Set the background color
                                                          backgroundColor:
                                                              ReusableWidgets
                                                                  .colorLight,
                                                          //Set the foreground (text + icon) color
                                                          foregroundColor:
                                                              Colors.red,
                                                          //Set the padding on all sides to 30px
                                                          padding:
                                                              const EdgeInsets
                                                                  .all(16.0),
                                                        ),
                                                        icon: const Icon(
                                                            CupertinoIcons
                                                                .multiply_circle_fill), //Button icon
                                                        label: const Text(
                                                          " Reject ",
                                                          style: TextStyle(
                                                            fontWeight:
                                                                FontWeight.bold,
                                                          ),
                                                        )),
                                                    ElevatedButton.icon(
                                                        //Handle button press event
                                                        onPressed: () async {
                                                          int parInstructorID =
                                                              int.parse(invitations[
                                                                      index][
                                                                  'instructorID']);
                                                          int? parStudentID =
                                                              await ReusableMethods
                                                                  .getUserId();
                                                          String parCourseID =
                                                              invitations[index]
                                                                  ['courseID'];
                                                          String parSectionID =
                                                              invitations[index]
                                                                  ['sectionID'];
                                                          String parSemester =
                                                              invitations[index]
                                                                  ['semester'];
                                                          int parYear =
                                                              int.parse(
                                                                  invitations[
                                                                          index]
                                                                      ['year']);
                                                          int parStatus = 1;
                                                          await updateInvites(
                                                              parInstructorID,
                                                              parStudentID!,
                                                              parCourseID,
                                                              parSectionID,
                                                              parSemester,
                                                              parYear,
                                                              parStatus);
                                                          setState(() {});
                                                        },
                                                        //Contents of the button
                                                        style: ElevatedButton
                                                            .styleFrom(
                                                          shape: RoundedRectangleBorder(
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          35.0)),
                                                          side: const BorderSide(
                                                              color:
                                                                  Colors.green,
                                                              width: 1.0,
                                                              style: BorderStyle
                                                                  .solid),
                                                          //Change font size
                                                          textStyle:
                                                              const TextStyle(
                                                            fontSize: 18,
                                                          ),
                                                          //Set the background color
                                                          backgroundColor:
                                                              ReusableWidgets
                                                                  .colorLight,
                                                          //Set the foreground (text + icon) color
                                                          foregroundColor:
                                                              Colors.green,
                                                          //Set the padding on all sides to 30px
                                                          padding:
                                                              const EdgeInsets
                                                                  .all(16.0),
                                                        ),
                                                        icon: const Icon(
                                                            CupertinoIcons
                                                                .check_mark_circled_solid), //Button icon
                                                        label: const Text(
                                                          " Accept ",
                                                          style: TextStyle(
                                                            fontWeight:
                                                                FontWeight.bold,
                                                          ),
                                                        )),
                                                  ],
                                                ),
                                              ),
                                              Visibility(
                                                visible: invitations[index]
                                                        ['status'] !=
                                                    '0',
                                                child: Container(
                                                  width: 150,
                                                  decoration: BoxDecoration(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            35),
                                                    color: invitations[index]
                                                                ['status'] ==
                                                            '1'
                                                        ? Colors.green
                                                        : Colors.red,
                                                  ),
                                                  child: Card(
                                                      shape:
                                                          RoundedRectangleBorder(
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          35)),
                                                      color: ReusableWidgets
                                                          .colorLight,
                                                      elevation:
                                                          2.0, //Button icon
                                                      child: Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                    .symmetric(
                                                                vertical: 16.0),
                                                        child: Row(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .center,
                                                          children: [
                                                            invitations[index][
                                                                        'status'] ==
                                                                    '-1'
                                                                ? Icon(
                                                                    CupertinoIcons
                                                                        .multiply_circle_fill,
                                                                    color: invitations[index]['status'] ==
                                                                            '-1'
                                                                        ? Colors
                                                                            .red
                                                                        : Colors
                                                                            .green,
                                                                  )
                                                                : Icon(
                                                                    CupertinoIcons
                                                                        .check_mark_circled_solid,
                                                                    color: invitations[index]['status'] ==
                                                                            '-1'
                                                                        ? Colors
                                                                            .red
                                                                        : Colors
                                                                            .green,
                                                                  ),
                                                            const SizedBox(
                                                              width: 8,
                                                            ),
                                                            Text(
                                                              invitations[index]
                                                                          [
                                                                          'status'] ==
                                                                      '-1'
                                                                  ? 'Rejected'
                                                                  : 'Accepted',
                                                              style: TextStyle(
                                                                fontSize: 18,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold,
                                                                color: invitations[index]
                                                                            [
                                                                            'status'] ==
                                                                        '-1'
                                                                    ? Colors.red
                                                                    : Colors
                                                                        .green,
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                      )),
                                                ),
                                              ),
                                              const SizedBox(
                                                height: 16.0,
                                              )
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                  );
                                });
                    }
                  },
                );
              }),
            ),
          ),
        ),
      ),
    );
  }
}
