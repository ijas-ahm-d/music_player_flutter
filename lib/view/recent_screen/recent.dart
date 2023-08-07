import 'package:flutter/material.dart';
import 'package:music_app/controllers/get_recent_song_controller.dart';
import 'package:music_app/view/home_screen/components/listview_screen.dart';
import 'package:music_app/utils/const/colors.dart';
import 'package:music_app/utils/const/text_styles.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'package:provider/provider.dart';
import '../../controllers/favorite_db.dart';
import '../home_screen/components/gridview_screen.dart';

class RecentPage extends StatelessWidget {
  RecentPage({super.key});

  final OnAudioQuery _audioQuery = OnAudioQuery();
  static List<SongModel> recentSong = [];

  @override
  Widget build(BuildContext context) {
    final proGrid = context.watch<FavoriteDb>();
    final proRecent = context.watch<GetRecentSongController>();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      proRecent.getRecentSongs();
    });
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        title: const Text('Recently played'),
        actions: [
          IconButton(
            onPressed: () {
              proGrid.gridList();
            },
            icon: proGrid.isGrid
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

                if (recentSong.isEmpty) {
                  return Center(
                    child: Text(
                      "No recent song found",
                      style: TextStyles.onText(
                        16,
                        FontWeight.bold,
                        AppColors.kblack,
                      ),
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
                            style: TextStyle(
                              color: AppColors.kblack,
                            ),
                          ),
                        );
                      }
                      return proGrid.isGrid
                          ? GridViewScreen(
                              songModel: recentSong,
                              isRecent: true,
                              recentLength:
                                  recentSong.length > 8 ? 8 : recentSong.length,
                            )
                          : ListViewScreen(
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
