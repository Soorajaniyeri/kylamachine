import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:studentmanage/views/phonelogin.dart';
import 'package:studentmanage/screens/registration_screen.dart';
import 'package:studentmanage/views/userlistview.dart';

import '../methods/alerts.dart';
import '../widgets/buttondesign.dart';
import '../widgets/textfield_design.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  FirebaseAuth auth = FirebaseAuth.instance;

  TextEditingController name = TextEditingController();
  TextEditingController email = TextEditingController();
  TextEditingController pass = TextEditingController();
  FirebaseAuth register = FirebaseAuth.instance;
  CollectionReference userCl = FirebaseFirestore.instance.collection("users");

  // creating registration function

  Future<void> signInWithGoogle() async {
    await GoogleSignIn().signOut();
    try {
      final GoogleSignInAccount? googleAccount = await GoogleSignIn().signIn();

      if (googleAccount == null) {
        return;
      }

      final GoogleSignInAuthentication googleAuth =
          await googleAccount.authentication;

      final OAuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      final UserCredential userCredential =
          await register.signInWithCredential(credential);

      if (userCredential.user != null) {
        // Add user details to Firestore
        userCl.doc(userCredential.user!.uid).collection("logindetails").add({
          "email": userCredential.user!.email,
        });
        if (context.mounted) {
          Navigator.of(context)
              .pushReplacement(MaterialPageRoute(builder: (context) {
            return const UserListView();
          }));
        }
      }
    } on FirebaseAuthException catch (error) {
      log(error.code);
    }
  }

  firebaseLogin({required String email, required String password}) async {
    try {
      UserCredential userData = await auth.signInWithEmailAndPassword(
          email: email, password: password);

      if (userData.user != null) {
        if (context.mounted) {
          Navigator.pushReplacement(context, MaterialPageRoute(
            builder: (context) {
              return const UserListView();
            },
          ));
        }
      }
    } on FirebaseAuthException catch (errorCode) {

      if (errorCode.code == "invalid-credential") {
        return Alerts().showToast(message: "invalid login details");
      }
      if (errorCode.code == "invalid-email") {
        return Alerts()
            .showToast(message: 'The email address is badly formatted');
      }

      if (errorCode.code == "weak-password") {
        return Alerts().showToast(message: "weak password");
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
          child: Center(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Image(height: 100, image: AssetImage("assets/top.png")),
              const SizedBox(
                height: 30,
              ),
              TextFieldDesign(hintText: "enter your email", controller: email),
              TextFieldDesign(
                  hintText: "enter your password", controller: pass),
              const SizedBox(
                height: 20,
              ),
              ButtonDesign(
                btnClr: Colors.blue,
                  buttonText: "Login",
                  onTap: () {
                    firebaseLogin(email: email.text, password: pass.text);
                  }),
              const SizedBox(
                height: 10,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text("Don't have an account"),
                  const SizedBox(
                    width: 10,
                  ),
                  TextButton(
                      onPressed: () {
                        Navigator.push(context, MaterialPageRoute(
                          builder: (context) {
                            return const Registration();
                          },
                        ));
                      },
                      child: const Text("Register"))
                ],
              ),
              const SizedBox(
                height: 30,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  InkWell(
                      onTap: () {
                        signInWithGoogle();
                      },
                      child: const Image(
                          height: 30, image: AssetImage("assets/google.png"))),
                  const SizedBox(
                    width: 90,
                  ),
                  InkWell(
                    onTap: () {
                      Navigator.push(context, MaterialPageRoute(
                        builder: (context) {
                          return  PhoneLogin();
                        },
                      ));
                    },
                    child: const Image(
                        height: 30, image: AssetImage("assets/phone.png")),
                  ),
                ],
              )
            ],
          ),
        ),
      )),
    );
  }
}
