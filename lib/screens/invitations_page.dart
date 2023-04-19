import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:hidden_drawer_menu/hidden_drawer_menu.dart';
import '../resources/reusable_methods.dart';
import 'package:simple_gradient_text/simple_gradient_text.dart';

class InvitationsPage extends StatefulWidget {
  const InvitationsPage({super.key});

  @override
  State<InvitationsPage> createState() => _InvitationsPageState();
}

class _InvitationsPageState extends State<InvitationsPage> {
  final textStyleKey = TextStyle(
    fontWeight: FontWeight.bold,
    fontSize: 18,
    color: ReusableMethods.colorProfile1,
  );

  final textStyleValue = TextStyle(
      fontWeight: FontWeight.w600,
      fontSize: 18,
      color: ReusableMethods.colorProfile3);

  late List<dynamic> invitations;

  Future<List<dynamic>> getInvitations() async {
    int? id = await ReusableMethods.getUserId();
    await ReusableMethods.getRole();

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

  @override
  Widget build(BuildContext context) {
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
          "Invitations",
          style: TextStyle(
            color: ReusableMethods.colorLight,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      backgroundColor: ReusableMethods.colorLight,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(8.0, 8.0, 8.0, 8.0),
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
                        return Center(
                          child: CircularProgressIndicator(
                            backgroundColor: ReusableMethods.colorLight,
                            color: ReusableMethods.colorDark,
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
                                            ReusableMethods.colorProfile3,
                                            ReusableMethods.colorProfile2,
                                            ReusableMethods.colorProfile1,
                                          ],
                                        ),
                                      ),
                                      child: Card(
                                        shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(20)),
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
                                                    invitations[index]
                                                        ['courseID'],
                                                    style: const TextStyle(
                                                      color: Colors.grey,
                                                    ),
                                                  ),
                                                  const SizedBox(
                                                    height: 3.0,
                                                  ),
                                                  GradientText(
                                                    invitations[index]
                                                        ['courseName'],
                                                    style: const TextStyle(
                                                      fontSize: 20,
                                                      fontWeight:
                                                          FontWeight.w900,
                                                    ),
                                                    colors: [
                                                      ReusableMethods
                                                          .colorProfile1,
                                                      ReusableMethods
                                                          .colorProfile2,
                                                      ReusableMethods
                                                          .colorProfile3,
                                                    ],
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
                                                    padding: const EdgeInsets
                                                            .symmetric(
                                                        horizontal: 16.0),
                                                    child: Column(
                                                      children: [
                                                        Row(
                                                          children: [
                                                            Text('Instructor:',
                                                                style:
                                                                    textStyleKey),
                                                            const Spacer(),
                                                            Text(
                                                                '${invitations[index]['instructorName']} ${invitations[index]['surname']}',
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
                                                              'Department:',
                                                              style:
                                                                  textStyleKey,
                                                            ),
                                                            const Spacer(),
                                                            Text(
                                                                invitations[
                                                                        index][
                                                                    'deptName'],
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
                                                              'Credits:',
                                                              style:
                                                                  textStyleKey,
                                                            ),
                                                            const Spacer(),
                                                            Text(
                                                                invitations[
                                                                        index]
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
                                                              style:
                                                                  textStyleKey,
                                                            ),
                                                            const Spacer(),
                                                            Text(
                                                                invitations[
                                                                        index][
                                                                    'semester'],
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
                                                              style:
                                                                  textStyleKey,
                                                            ),
                                                            const Spacer(),
                                                            Text(
                                                                invitations[
                                                                        index]
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
                                                  Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .center,
                                                    children: [
                                                      Visibility(
                                                        visible: invitations[
                                                                        index][
                                                                    'status'] ==
                                                                0 ||
                                                            invitations[index][
                                                                    'status'] ==
                                                                -1,
                                                        child: IconButton(
                                                            onPressed: () {},
                                                            icon: Icon(
                                                              CupertinoIcons
                                                                  .multiply_square_fill,
                                                              color: Colors.red
                                                                  .withOpacity(
                                                                      0.8),
                                                              size: 48,
                                                            )),
                                                      ),
                                                      const SizedBox(
                                                        width: 100.0,
                                                      ),
                                                      Visibility(
                                                        visible: invitations[
                                                                        index][
                                                                    'status'] ==
                                                                0 ||
                                                            invitations[index][
                                                                    'status'] ==
                                                                1,
                                                        child: IconButton(
                                                            onPressed: () {},
                                                            icon: Icon(
                                                              CupertinoIcons
                                                                  .checkmark_square_fill,
                                                              color: Colors
                                                                  .green
                                                                  .withOpacity(
                                                                      0.8),
                                                              size: 48,
                                                            )),
                                                      )
                                                    ],
                                                  ),
                                                  const SizedBox(
                                                    height: 16.0,
                                                  )
                                                ],
                                              ),
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
