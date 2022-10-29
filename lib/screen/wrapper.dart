import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:warung_ku/screen/home_screen.dart';
import 'package:warung_ku/screen/login_screen.dart';

class Wrapper extends StatelessWidget {
  const Wrapper({super.key});
  static const routeName = '/';

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.userChanges(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return const HomeScreen();
        } else {
          return const LoginScreen();
        }
      },
    );
  }
}
