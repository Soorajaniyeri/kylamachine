import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:studentmanage/controller/phonelogincontroller.dart';
import 'package:studentmanage/methods/alerts.dart';
import 'package:studentmanage/widgets/buttondesign.dart';
import 'package:studentmanage/widgets/textfield_design.dart';

class PhoneLogin extends StatelessWidget {
  const PhoneLogin({super.key});

  @override
  Widget build(BuildContext context) {
    final phoneLogin = Provider.of<PhoneLoginController>(context);
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const SizedBox(
                height: 30,
              ),
              const Text("Enter you mobile number without country code"),
              const SizedBox(
                height: 10,
              ),
              TextFieldDesign(
                  inputType: TextInputType.number,
                  bdrClr: Colors.black,
                  hintText: "Enter your phone number",
                  controller: phoneLogin.phoneCtrl),
              const SizedBox(
                height: 20,
              ),
              ButtonDesign(
                  loading: phoneLogin.loading,
                  btnClr: Colors.blue,
                  btnMgn: 90,
                  buttonText: "Send OTP",
                  onTap: () {
                    if (phoneLogin.phoneCtrl.text.length == 10) {
                      phoneLogin.loginWithPhone(context);
                      phoneLogin.resetState();
                    } else {
                      Alerts().showToast(message: "please check your number");
                    }
                  })
            ],
          ),
        ),
      ),
    );
  }
}
