import 'package:flutter/material.dart';

class SongModelProvider with ChangeNotifier {
  int _id = 0;

  int get id => _id;
  void setid(int id) {
    _id = id;
    notifyListeners();
  }
}
