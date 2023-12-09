import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class AdduserController extends ChangeNotifier {
  TextEditingController stdNameCtrl = TextEditingController();
  TextEditingController ageCtrl = TextEditingController();
  File? selectedImage;
  String? url;
  bool loading = false;

  choosePhotoGallery() async {
    ImagePicker picker = ImagePicker();
    XFile? store = await picker.pickImage(source: ImageSource.gallery);
    if (store != null) {
      selectedImage = File(store.path);

      notifyListeners();
    }
  }

  choosePhotoCamera() async {
    ImagePicker picker = ImagePicker();
    XFile? store = await picker.pickImage(source: ImageSource.camera);
    if (store != null) {
      selectedImage = File(store.path);
      notifyListeners();
    }
  }

  Future uploadImage() async {
    Reference ref =
        FirebaseStorage.instance.ref().child("photos/${selectedImage!.path}");

    UploadTask task = ref.putFile(selectedImage!);

    loading = true;
    notifyListeners();
    await task.whenComplete(() async {
      url = await ref.getDownloadURL();

      await FirebaseFirestore.instance
          .collection("users")
          .doc(FirebaseAuth.instance.currentUser!.uid)
          .collection("userdetails")
          .add({
        "name": stdNameCtrl.text,
        "sortfield": stdNameCtrl.text.toLowerCase(),
        "id": FirebaseAuth.instance.currentUser!.uid,
        "age": int.parse(ageCtrl.text),
        "dp": url
      });

      loading = false;
      notifyListeners();
    });
  }

  void resetState() {
    stdNameCtrl.clear();
    ageCtrl.clear();
    selectedImage = null;
    url = null;
    notifyListeners();
  }
}
