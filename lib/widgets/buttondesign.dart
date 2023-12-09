import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ButtonDesign extends StatelessWidget {
final  void Function() onTap;
 final bool? loading;
 final String buttonText;
 final  Color? btnClr;
 final double? btnMgn;

  const ButtonDesign(
      {super.key,
      required this.buttonText,
      required this.onTap,
      this.btnClr,
      this.btnMgn,
      this.loading=false});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      highlightColor: Colors.white,
      splashColor: Colors.white,
      onTap: onTap,
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: btnMgn ?? 20),
        padding: const EdgeInsets.all(17),
        decoration: BoxDecoration(
            color: btnClr ?? Colors.black,
            borderRadius: const BorderRadius.all(Radius.circular(20))),
        child: Center(
            child: loading == false
                ? Text(buttonText,
                    style: GoogleFonts.b612(
                        textStyle: const TextStyle(
                            color: Colors.white, fontWeight: FontWeight.bold)))
                : const CircularProgressIndicator(
              color: Colors.black,
              backgroundColor: Colors.white,
            )),
      ),
    );
  }
}
