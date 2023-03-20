import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:music_app/controllers/favorite_db.dart';
import 'package:music_app/screens/splash_screen/splash.dart';
import 'package:provider/provider.dart';

import '../../model/musica_db.dart';

class PlaylistDb with ChangeNotifier {
  final List<MusicaModel> _playlistNotifier = [];
  List<MusicaModel> get playlistNotifier => _playlistNotifier;
  static final playlistDb = Hive.box<MusicaModel>('playlistDb');

  Future<void> addPlaylist(MusicaModel value) async {
    // final playlistDb = Hive.box<MusicaModel>('playlistDb');
    await playlistDb.add(value);
    _playlistNotifier.add(value);
    getAllPlaylist();
  }

  Future<void> getAllPlaylist() async {
    // final playlistDb = Hive.box<MusicaModel>('playlistDb');
    _playlistNotifier.clear();
    _playlistNotifier.addAll(playlistDb.values);
  }

  Future<void> deletePlaylist(int index) async {
    // final playlistDb = Hive.box<MusicaModel>('playlistDb');
    await playlistDb.deleteAt(index);
    getAllPlaylist();
  }

  Future<void> editPlaylist(int index, MusicaModel value) async {
    // final playlistDb = Hive.box<MusicaModel>('playlistDb');
    await playlistDb.putAt(index, value);
    getAllPlaylist();
  }

  Future<void> resetAPP(context) async {
    final playListDb = Hive.box<MusicaModel>('playlistDb');
    final musicDb = Hive.box<int>('FavoriteDB');
    final recentDb = Hive.box('recentSongNotifier');
    await musicDb.clear();
    await playListDb.clear();
    await recentDb.clear();

    Provider.of<FavoriteDb>(context, listen: false).clear();
    // FavoriteDb.favoriteSongs.clear();
    Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(
          builder: (context) => const SplashPage(),
        ),
        (route) => false);
  }
}
