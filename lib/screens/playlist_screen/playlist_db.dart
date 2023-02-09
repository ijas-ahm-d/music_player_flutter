import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:music_app/database/musica_db.dart';
import 'package:music_app/screens/favorite_screen/favorite_db.dart';
import 'package:music_app/screens/splash_screen/splash.dart';

class PlaylistDb extends ChangeNotifier {
  static ValueNotifier<List<MusicaModel>> playlistNotifier = ValueNotifier([]);
  static final playlistDb = Hive.box<MusicaModel>('playlistDb');

  static Future<void> addPlaylist(MusicaModel value) async {
    final playlistDb = Hive.box<MusicaModel>('playlistDb');
    await playlistDb.add(value);
    playlistNotifier.value.add(value);
  }

  static Future<void> getAllPlaylist() async {
    final playlistDb = Hive.box<MusicaModel>('playlistDb');
    playlistNotifier.value.clear();
    playlistNotifier.value.addAll(playlistDb.values);
    playlistNotifier.notifyListeners();
  }

  static Future<void> deletePlaylist(int index) async {
    final playlistDb = Hive.box<MusicaModel>('playlistDb');
    await playlistDb.deleteAt(index);
    getAllPlaylist();
  }

  static Future<void> editPlaylist(int index, MusicaModel value) async {
    final playlistDb = Hive.box<MusicaModel>('playlistDb');
    await playlistDb.putAt(index, value);
    getAllPlaylist();
  }

  static Future<void> resetAPP(context) async {
    final playListDb = Hive.box<MusicaModel>('playlistDb');
    final musicDb = Hive.box<int>('FavoriteDB');
    final recentDb = Hive.box('recentSongNotifier');
    await musicDb.clear();
    await playListDb.clear();
    await recentDb.clear();

    FavoriteDb.favoriteSongs.value.clear();
    Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(
          builder: (context) => const SplashPage(),
        ),
        (route) => false);
  }

  
}
