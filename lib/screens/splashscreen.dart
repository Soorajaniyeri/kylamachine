import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:studentmanage/screens/registration_screen.dart';
import 'package:studentmanage/views/userlistview.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  FirebaseAuth auth = FirebaseAuth.instance;

  @override
  void initState() {
    if (auth.currentUser != null) {
      Timer(const Duration(seconds: 3), () {
        Navigator.pushReplacement(context, MaterialPageRoute(
          builder: (context) {
            return const UserListView();
          },
        ));
      });
    } else {
      Timer(const Duration(seconds: 3), () {
        Navigator.pushReplacement(context, MaterialPageRoute(
          builder: (context) {
            return const Registration();
          },
        ));
      });
    }
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image(height: 180, image: AssetImage("assets/graduated.png")),
            SizedBox(
              height: 30,
            ),
            Text(
              "Student Management",
              style: TextStyle(fontSize: 20),
            ),
          ],
        ),
      ),
    );
  }
}
