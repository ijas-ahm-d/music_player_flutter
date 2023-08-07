import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hive_flutter/adapters.dart ';
import 'package:just_audio_background/just_audio_background.dart';
import 'package:music_app/model/musica_db.dart';
import 'package:music_app/utils/providers/provider_list.dart';
import 'package:music_app/utils/routes/navigations.dart';
import 'package:music_app/utils/theme_data.dart';
import 'package:provider/provider.dart';

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
    const MyApp(),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: ProviderList.provider,
      child: MaterialApp(
        title: 'Musica App',
        debugShowCheckedModeBanner: false,
        theme: ThemeDatas().themeData(),
        routes: Navigations.routes(),
        initialRoute: Navigations.splashScreen,
        navigatorKey: Navigations.navigatorKey,
      ),
    );
  }
}
