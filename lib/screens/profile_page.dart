import 'package:flutter/material.dart';
import '../resources/reusable_methods.dart';
import 'auth_screens/login.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ReusableMethods.colorLight,
      body: Center(
        child: ElevatedButton(
          onPressed: () async {
            ReusableMethods.setLoggedInFalse();
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => const LoginPage(),
              ),
            );
          },
          child: const Text('Log out'),
        ),
      ),
    );
  }
}
