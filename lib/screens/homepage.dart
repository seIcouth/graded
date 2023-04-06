import 'package:flutter/material.dart';
import 'package:graded/screens/auth_screens/login.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _index = 0;

  final Color colorLight = const Color(0xfffff4f0);
  final Color colorDark = const Color(0xff0e1e40);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: colorLight,
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: Text(
          'Home',
          style: TextStyle(
            color: colorLight,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        backgroundColor: colorDark,
        leading: Icon(
          Icons.menu_rounded,
          color: colorLight,
        ),
      ),
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
                                child: Card(
                                  color: Colors.teal,
                                  elevation: 6,
                                  shadowColor: colorDark,
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(20)),
                                  child: announcementNotificationCard(
                                      context,
                                      "Announcement 1",
                                      "sedrfgthyujıkolpşlokıujhygtfrtgyhujıkolpşlokıujhygtfrtgyhujıkolpşlokıuytyuıop",
                                      "COMP204",
                                      "Database Management Systems",
                                      Colors.teal),
                                  /*
                                  Center(
                                    child: Text(
                                      "Card ${i + 1}",
                                      style: TextStyle(
                                        fontSize: 32,
                                        color: colorLight,
                                      ),
                                    ),
                                  ),
                                  */
                                ),
                              );
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const Spacer(),
                ElevatedButton(
                  onPressed: () async {
                    SharedPreferences prefs =
                        await SharedPreferences.getInstance();
                    await prefs.setBool('isLoggedIn', false);
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => const LoginPage(),
                      ),
                    );
                  },
                  child: const Text('Log out'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget announcementNotificationCard(BuildContext context, String title,
      String content, String courseCode, String courseName, Color color) {
    return Card(
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
                              color: color,
                            ),
                            Expanded(
                              child: Text(
                                title,
                                style: TextStyle(
                                  color: color,
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
                            color: color,
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
    );
  }

  Widget assignmentNotificationCard(
      BuildContext context, String title, String courseCode) {
    return Container();
  }
}
