import 'package:flutter/material.dart';
import 'package:music_app/controllers/get_recent_song_controller.dart';
import 'package:music_app/screens/favorite_screen/favorite_db.dart';
import 'package:music_app/screens/home_screen/gridview_screen.dart';
import 'package:music_app/screens/home_screen/home.dart';
import 'package:music_app/screens/home_screen/listview_screen.dart';
import 'package:music_app/screens/main_screen/main_page.dart';
import 'package:on_audio_query/on_audio_query.dart';

class RecentPage extends StatefulWidget {
  const RecentPage({super.key});

  @override
  State<RecentPage> createState() => _RecentPageState();
}

class _RecentPageState extends State<RecentPage> {
  final OnAudioQuery _audioQuery = OnAudioQuery();
  static List<SongModel> recentSong = [];

  @override
  void initState() {
    init();
    super.initState();
  }

  Future init() async {
    await GetRecentSongController.getRecentSongs();
  }

  @override
  Widget build(BuildContext context) {
    FavoriteDb.favoriteSongs;
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,

      appBar: AppBar(
        title: const Text('Recently played'),
        actions: [
          IconButton(
            onPressed: () {
              setState(() {
                isGrid = !isGrid;
              });
            },
            icon: isGrid
                ? const Icon(
                    Icons.format_list_bulleted,
                    color: Colors.black,
                  )
                : const Icon(
                    Icons.grid_view,
                    color: Colors.black,
                  ),
          ),
        const  SizedBox(width: 10,)
        ],
      ),
      body: SizedBox(
        width: double.infinity,
        height: double.infinity,
        child: FutureBuilder(
          future: GetRecentSongController.getRecentSongs(),
          builder: (context, items) {
            return ValueListenableBuilder(
              valueListenable: GetRecentSongController.recentSongNotifier,
              builder: (context, List<SongModel> value, Widget? child) {
                if (value.isEmpty) {
                  return  Center(
                    child: Text('No Recent Songs',style: title,),
                  );
                } else {
                  final temp = value.reversed.toList();
                  recentSong = temp.toSet().toList();
                  return FutureBuilder<List<SongModel>>(
                    future: _audioQuery.querySongs(
                      sortType: null,
                      orderType: OrderType.ASC_OR_SMALLER,
                      uriType: UriType.EXTERNAL,
                      ignoreCase: true,
                    ),
                    builder: (context, items) {
                      if (items.data == null) {
                        return const Center(
                          child: CircularProgressIndicator(),
                        );
                      }
                      if (items.data!.isEmpty) {
                        return const Center(
                          child: Text(
                            'No songs available',
                            style: TextStyle(color: Colors.white),
                          ),
                        );
                      }
                      return !isGrid
                          ? ListViewScreen(songModel: recentSong,isRecent: true,recentLength: recentSong.length >8 ? 8:recentSong.length,)
                          : GridViewScreen(songModel: recentSong,isRecent: true,recentLength: recentSong.length >8 ? 8:recentSong.length,);
                    },
                  );
                }
              },
            );
          },
        ),
      ),
    );
  }
}
