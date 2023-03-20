import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:on_audio_query/on_audio_query.dart';

class FavoriteDb extends ChangeNotifier {
  // static bool isGrid = false;
   bool isInitialized = false;
  static final musicDb = Hive.box<int>('FavoriteDB');
   List<SongModel> favoriteSongs = [];
  // static ValueNotifier<List<SongModel>> favoriteSongs = ValueNotifier([]);
  initialize(List<SongModel> songs) {
    for (SongModel song in songs) {
      if (isFavor(song)) {
        favoriteSongs.add(song);
      }
    }
    isInitialized = true;
  }

  bool _isGrid = false;
  bool get isGrid => _isGrid;

  void gridList() {
    _isGrid = !_isGrid;
    notifyListeners();
  }

 bool isFavor(SongModel song) {
    if (musicDb.values.contains(song.id)) {
      return true;
    }
    return false;
  }

  add(SongModel song) async {
    await musicDb.add(song.id);
    favoriteSongs.add(song);
    notifyListeners();
  }

  delete(int id) async {
    int deletekey = 0;
    if (!musicDb.values.contains(id)) {
      return;
    }
    final Map<dynamic, int> favorMap = musicDb.toMap();
    favorMap.forEach((key, value) {
      if (value == id) {
        deletekey = key;
      }
    });
    musicDb.delete(deletekey);
    favoriteSongs.removeWhere((song) => song.id == id);
    notifyListeners();
  }

  clear() async {
    // FavoriteDb.favoriteSongs.clear();
    favoriteSongs.clear();
    musicDb.clear();
    notifyListeners();
  }
}
