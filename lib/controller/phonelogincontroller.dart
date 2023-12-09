import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../methods/alerts.dart';
import '../screens/verificationscreen.dart';

class PhoneLoginController extends ChangeNotifier {
  final auth = FirebaseAuth.instance;
  final phoneCtrl = TextEditingController();
  bool loading = false;

  loginWithPhone(BuildContext context) async {
    loading = true;
    notifyListeners();

    await auth.verifyPhoneNumber(
      phoneNumber: "+91${phoneCtrl.text}",
      verificationCompleted: (_) {},
      verificationFailed: (e) {
        loading = false;
        notifyListeners();
        Alerts().showToast(message: "Verification failed");
      },
      codeSent: (id, token) {
        loading = false; // Reset loading state
        notifyListeners();
        Navigator.pushReplacement(context, MaterialPageRoute(
          builder: (context) {
            return VerificationScreen(vId: id);
          },
        ));
      },
      codeAutoRetrievalTimeout: (_) {},
    );
  }

  void resetState() {
    phoneCtrl.clear();
    notifyListeners();
  }
}
