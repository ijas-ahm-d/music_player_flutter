import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hive_flutter/adapters.dart ';
import 'package:just_audio_background/just_audio_background.dart';
import 'package:music_app/controllers/favorite_db.dart';
import 'package:music_app/controllers/get_recent_song_controller.dart';
import 'package:music_app/controllers/playlist/playlist_controller.dart';
import 'package:music_app/controllers/playlist/playlist_db.dart';
import 'package:music_app/model/musica_db.dart';
import 'package:provider/provider.dart';
import 'package:music_app/controllers/song_model_provider.dart';
// import 'database/musica_db.dart';
import 'package:music_app/screens/splash_screen/splash.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  if (!Hive.isAdapterRegistered(MusicaModelAdapter().typeId)) {
    Hive.registerAdapter(MusicaModelAdapter());
  }
  await Hive.initFlutter();
  await Hive.openBox<int>('FavoriteDB');
  await Hive.openBox<MusicaModel>('playlistDb');
  await Hive.openBox('recentSongNotifier');

  SystemChrome.setPreferredOrientations(
      [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);

  await JustAudioBackground.init(
    androidNotificationChannelId: 'com.ryanheise.bg_demo.channel.audio',
    androidNotificationChannelName: 'Audio playback',
    androidNotificationOngoing: true,
  );

  runApp(
    MultiProvider(
      providers: [
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
      ],
      builder: (context, child) {
        return const MyApp();
      },
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Musica App',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
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
      ),
      // home:const MyWidget() ,
      home: const SplashPage(),
    );
  }
}
