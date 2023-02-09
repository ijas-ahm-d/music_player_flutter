import 'package:flutter/material.dart';
// import 'package:music_app/screens/playing_screen/playing.dart';

class SpecialButton extends StatelessWidget {
  const SpecialButton(
      {super.key, required this.childIcon,this.border});

  final dynamic childIcon;
  // final dynamic colour;
  final dynamic border;

  @override
  Widget build(BuildContext context) {


    return Padding(
      padding: const EdgeInsets.all(8),
      child: Container(
        decoration: BoxDecoration(
          // color: colour,
          color:
          // isDark
          // ? Colors.grey[900]
          // :
          Colors.grey[300],
          borderRadius: BorderRadius.circular(12),
          // border: Border.all(color: Colors.purple,width: 3),
          border:border ,
          boxShadow: [
            BoxShadow(
              color:
              // isDark
              //  ?Colors.black
              //  :
               Colors.grey.shade500,
              offset: const Offset(5, 5),
              blurRadius: 15,
              spreadRadius: 1,
            ),
            BoxShadow(
                color:
                // isDark
                //  ?Colors.grey.shade800
                //  :
                 Colors.white,
                offset:const Offset(-5, -5),
                blurRadius: 15,
                spreadRadius: 1)
          ],
        ),
        child: Center(
          child: childIcon,
        ),
      ),
    );
  }
}
