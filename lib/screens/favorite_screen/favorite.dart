import 'package:flutter/material.dart';
import 'package:music_app/screens/favorite_screen/favorite_db.dart';
import 'package:music_app/screens/home_screen/gridview_screen.dart';
import 'package:music_app/screens/home_screen/home.dart';
import 'package:music_app/screens/home_screen/listview_screen.dart';
import 'package:music_app/screens/main_screen/main_page.dart';
import 'package:on_audio_query/on_audio_query.dart';

class FavoritePage extends StatefulWidget {
  const FavoritePage({super.key});

  @override
  State<FavoritePage> createState() => _FavoritePageState();
}

class _FavoritePageState extends State<FavoritePage> {
  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: FavoriteDb.favoriteSongs,
      builder: (BuildContext ctx, List<SongModel> favoriteData, Widget? child) {
        return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
          appBar: AppBar(
            title: const Text('Favorite songs'),
            actions: [
              IconButton(
                onPressed: () {
                  setState(
                    () {
                      isGrid = !isGrid;
                    },
                  );
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
     
            child: ValueListenableBuilder(
              valueListenable: FavoriteDb.favoriteSongs,
              builder: (BuildContext ctx, List<SongModel> favoriteData,
                  Widget? child) {
                if (favoriteData.isEmpty) {
                  return  Center(
                    child: Text(
                      'No Favorite Songs',
                      style: title,
                    ),
                  );
                } else {
                  final temp = favoriteData.reversed.toList();
                  favoriteData = temp.toSet().toList();

                  return !isGrid
                      ? ListViewScreen(songModel: favoriteData)
                      : GridViewScreen(songModel: favoriteData);
                }
              },
            ),
          ),
        );
      },
    );
  }
}
