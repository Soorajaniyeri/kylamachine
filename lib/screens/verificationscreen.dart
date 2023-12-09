import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:studentmanage/methods/alerts.dart';
import 'package:studentmanage/views/userlistview.dart';

import '../widgets/buttondesign.dart';
import '../widgets/textfield_design.dart';

class VerificationScreen extends StatefulWidget {
  const VerificationScreen({super.key, required this.vId});
  final String vId;

  @override
  State<VerificationScreen> createState() => _VerificationScreenState();
}

class _VerificationScreenState extends State<VerificationScreen> {
  TextEditingController verificationCode = TextEditingController();
  FirebaseAuth auth = FirebaseAuth.instance;

  verifyUser() async {
    final credential = PhoneAuthProvider.credential(
        verificationId: widget.vId, smsCode: verificationCode.text.toString());
    try {
      await auth.signInWithCredential(credential);

      if (context.mounted) {
        Navigator.pushReplacement(context, MaterialPageRoute(
          builder: (context) {
            return const UserListView();
          },
        ));
      }
    } catch (e) {
      if (e == "invalid-verification-code") {
        Alerts().showToast(message: "invalid verification code");
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const SizedBox(
                height: 30,
              ),
              TextFieldDesign(
                  inputType: TextInputType.number,
                  bdrClr: Colors.black,
                  hintText: "6 digit code",
                  controller: verificationCode),
              const SizedBox(
                height: 20,
              ),
              ButtonDesign(
                  btnClr: Colors.blue,
                  btnMgn: 90,
                  buttonText: "verify",
                  onTap: () {
                    verifyUser();
                  })
            ],
          ),
        ),
      ),
    );
  }
}
