import 'package:flutter/material.dart';

class ThemeDatas {
  themeData() {
    return ThemeData(
      useMaterial3: true,
      appBarTheme: const AppBarTheme(
        iconTheme: IconThemeData(color: Colors.black),
        toolbarHeight: 70,
        titleTextStyle: TextStyle(
          color: Colors.black,
          fontSize: 27,
          fontWeight: FontWeight.bold,
        ),
        backgroundColor: Colors.white,
        elevation: 1,
      ),
    );
  }
}
