import 'package:betterroute/home/myhome.dart';
import 'package:flutter/material.dart';
import 'package:betterroute/login/login.dart';
import 'package:betterroute/services/auth.dart';

class StartScreen extends StatelessWidget {
  const StartScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: AuthService().userStream,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(
              child: CircularProgressIndicator(
                color: Colors.orange,
              ),
            ),
          );
        } else if (snapshot.hasError) {
          return const Center(child: Text('Error'));
        } else if (snapshot.hasData) {
          return const MyHomeScreen();
        } else {
          return const LoginScreen();
        }
      },
    );
  }
}
