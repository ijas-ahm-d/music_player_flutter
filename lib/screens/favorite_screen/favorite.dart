// import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:music_app/controllers/favorite_db.dart';
import 'package:music_app/screens/home_screen/gridview_screen.dart';
import 'package:music_app/screens/home_screen/home.dart';
import 'package:music_app/screens/home_screen/listview_screen.dart';
// import 'package:music_app/screens/main_screen/main_page.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'package:provider/provider.dart';


class FavoritePage extends StatelessWidget {
  const FavoritePage({super.key});

  @override
  Widget build(BuildContext context) {
    final isGrid = Provider.of<FavoriteDb>(context).isGrid;
    Provider.of<FavoriteDb>(context,listen: false).isInitialized;
    List<SongModel> favList = [];
    return Consumer<FavoriteDb>(
      // valueListenable: FavoriteDb.favoriteSongs,
      builder: (context, provider, child) {
        return Scaffold(
          backgroundColor: Theme.of(context).scaffoldBackgroundColor,
// appbar
          appBar: AppBar(
            title: const Text('Favorite songs'),
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
            child: Consumer<FavoriteDb>(
              // valueListenable: FavoriteDb.favoriteSongs,
              builder: (context, songFavController, child) {
//if there is no favorite songs

                final temp = songFavController.favoriteSongs.reversed.toList();
                favList = temp.toSet().toList();
                // print(object)

                if (favList.isEmpty) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Lottie.asset('assets/lottie/FavIcon.json',
                            width: 200, height: 200),
                        Text(
                          'No Favorite Songs',
                          style: title,
                        ),
                      ],
                    ),
                  );
                } else {
                  if (!isGrid) {
                    return ListViewScreen(
                        songModel: songFavController.favoriteSongs);
                  } else {
                    return GridViewScreen(songModel: favList);
                  }

                  // !isGrid
                  //     ? ListViewScreen(songModel: favList)
                  //     : GridViewScreen(songModel: favList);
                }
              },
            ),
          ),
        );
      },
    );
  }
}
