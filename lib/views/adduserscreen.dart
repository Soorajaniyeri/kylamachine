import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import 'package:studentmanage/controller/addusercontroller.dart';

import '../widgets/buttondesign.dart';
import '../widgets/textfield_design.dart';

class AdduserView extends StatelessWidget {
  const AdduserView({super.key});

  @override
  Widget build(BuildContext context) {
    final addUserData = Provider.of<AdduserController>(context);

    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Center(
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const SizedBox(
                    height: 20,
                  ),
                  const Text(
                    "Enter Student Details",
                    style: TextStyle(fontSize: 30),
                  ),
                  const SizedBox(
                    height: 40,
                  ),
                  IconButton(
                      iconSize: 90,
                      onPressed: () {
                        showDialog(
                          context: context,
                          builder: (context) {
                            return AlertDialog(
                                shape: const ContinuousRectangleBorder(),
                                content: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    const Row(
                                      children: [
                                        Text(
                                          "Select image from",
                                          style: TextStyle(fontSize: 20),
                                        ),
                                      ],
                                    ),
                                    ListTile(
                                      leading: const Icon(Icons.camera_alt),
                                      title: const Text("Camera"),
                                      onTap: () {
                                        addUserData.choosePhotoCamera();
                                        Navigator.pop(context);
                                      },
                                    ),
                                    ListTile(
                                      leading: const Icon(Icons.photo),
                                      title: const Text("Gallery"),
                                      onTap: () {
                                        addUserData.choosePhotoGallery();
                                        Navigator.pop(context);
                                      },
                                    )
                                  ],
                                ));
                          },
                        );
                      },
                      icon: addUserData.selectedImage == null
                          ? const Icon(Icons.image)
                          : CircleAvatar(
                              radius: 70,
                              backgroundImage:
                                  FileImage(addUserData.selectedImage!),
                            )),
                  const SizedBox(
                    height: 30,
                  ),
                  TextFieldDesign(
                      bdrClr: Colors.black,
                      hintText: "studentname",
                      controller: addUserData.stdNameCtrl),
                  const SizedBox(
                    height: 10,
                  ),
                  TextFieldDesign(
                      inputType: TextInputType.number,
                      bdrClr: Colors.black,
                      hintText: "studentage",
                      controller: addUserData.ageCtrl),
                  const SizedBox(
                    height: 15,
                  ),
                  ButtonDesign(
                    loading: addUserData.loading,
                    btnClr: Colors.blue,
                    btnMgn: 80,
                    buttonText: "Save Details",
                    onTap: () async {
                      if (addUserData.ageCtrl.text.isEmpty ||
                          addUserData.stdNameCtrl.text.isEmpty) {
                        Fluttertoast.showToast(
                            msg: "Please fill in all fields");
                      } else if (addUserData.selectedImage == null) {
                        Fluttertoast.showToast(msg: "Please select an image");
                      } else {
                        int age = int.parse(addUserData.ageCtrl.text);

                        if (age < 10) {
                          Fluttertoast.showToast(
                              msg: "Age must be greater than or equals to 10");
                        } else if (age > 40) {
                          Fluttertoast.showToast(
                              msg: "Age must be less than 40");
                        } else {
                          await addUserData.uploadImage();

                          addUserData.resetState();
                          if (context.mounted) {
                            Navigator.pop(context);
                          }
                        }
                      }
                    },
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
