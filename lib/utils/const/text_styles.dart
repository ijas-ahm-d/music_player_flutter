import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class TextStyles {
  static onText(double size, FontWeight fwght, Color clr) {
    return GoogleFonts.montserrat(
      letterSpacing: 2,
      fontSize: size,
      fontWeight: fwght,
      color: clr,
    );
  }

  static subText() {
    return const TextStyle(
        overflow: TextOverflow.ellipsis,
        color: Colors.black,
        fontSize: 16,
        fontWeight: FontWeight.bold);
  }
}
