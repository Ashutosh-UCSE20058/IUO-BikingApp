import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:flutter/material.dart';

import '../services/auth.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: 
      Container(
        padding: const EdgeInsets.all(30),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            const FlutterLogo(
              size: 150,
            ),
            Flexible(
              child: LoginButton(
                text: 'Sign in with Google',
                icon: FontAwesomeIcons.google,
                color: Color.fromARGB(255, 241, 160, 38),
                loginMethod: AuthService().googleLogin,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class LoginButton extends StatelessWidget {
  final Color color;
  final IconData icon;
  final String text;
  final Function loginMethod;

  const LoginButton({
    Key? key,
    required this.color,
    required this.icon,
    required this.text,
    required this.loginMethod,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      child: ElevatedButton.icon(
        icon: Icon(
          icon,
          color: Colors.white,
          size: 20,
        ),
        style: ElevatedButton.styleFrom(
          primary: color, // Set the background color
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(25.0), // Set the border radius
          ),
          padding: EdgeInsets.symmetric(
              vertical: 16, horizontal: 24), // Set the padding
        ),
        onPressed: () => loginMethod(),
        label: Text(
          text,
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.white, // Set the text color
          ),
        ),
      ),
    );
  }
}
