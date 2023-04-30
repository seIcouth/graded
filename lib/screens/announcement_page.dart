import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:graded/resources/reusable_widgets.dart';
import '../resources/reusable_methods.dart';
import 'package:http/http.dart' as http;

class AnnouncementPage extends StatefulWidget {
  const AnnouncementPage({Key? key, required this.courseID, required this.courseSectionID, required this.courseSemester, required this.courseYear, required this.courseName}) : super(key: key);

  final String courseID;
  final String courseName;
  final String courseSectionID;
  final String courseSemester;
  final String courseYear;

  @override
  State<AnnouncementPage> createState() => _AnnouncementPageState();
}

class _AnnouncementPageState extends State<AnnouncementPage> {

  // variables
  late List<dynamic> courseAnnouncements;

  // accessor methods
  Future<List<dynamic>> getAnnouncements() async {
    String parCourseID = widget.courseID;
    String parSectionID = widget.courseSectionID;
    String parSemester = widget.courseSemester;
    String parYear = widget.courseYear;
    final url = 'http://10.0.2.2/graded/getannouncements.php?courseID=$parCourseID&sectionID=$parSectionID&semester=$parSemester&year=$parYear';
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
        backgroundColor: ReusableMethods.colorPeople,
        title: Text(
          "Announcements",
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
                0.9,
              ],
              colors: [
                ReusableMethods.colorAnnouncement_2,
                ReusableMethods.colorAnnouncement_1,
              ],
            ),
          ),
        ),
      ),
      backgroundColor: ReusableMethods.colorLight,
      extendBodyBehindAppBar: true,
      body: FutureBuilder(
        future: getAnnouncements(),
        builder: (context, AsyncSnapshot<void> snapshot) {
          if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}');
          }
          switch (snapshot.connectionState) {
            case ConnectionState.waiting:
              return Center(
                child: CircularProgressIndicator(
                  backgroundColor: ReusableMethods.colorLight,
                  color: ReusableMethods.colorDark,
                ),
              );
            default:
              return SafeArea(
                child: SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Center(
                      child: Card(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20)),
                        color: ReusableMethods.colorLight,
                        elevation: 3.0,
                        shadowColor: ReusableMethods.colorAnnouncement_1,
                        child: Container(
                          width: double.infinity,
                          margin: const EdgeInsets.all(8.0),
                          child: ListView.builder(
                            itemCount: courseAnnouncements.length,
                            shrinkWrap: true,
                            padding: const EdgeInsets.all(4.0),
                            physics: const NeverScrollableScrollPhysics(),
                            itemBuilder: (BuildContext context, int index){
                              return Padding(
                                padding: const EdgeInsets.symmetric(vertical: 4.0),
                                child: ReusableWidgets.announcementPageCard(
                                    context,
                                    courseAnnouncements[index]['title'],
                                    courseAnnouncements[index]['content'],
                                    widget.courseID,
                                    widget.courseName,
                                    courseAnnouncements[index]['publishDate']
                                ),
                              );
                            },
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              );
          }
        },
      ),
    );
  }
}
