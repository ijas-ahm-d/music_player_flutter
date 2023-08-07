import 'package:music_app/components/common_snack_bar.dart';
import 'package:music_app/model/musica_db.dart';
import 'package:flutter/material.dart';
import 'package:on_audio_query/on_audio_query.dart';

class MusicPlaylistController with ChangeNotifier {

  addSongsToPlaylist(
      {required MusicaModel songModel,
      required SongModel data,
      required context}) {
    songModel.add(data.id);
    notifyListeners();
     CommonSnackbar(). snackBarShow(context, "Song Added");
  }

  removeSongsFromPlaylist(
      {required MusicaModel songModel,
      required SongModel data,
      required context}) {
    songModel.deleteData(data.id);
    notifyListeners();
     CommonSnackbar(). snackBarShow(context, "Song Removed");
  }
}
