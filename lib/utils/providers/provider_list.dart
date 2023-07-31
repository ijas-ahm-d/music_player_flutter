import 'package:music_app/controllers/favorite_db.dart';
import 'package:music_app/controllers/get_recent_song_controller.dart';
import 'package:music_app/controllers/nowPlaying/nowplaying_controller.dart';
import 'package:music_app/controllers/playlist/playlist_controller.dart';
import 'package:music_app/controllers/playlist/playlist_db.dart';
import 'package:music_app/controllers/song_model_provider.dart';
import 'package:provider/single_child_widget.dart';
import 'package:provider/provider.dart';

class ProviderList {
  static List<SingleChildWidget> provider = [
    ChangeNotifierProvider(
          create: (context) => SongModelProvider(),
        ),
         ChangeNotifierProvider(
          create: (context) => FavoriteDb(),
        ),
        ChangeNotifierProvider(
          create: (context) => GetRecentSongController(),
        ),
           ChangeNotifierProvider(
          create: (context) => PlaylistDb(),
        ),
           ChangeNotifierProvider(
          create: (context) => MusicPlaylistController(),
        ),
        ChangeNotifierProvider(
          create: (context) => NowPlayingController(),
        ),
        ChangeNotifierProvider(
          create: (context) => NowPlayingPageController(),
        ),
  ];
}
