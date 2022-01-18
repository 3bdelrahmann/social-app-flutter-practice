import 'package:flutter/material.dart';
import 'package:social_app/shared/styles/colors.dart';

class MainLayout extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
          child: Container(
        color: kMainColor,
        child: Text(
          'Welcome',
          style: TextStyle(
            color: Colors.white,
            fontSize: 25.0,
          ),
        ),
      )),
    );
  }
}
