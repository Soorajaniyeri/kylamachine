import 'package:flutter/material.dart';

class TextFieldDesign extends StatelessWidget {
  TextEditingController controller;
  TextInputType inputType;
  String hintText;
  Widget? suffixIcon;
  Color? bdrClr;
  // String? Function(String?)? validator;

  TextFieldDesign(
      {super.key,
      required this.hintText,
      this.suffixIcon,
      required this.controller,
      this.bdrClr,
      this.inputType = TextInputType.text});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: 20,
      ),
      child: Container(
        margin: EdgeInsets.symmetric(vertical: 5),
        decoration: BoxDecoration(
          color: const Color(0xFFF7F8F9),
          border: Border.all(
            color:bdrClr?? Color(0xFFE8ECF4),
          ),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Padding(
          padding: EdgeInsets.only(
            left: 10,
            right: 10,
          ),
          child: TextFormField(
            keyboardType: inputType,
            controller: controller,
            decoration: InputDecoration(
                border: InputBorder.none,
                hintText: hintText,
                hintStyle: TextStyle(
                  color: Color(0xFF8391A1),
                ),
                suffixIcon: suffixIcon),
          ),
        ),
      ),
    );
  }
}
