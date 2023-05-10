import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:graded/resources/reusable_methods.dart';
import 'package:intl/intl.dart';

class ReusableWidgets {
  static String formatDate(DateTime date) =>
      DateFormat("MMMM d - hh:mm").format(date);
  static Widget announcementNotificationCard(
      BuildContext context,
      String title,
      String content,
      String courseCode,
      String publishDate) {
    return Card(
      color: ReusableMethods.colorAnnouncement,
      elevation: 6,
      shadowColor: ReusableMethods.colorDark,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: InkWell(
        onTap: () {
          showDialog(
              context: context,
              builder: (BuildContext context) {
                return AlertDialog(
                  backgroundColor: ReusableMethods.colorLight,
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
                                  color: ReusableMethods.colorDark,
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
                                      color: ReusableMethods.colorDark,
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
                                            "Published on ${ReusableMethods.formatDate(publishDate)}",
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
                      "$courseCode • ${ReusableMethods.formatDate(publishDate)}",
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

  static Widget assignmentNotificationCard(
    BuildContext context,
    String title,
    String content,
    String courseCode,
    String dueDate,
    String publishDate
  ) {
    return Card(
      color: ReusableMethods.colorAssignment,
      elevation: 6,
      shadowColor: ReusableMethods.colorDark,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: InkWell(
        onTap: () {
          showDialog(
              context: context,
              builder: (BuildContext context) {
                return AlertDialog(
                  backgroundColor: ReusableMethods.colorLight,
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
                                  color: ReusableMethods.colorDark,
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
                                      color: ReusableMethods.colorDark,
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
                                            "Due: ${ReusableMethods.formatDate(dueDate)}",
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
                                  "$courseCode • ${ReusableMethods.formatDate(publishDate)}",
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
                      "$courseCode • DUE: ${ReusableMethods.formatDate(publishDate)}",
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
      color: ReusableMethods.colorAnnouncement,
      elevation: 6,
      shadowColor: ReusableMethods.colorDark,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: InkWell(
        onTap: () {
          showDialog(
              context: context,
              builder: (BuildContext context) {
                return AlertDialog(
                  backgroundColor: ReusableMethods.colorLight,
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
                                  color: ReusableMethods.colorDark,
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
                                      color: ReusableMethods.colorDark,
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
                                            "Published on ${ReusableMethods.formatDate(publishDate)}",
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
              }
              );
        },
        child: Card(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          color: ReusableMethods.colorLight,
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
      color: ReusableMethods.colorAssignment,
      elevation: 6,
      shadowColor: ReusableMethods.colorDark,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: InkWell(
        onTap: () {
          showDialog(
              context: context,
              builder: (BuildContext context) {
                return AlertDialog(
                  backgroundColor: ReusableMethods.colorLight,
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
                                  color: ReusableMethods.colorDark,
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
                                      color: ReusableMethods.colorDark,
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
                                            "Due: ${ReusableMethods.formatDate(dueDate)}",
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
          color: ReusableMethods.colorLight,
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
          ),
        ),
      ),
    );
  }
}
