import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:music_app/screens/home_screen/home.dart';
import 'package:on_audio_query/on_audio_query.dart';

class GetRecentSongController with ChangeNotifier {
  // static final recentDb = Hive.openBox('recentSongNotifier');
  final List<SongModel> _recentSongNotifier = [];
  List<SongModel> get recentSongNotifier => _recentSongNotifier;

  static List<dynamic> recentlyPlayed = [];

  Future<void> addRecentlyPlayed(item) async {
    final recentDb = await Hive.openBox('recentSongNotifier');
    await recentDb.add(item);
    getRecentSongs();
    notifyListeners();
  }

  Future<void> getRecentSongs() async {
    final recentDb = await Hive.openBox('recentSongNotifier');
    recentlyPlayed = recentDb.values.toList();
    displayRecents();
    notifyListeners();
  }

  Future<void> displayRecents() async {
    final recentDb = await Hive.openBox('recentSongNotifier');
    final recentSongItems = recentDb.values.toList();
    _recentSongNotifier.clear();
    // recentSongNotifier.clear();
    recentlyPlayed.clear();
    for (int i = 0; i < recentSongItems.length; i++) {
      for (int j = 0; j < startSong.length; j++) {
        if (recentSongItems[i] == startSong[j].id) {
          _recentSongNotifier.add(startSong[j]);
          recentlyPlayed.add(startSong[j]);
        }
      }
    }
  }
}
