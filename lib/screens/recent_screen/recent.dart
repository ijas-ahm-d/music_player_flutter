import 'package:flutter/material.dart';
import 'package:music_app/controllers/get_recent_song_controller.dart';
import 'package:music_app/screens/home_screen/listview_screen.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'package:provider/provider.dart';

import '../../controllers/favorite_db.dart';
import '../home_screen/gridview_screen.dart';
import '../home_screen/home.dart';

// class RecentPage extends StatelessWidget {
//   RecentPage({Key? key}) : super(key: key);

//   final OnAudioQuery _audioQuery = OnAudioQuery();
//   static List<SongModel> recentSong = [];

//   @override
//   Widget build(BuildContext context) {
//     WidgetsBinding.instance.addPostFrameCallback((_) {
//       Provider.of<GetRecentSongController>(context, listen: false)
//           .getRecentSongs();
//     });
//     return Consumer<GetRecentSongController>(
//       builder: (context, recentSongs, child) {
//         return FutureBuilder(
//           future: recentSongs.getRecentSongs(),
//           builder: (context, items) {
//             final value = recentSongs.recentSongNotifier;
//             if (value.isEmpty) {
//               return const Center(
//                 child: Text(
//                   'No Song In Recents',
//                 ),
//               );
//             } else {
//               final temp = value.reversed.toList();
//               recentSong = temp.toSet().toList();
//               return FutureBuilder<List<SongModel>>(
//                 future: _audioQuery.querySongs(
//                   sortType: null,
//                   orderType: OrderType.ASC_OR_SMALLER,
//                   uriType: UriType.EXTERNAL,
//                   ignoreCase: true,
//                 ),
//                 builder: (context, items) {
//                   if (items.data == null) {
//                     return const Center(child: CircularProgressIndicator());
//                   }
//                   if (items.data!.isEmpty) {
//                     return const Center(
//                       child: Text(
//                         'No Song Available',
//                       ),
//                     );
//                   }
//                   return ListViewScreen(
//                     songModel: recentSong,
//                     isRecent: true,
//                     recentLength: recentSong.length > 8 ? 8 : recentSong.length,
//                   );
//                 },
//               );
//             }
//           },
//         );
//       },
//     );
//   }
// }

class RecentPage extends StatelessWidget {
  RecentPage({super.key});

  final OnAudioQuery _audioQuery = OnAudioQuery();
  static List<SongModel> recentSong = [];

  @override
  Widget build(BuildContext context) {
    final isGrid = Provider.of<FavoriteDb>(context).isGrid;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<GetRecentSongController>(context, listen: false)
          .getRecentSongs();
    });
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        title: const Text('Recently played'),
        actions: [
          IconButton(
            onPressed: () {
              Provider.of<FavoriteDb>(context, listen: false).gridList();
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
          const SizedBox(
            width: 10,
          )
        ],
      ),
      body: SizedBox(
        width: double.infinity,
        height: double.infinity,
        child: Consumer<GetRecentSongController>(
          builder: (context, recent, child) {
            return FutureBuilder(
              future: recent.getRecentSongs(),
              builder: (context, items) {
                final value = recent.recentSongNotifier;
                final temp = value.reversed.toList();
                recentSong = temp.toSet().toList();

                //  recent.getRecentSongs();
                if (recentSong.isEmpty) {
                  return Center(
                    child: Text(
                      recentSong.length.toString(),
                      style: title,
                    ),
                  );
                } else {
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
                          ? ListViewScreen(
                              songModel: recentSong,
                              isRecent: true,
                              recentLength:
                                  recentSong.length > 8 ? 8 : recentSong.length,
                            )
                          : GridViewScreen(
                              songModel: recentSong,
                              isRecent: true,
                              recentLength:
                                  recentSong.length > 8 ? 8 : recentSong.length,
                            );
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
