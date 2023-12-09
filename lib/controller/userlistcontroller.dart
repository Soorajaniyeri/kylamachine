import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';

class HomeScreenProvider extends ChangeNotifier {
  TextEditingController searchController = TextEditingController();
  String streamValue = "";
  String selectedAgeRange = "All Students";

  void setSearchValue(String value) {
    streamValue = value;
    notifyListeners();
  }

  void setSelectedAgeRange(String value) {
    selectedAgeRange = value;
    notifyListeners();
  }

  Future<void> deleteData(String docid) async {
    await FirebaseFirestore.instance
        .collection("users")
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .collection("userdetails")
        .doc(docid)
        .delete();
  }
}
