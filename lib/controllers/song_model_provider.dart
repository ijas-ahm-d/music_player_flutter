import 'package:flutter/material.dart';

class SongModelProvider with ChangeNotifier {
  int _id = 0;

  int get id => _id;
  void setid(int id) {
    _id = id;
    notifyListeners();
  }

  int _currentIndex = 0;

  int get currentIndex => _currentIndex;

  pageIndex(value) {
    _currentIndex = value;
    notifyListeners();
  }

  disposeIndex() {
    _currentIndex = 0;
    notifyListeners();
  }

  bool _isPlayingSong = false;
  bool get isPlayingSong => _isPlayingSong;

  showMiniScreen() {
    _isPlayingSong = true;
    notifyListeners();
  }
  disposeMiniScreen() {
    _isPlayingSong = false;
    notifyListeners();
  }
}
