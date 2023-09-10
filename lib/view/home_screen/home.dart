import 'package:flutter/material.dart';
import 'package:music_app/controllers/get_all_song_controller.dart';
import 'package:music_app/view/home_screen/components/gridview_screen.dart';
import 'package:music_app/view/home_screen/components/listview_screen.dart';
import 'package:music_app/utils/const/colors.dart';
import 'package:music_app/utils/const/text_styles.dart';
import 'package:music_app/utils/routes/navigations.dart';
import 'package:music_app/view/settings_screen/settings.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'package:music_app/controllers/favorite_db.dart';
import 'package:provider/provider.dart';

List<SongModel> allSongs = [];
List<SongModel> startSong = [];

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
    final OnAudioQuery audioQuery = OnAudioQuery();
    final provider = context.watch<FavoriteDb>();
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      drawer: const SettingsPage(),
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            _scaffoldKey.currentState!.openDrawer() ;
          },
          icon: const Icon(
            Icons.settings_outlined,
          ),
        ),
        title: const Text('All songs'),
        actions: [
          IconButton(
            onPressed: () {
              provider.gridList();
            },
            icon: provider.isGrid
                ? const Icon(Icons.format_list_bulleted)
                : const Icon(Icons.grid_view),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 10,
            ),
            child: IconButton(
              onPressed: () {
                Navigator.pushNamed(
                  context,
                  Navigations.searchScreen,
                );
              },
              icon: const Icon(
                Icons.search,
              ),
            ),
          )
        ],
      ),
//BODY
      body: FutureBuilder<List<SongModel>>(
        future: audioQuery.querySongs(
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
                style: TextStyles.onText(
                  16,
                  FontWeight.bold,
                  AppColors.kblack,
                ),
              ),
            );
          }

          if (!provider.isInitialized) {
            provider.initialize(item.data!);
          }
          GetAllSongController.songscopy = item.data!;
          startSong = item.data!;

          return provider.isGrid
              ? GridViewScreen(songModel: item.data!)
              : ListViewScreen(songModel: item.data!);
        },
      ),
    );
  }
}
