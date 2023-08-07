import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:music_app/controllers/favorite_db.dart';
import 'package:music_app/controllers/song_model_provider.dart';
import 'package:music_app/view/splash/splash_screen.dart';
import 'package:provider/provider.dart';
import '../../model/musica_db.dart';

class PlaylistDb with ChangeNotifier {
  final List<MusicaModel> _playlistNotifier = [];
  List<MusicaModel> get playlistNotifier => _playlistNotifier;
  static final playlistDb = Hive.box<MusicaModel>('playlistDb');

  Future<void> addPlaylist(MusicaModel value) async {
    await playlistDb.add(value);
    _playlistNotifier.add(value);
    getAllPlaylist();
  }

  Future<void> getAllPlaylist() async {
    _playlistNotifier.clear();
    _playlistNotifier.addAll(playlistDb.values);
  }

  Future<void> deletePlaylist(int index) async {
    await playlistDb.deleteAt(index);
    getAllPlaylist();
  }

  Future<void> editPlaylist(int index, MusicaModel value) async {
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
    Provider.of<SongModelProvider>(context, listen: false).disposeIndex();
    Provider.of<SongModelProvider>(context, listen: false).disposeMiniScreen();

    Provider.of<FavoriteDb>(context, listen: false).clear();
    Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(
          builder: (context) => const SplashScreen(),
        ),
        (route) => false);
  }
}
