// import 'dart:developer';

import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:music_app/controllers/get_all_song_controller.dart';
// import 'package:music_app/controllers/get_all_song_controller.dart';
import 'package:music_app/screens/home_screen/gridview_screen.dart';
import 'package:music_app/screens/home_screen/listview_screen.dart';
import 'package:music_app/screens/playing_screen/playing.dart';
import 'package:music_app/screens/search_screen/search_page.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'package:music_app/controllers/favorite_db.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';

TextStyle title = const TextStyle(
    color: Colors.black, fontWeight: FontWeight.bold, fontSize: 16);
TextStyle artistStyle = const TextStyle(color: Colors.black38, fontSize: 14);

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

List<SongModel> startSong = [];

class _HomePageState extends State<HomePage> {
  final OnAudioQuery _audioQuery = OnAudioQuery();
  List<SongModel> allSongs = [];

  @override
  void initState() {
    requestPermission();
    super.initState();
  }

  void requestPermission() async {
    bool permissionStatus = await _audioQuery.permissionsStatus();
    if (!permissionStatus) {
      await _audioQuery.permissionsRequest();
    }
    setState(() {});
    Permission.storage.request();
  }

  @override
  Widget build(BuildContext context) {
    print("kdkd===================k");
    final isGrid = Provider.of<FavoriteDb>(context, listen: false).isGrid;
    // final songProvider = Provider.of<FavoriteDb>(context, listen: false);
    return Scaffold(
      backgroundColor: isDark ? Colors.grey[900] : Colors.grey[300],

//APPBAR
      appBar: AppBar(
        title: const Text('All songs'),
        actions: [
// Grid Button
          IconButton(
            onPressed: () {
              Provider.of<FavoriteDb>(context, listen: false).gridList();
              // setState(
              //   () {
              //     isGrid = !isGrid;
              //   },
              // );
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
      body: FutureBuilder<List<SongModel>>(
        future: _audioQuery.querySongs(
          sortType: null,
          orderType: OrderType.ASC_OR_SMALLER,
          uriType: UriType.EXTERNAL,
          ignoreCase: true,
        ),
        builder: (context, item) {
          if (item.data == null) {
            return const Center(
              child: CircularProgressIndicator(
                strokeWidth: 2,
              ),
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

          if (!Provider.of<FavoriteDb>(context, listen: false).isInitialized) {
            Provider.of<FavoriteDb>(context, listen: false)
                .initialize(item.data!);
          }
          GetAllSongController.songscopy = item.data!;

          return !isGrid
              ? ListViewScreen(songModel: item.data!)
              : GridViewScreen(songModel: item.data!);
        },
      ),
    );
  }
}
