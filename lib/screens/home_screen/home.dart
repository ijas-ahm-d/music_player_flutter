import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:music_app/controllers/get_all_song_controller.dart';
import 'package:music_app/screens/home_screen/gridview_screen.dart';
import 'package:music_app/screens/home_screen/listview_screen.dart';
import 'package:music_app/screens/main_screen/main_page.dart';
import 'package:music_app/screens/playing_screen/playing.dart';
import 'package:music_app/screens/search_screen/search_page.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'package:music_app/screens/favorite_screen/favorite_db.dart';
import 'package:permission_handler/permission_handler.dart';

TextStyle title = TextStyle(
    color:
        // isDark ? Colors.white :
        Colors.black,
    fontWeight: FontWeight.bold,
    fontSize: 16);
TextStyle artistStyle = TextStyle(
    color:
        // isDark?Colors.white38 :
        Colors.black38,
    fontSize: 14);

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

List<SongModel> startSong = [];

class _HomePageState extends State<HomePage> {
  final OnAudioQuery audioQuery = OnAudioQuery();
  final AudioPlayer audioPlayer = AudioPlayer();
  // bool isFavorite = false;
  // bool isFav = false;
  List<SongModel> allSongs = [];

  @override
  void initState() {
    requestPermission();
    super.initState();
  }

  void requestPermission() async {
    bool permissionStatus = await audioQuery.permissionsStatus();
    if (!permissionStatus) {
      await audioQuery.permissionsRequest();
    }
    setState(() {});

    Permission.storage.request();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: isDark ? Colors.grey[900] : Colors.grey[300],

//APPBAR
      appBar: AppBar(
        title: const Text('All songs'),
        actions: [
// Grid Button
          IconButton(
            onPressed: () {
              setState(
                () {
                  isGrid = !isGrid;
                },
              );
            },
            icon: isGrid
                ? const Icon(Icons.format_list_bulleted)
                : const Icon(Icons.grid_view),
          ),

// search button
          Padding(
            padding: const EdgeInsets.only(left: 10, right: 10),
            child: IconButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const SearchScreen(),
                  ),
                );
              },
              icon: const Icon(Icons.search),
            ),
          )
        ],
      ),
//BODY
      body: SizedBox(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        child: FutureBuilder<List<SongModel>>(
          future: audioQuery.querySongs(
            sortType: null,
            orderType: OrderType.ASC_OR_SMALLER,
            uriType: UriType.EXTERNAL,
            ignoreCase: true,
          ),
          builder: (context, item) {
            if (item.data == null) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }
            if (item.data!.isEmpty) {
              return Center(
                child: Text(
                  'No songs found',
                  style: title,
                ),
              );
            }
            startSong = item.data!;
            if (!FavoriteDb.isInitialized) {
              FavoriteDb.initialize(item.data!);
            }
            GetAllSongController.songscopy = item.data!;
            return !isGrid
// List view
                ? ListViewScreen(songModel: item.data!)
// Grid view
                : GridViewScreen(songModel: item.data!);
          },
        ),
      ),
    );
  }
}
