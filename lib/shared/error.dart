import 'package:flutter/material.dart';

class ErrorMessage extends StatelessWidget {
  final String message;

  const ErrorMessage({super.key, this.message = 'it broke'});

  @override
  Widget build(BuildContext context) {
    print(message);
    return Center(
      child: Text(message),
    );
  }
}
