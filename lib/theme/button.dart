import 'package:flutter/material.dart';


bool isDark = false;

class SpecialButton extends StatelessWidget {
  const SpecialButton({super.key, required this.childIcon, this.border});

  final dynamic childIcon;
  final dynamic border;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8),
      child: Container(
        decoration: BoxDecoration(
          
          color: Colors.grey[300],
          borderRadius: BorderRadius.circular(12),
          
          border: border,
          boxShadow: [
            BoxShadow(
              color:  Colors.grey.shade500,
              offset: const Offset(5, 5),
              blurRadius: 15,
              spreadRadius: 1,
            ),
           const BoxShadow(
                color: Colors.white,
                offset:  Offset(-5, -5),
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
