import 'package:flutter/material.dart';
import 'package:music_app/utils/const/colors.dart';

class CommonSnackbar {
  void snackBarShow(
    context,
    message,
  ) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(25),
        ),
        width: MediaQuery.of(context).size.width * 3.5 / 5,
// width: 100,
        behavior: SnackBarBehavior.floating,
        backgroundColor: AppColors.kblack,
        duration: const Duration(milliseconds: 750),
        content: Text(
          message,
          textAlign: TextAlign.center,
          style: const TextStyle(
            color: AppColors.kWhite,
          ),
        ),
      ),
    );
  }
}
