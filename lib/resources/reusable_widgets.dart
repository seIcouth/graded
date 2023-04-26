import 'package:flutter/material.dart';
import 'package:graded/resources/reusable_methods.dart';

class ReusableWidgets{
  static Widget announcementNotificationCard(
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

  static Widget assignmentNotificationCard(
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