import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:graded/resources/reusable_methods.dart';
import 'package:flutter_flushbar/flutter_flushbar.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

class ReusableWidgets {
  static Color colorDark = const Color(0xff0e1e40);
  static Color colorLight = const Color(0xfffff4f0);
  static Color colorAnnouncement = const Color(0xff2196f3).withOpacity(0.8);
  static Color colorAssignment = const Color(0xffff6340).withOpacity(0.8);
  static Color colorPeople = const Color(0xff662D9C).withOpacity(0.8);
  static Color colorPeople1 = const Color(0xff662D9C).withOpacity(0.6);
  static Color colorPeople2 = const Color(0xffED1F79).withOpacity(0.6);
  static Color colorGrades = const Color(0xff009688).withOpacity(0.8);
  static Color colorProfile1 = const Color(0xffA84D6F).withOpacity(0.8);
  static Color colorProfile2 = const Color(0xffE47668).withOpacity(0.8);
  static Color colorProfile2_1 = const Color(0xffE47668);
  static Color colorProfile3 = const Color(0xffFFB25D).withOpacity(0.8);
  static Color colorProfile3_1 = const Color(0xffFFB25D);
  static Color colorCourse1 = const Color(0xff0e1c26);
  static Color colorCourse2 = const Color(0xff2a454b);
  static Color colorCourse3 = const Color(0xff294861);
  static Color colorAnnouncement1 = const Color(0xff2E3192);
  static Color colorAnnouncement2 = const Color(0xff1BFFFF).withOpacity(0.4);
  static Color colorAssignment1 = const Color(0xffFF5F6D);
  static Color colorAssignment2 = const Color(0xffFFC371);
  static Color colorGrade1 = const Color(0xff11998E);
  static Color colorGrade2 = const Color(0xff38EF7D);

  static Widget loadingAnimation(Color color) {
    return LoadingAnimationWidget.newtonCradle(
      color: color,
      size: 125,
    );
  }

  static Future flushbar(String message, BuildContext context) {
    return Flushbar(
      backgroundColor: colorLight,
      messageColor: colorDark,
      borderRadius: BorderRadius.circular(20),
      borderWidth: 2.5,
      borderColor: colorDark,
      icon: Icon(
        CupertinoIcons.info,
        color: colorDark,
      ),
      title: 'Warning',
      titleColor: colorDark,
      padding: const EdgeInsets.all(8.0),
      message: message,
      duration: message.length < 40
          ? const Duration(seconds: 3)
          : const Duration(seconds: 4),
      margin: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom + 15,
          left: 8.0,
          right: 8.0),
    ).show(context);
  }

  static Widget announcementNotificationCard(BuildContext context, String title,
      String content, String courseCode, String publishDate) {
    return Card(
      color: ReusableWidgets.colorAnnouncement,
      elevation: 6,
      shadowColor: ReusableWidgets.colorDark,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: InkWell(
        onTap: () {
          showDialog(
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
                            Container(
                              alignment: FractionalOffset.topRight,
                              child: GestureDetector(
                                child: const Icon(
                                  CupertinoIcons.multiply,
                                  color: Colors.red,
                                ),
                                onTap: () {
                                  Navigator.pop(context);
                                },
                              ),
                            ),
                            Align(
                              alignment: Alignment.center,
                              child: Text(
                                title,
                                style: TextStyle(
                                  fontWeight: FontWeight.w600,
                                  fontSize: 24.0,
                                  color: ReusableWidgets.colorDark,
                                ),
                              ),
                            ),
                            const SizedBox(
                              height: 20.0,
                            ),
                            Column(
                              children: [
                                Container(
                                  decoration: BoxDecoration(
                                    border: Border.all(
                                      color: ReusableWidgets.colorDark,
                                      width: 1, // set border width to 10
                                    ),
                                    borderRadius: BorderRadius.circular(20.0),
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 4.0, horizontal: 8),
                                    child: Column(
                                      children: [
                                        TextFormField(
                                          initialValue: content,
                                          style: const TextStyle(fontSize: 18),
                                          maxLines: null,
                                          enabled: false,
                                          decoration: const InputDecoration(
                                            border: InputBorder.none,
                                          ),
                                        ),
                                        Align(
                                          alignment: Alignment.centerRight,
                                          child: Text(
                                            "Published on ${ReusableMethods.formatDateString(publishDate)}",
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
                                      ],
                                    ),
                                  ),
                                ),
                                const SizedBox(
                                  height: 14.0,
                                ),
                                Text(
                                  courseCode,
                                  style: const TextStyle(
                                    color: CupertinoColors.systemGrey,
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold,
                                  ),
                                  softWrap: false,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  textAlign: TextAlign.left,
                                ),
                              ],
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                );
              });
        },
        child: Card(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          color: ReusableWidgets.colorLight,
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
                                  color: ReusableWidgets.colorAnnouncement,
                                ),
                                Expanded(
                                  child: Text(
                                    title,
                                    style: TextStyle(
                                      color: ReusableWidgets.colorAnnouncement,
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
                              color: Colors.grey,
                              //color of divider
                              height: 5,
                              //height spacing of divider
                              thickness: 1.5,
                              //thickness of divider line
                              indent: 5,
                              //spacing at the start of divider
                              endIndent: 5, //spacing at the end of divider
                            ),
                            const SizedBox(
                              height: 10.0,
                            ),
                            Text(
                              content,
                              style: TextStyle(
                                color: ReusableWidgets.colorAnnouncement,
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
                      "$courseCode • ${ReusableMethods.formatDateString(publishDate)}",
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
      ),
    );
  }

  static Widget assignmentNotificationCard(BuildContext context, String title,
      String content, String courseCode, String dueDate, String publishDate) {
    return Card(
      color: ReusableWidgets.colorAssignment,
      elevation: 6,
      shadowColor: ReusableWidgets.colorDark,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: InkWell(
        onTap: () {
          showDialog(
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
                            Container(
                              alignment: FractionalOffset.topRight,
                              child: GestureDetector(
                                child: const Icon(
                                  CupertinoIcons.multiply,
                                  color: Colors.red,
                                ),
                                onTap: () {
                                  Navigator.pop(context);
                                },
                              ),
                            ),
                            Align(
                              alignment: Alignment.center,
                              child: Text(
                                title,
                                style: TextStyle(
                                  fontWeight: FontWeight.w600,
                                  fontSize: 24.0,
                                  color: ReusableWidgets.colorDark,
                                ),
                              ),
                            ),
                            const SizedBox(
                              height: 20.0,
                            ),
                            Column(
                              children: [
                                Container(
                                  decoration: BoxDecoration(
                                    border: Border.all(
                                      color: ReusableWidgets.colorDark,
                                      width: 1, // set border width to 10
                                    ),
                                    borderRadius: BorderRadius.circular(20.0),
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 4.0, horizontal: 8),
                                    child: Column(
                                      children: [
                                        TextFormField(
                                          style: const TextStyle(fontSize: 18),
                                          maxLines: null,
                                          enabled: false,
                                          initialValue: content,
                                          decoration: const InputDecoration(
                                            border: InputBorder.none,
                                          ),
                                        ),
                                        Align(
                                          alignment: Alignment.centerRight,
                                          child: Text(
                                            "Due: ${ReusableMethods.formatDateString(dueDate)}",
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
                                      ],
                                    ),
                                  ),
                                ),
                                const SizedBox(
                                  height: 14.0,
                                ),
                                Text(
                                  "$courseCode • ${ReusableMethods.formatDateString(publishDate)}",
                                  style: const TextStyle(
                                    color: CupertinoColors.systemGrey,
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold,
                                  ),
                                  softWrap: false,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  textAlign: TextAlign.left,
                                ),
                              ],
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                );
              });
        },
        child: Card(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          color: ReusableWidgets.colorLight,
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
                                  color: ReusableWidgets.colorAssignment,
                                ),
                                Expanded(
                                  child: Text(
                                    title,
                                    style: TextStyle(
                                      color: ReusableWidgets.colorAssignment,
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
                              color: Colors.grey,
                              //color of divider
                              height: 5,
                              //height spacing of divider
                              thickness: 1.5,
                              //thickness of divider line
                              indent: 5,
                              //spacing at the start of divider
                              endIndent: 5, //spacing at the end of divider
                            ),
                            const SizedBox(
                              height: 10.0,
                            ),
                            Text(
                              content,
                              style: TextStyle(
                                color: ReusableWidgets.colorAssignment,
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
                      "$courseCode • DUE: ${ReusableMethods.formatDateString(publishDate)}",
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
      ),
    );
  }

  static Widget announcementPageCard(
      BuildContext context,
      String title,
      String content,
      String courseCode,
      String courseName,
      String publishDate) {
    return Card(
      color: ReusableWidgets.colorAnnouncement,
      elevation: 6,
      shadowColor: ReusableWidgets.colorDark,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: InkWell(
        onTap: () {
          showDialog(
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
                            Container(
                              alignment: FractionalOffset.topRight,
                              child: GestureDetector(
                                child: const Icon(
                                  CupertinoIcons.multiply,
                                  color: Colors.red,
                                ),
                                onTap: () {
                                  Navigator.pop(context);
                                },
                              ),
                            ),
                            Align(
                              alignment: Alignment.center,
                              child: Text(
                                title,
                                style: TextStyle(
                                  fontWeight: FontWeight.w600,
                                  fontSize: 24.0,
                                  color: ReusableWidgets.colorDark,
                                ),
                              ),
                            ),
                            const SizedBox(
                              height: 20.0,
                            ),
                            Column(
                              children: [
                                Container(
                                  decoration: BoxDecoration(
                                    border: Border.all(
                                      color: ReusableWidgets.colorDark,
                                      width: 1, // set border width to 10
                                    ),
                                    borderRadius: BorderRadius.circular(20.0),
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 4.0, horizontal: 8),
                                    child: Column(
                                      children: [
                                        TextFormField(
                                          style: const TextStyle(fontSize: 18),
                                          maxLines: null,
                                          enabled: false,
                                          initialValue: content,
                                          decoration: const InputDecoration(
                                            border: InputBorder.none,
                                          ),
                                        ),
                                        Align(
                                          alignment: Alignment.centerRight,
                                          child: Text(
                                            "Published on ${ReusableMethods.formatDateString(publishDate)}",
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
                                      ],
                                    ),
                                  ),
                                ),
                                const SizedBox(
                                  height: 14.0,
                                ),
                                Text(
                                  "$courseCode • $courseName",
                                  style: const TextStyle(
                                    color: CupertinoColors.systemGrey,
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold,
                                  ),
                                  softWrap: false,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  textAlign: TextAlign.left,
                                ),
                              ],
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                );
              });
        },
        child: Card(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          color: ReusableWidgets.colorLight,
          elevation: 2.0,
          child: Container(
            margin: const EdgeInsets.all(8.0),
            child: Column(
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
                              color: ReusableWidgets.colorAnnouncement,
                            ),
                            Expanded(
                              child: Text(
                                title,
                                style: TextStyle(
                                  color: ReusableWidgets.colorAnnouncement,
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
                          color: Colors.grey,
                          //color of divider
                          height: 5,
                          //height spacing of divider
                          thickness: 1.5,
                          //thickness of divider line
                          indent: 5,
                          //spacing at the start of divider
                          endIndent: 5, //spacing at the end of divider
                        ),
                        const SizedBox(
                          height: 10.0,
                        ),
                        Text(
                          "$content\n\n",
                          style: TextStyle(
                            color: ReusableWidgets.colorAnnouncement,
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
          ),
        ),
      ),
    );
  }

  static Widget assignmentPageCard(
      BuildContext context,
      String title,
      String content,
      String courseCode,
      String courseName,
      String publishDate,
      String dueDate) {
    return Card(
      color: ReusableWidgets.colorAssignment,
      elevation: 6,
      shadowColor: ReusableWidgets.colorDark,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: InkWell(
        onTap: () {
          showDialog(
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
                            Container(
                              alignment: FractionalOffset.topRight,
                              child: GestureDetector(
                                child: const Icon(
                                  CupertinoIcons.multiply,
                                  color: Colors.red,
                                ),
                                onTap: () {
                                  Navigator.pop(context);
                                },
                              ),
                            ),
                            Align(
                              alignment: Alignment.center,
                              child: Text(
                                title,
                                style: TextStyle(
                                  fontWeight: FontWeight.w600,
                                  fontSize: 24.0,
                                  color: ReusableWidgets.colorDark,
                                ),
                              ),
                            ),
                            const SizedBox(
                              height: 20.0,
                            ),
                            Column(
                              children: [
                                Container(
                                  decoration: BoxDecoration(
                                    border: Border.all(
                                      color: ReusableWidgets.colorDark,
                                      width: 1, // set border width to 10
                                    ),
                                    borderRadius: BorderRadius.circular(20.0),
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 4.0, horizontal: 8),
                                    child: Column(
                                      children: [
                                        TextFormField(
                                          style: const TextStyle(fontSize: 18),
                                          maxLines: null,
                                          enabled: false,
                                          initialValue: content,
                                          decoration: const InputDecoration(
                                            border: InputBorder.none,
                                          ),
                                        ),
                                        Align(
                                          alignment: Alignment.centerRight,
                                          child: Text(
                                            "Due: ${ReusableMethods.formatDateString(dueDate)}",
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
                                      ],
                                    ),
                                  ),
                                ),
                                const SizedBox(
                                  height: 14.0,
                                ),
                                Text(
                                  "$courseCode • $courseName",
                                  style: const TextStyle(
                                    color: CupertinoColors.systemGrey,
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold,
                                  ),
                                  softWrap: false,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  textAlign: TextAlign.left,
                                ),
                              ],
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                );
              });
        },
        child: Card(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          color: ReusableWidgets.colorLight,
          elevation: 2.0,
          child: Container(
            margin: const EdgeInsets.all(8.0),
            child: Column(
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
                              color: ReusableWidgets.colorAssignment,
                            ),
                            Expanded(
                              child: Text(
                                title,
                                style: TextStyle(
                                  color: ReusableWidgets.colorAssignment,
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
                          color: Colors.grey,
                          //color of divider
                          height: 5,
                          //height spacing of divider
                          thickness: 1.5,
                          //thickness of divider line
                          indent: 5,
                          //spacing at the start of divider
                          endIndent: 5, //spacing at the end of divider
                        ),
                        const SizedBox(
                          height: 10.0,
                        ),
                        Text(
                          "$content\n\n",
                          style: TextStyle(
                            color: ReusableWidgets.colorAssignment,
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
          ),
        ),
      ),
    );
  }
}
