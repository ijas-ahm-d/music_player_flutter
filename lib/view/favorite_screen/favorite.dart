import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:music_app/controllers/favorite_db.dart';
import 'package:music_app/utils/const/images.dart';
import 'package:music_app/view/home_screen/components/gridview_screen.dart';
import 'package:music_app/view/home_screen/components/listview_screen.dart';
import 'package:music_app/utils/const/colors.dart';
import 'package:music_app/utils/const/text_styles.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'package:provider/provider.dart';

class FavoritePage extends StatelessWidget {
  const FavoritePage({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<FavoriteDb>();
    provider.isInitialized;
   
    List<SongModel> favList = [];
    return Consumer<FavoriteDb>(
      builder: (context, provider, child) {
        return Scaffold(
          backgroundColor: Theme.of(context).scaffoldBackgroundColor,
          appBar: AppBar(
            title: const Text('Favorite songs'),
            actions: [
              IconButton(
                onPressed: () {
                  provider.gridList();
                },
                icon: provider.isGrid
                    ? const Icon(
                        Icons.format_list_bulleted,
                        color: AppColors.kblack,
                      )
                    : const Icon(
                        Icons.grid_view,
                        color: AppColors.kblack,
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
              builder: (context, songFavController, child) {
                final temp = songFavController.favoriteSongs.reversed.toList();
                favList = temp.toSet().toList();
                if (favList.isEmpty) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Lottie.asset(Lotties.noFavorite,
                            width: 200, height: 200),
                        Text(
                          'No Favorite Songs',
                          style: TextStyles.onText(
                            16,
                            FontWeight.bold,
                            AppColors.kblack,
                          ),
                        ),
                      ],
                    ),
                  );
                } else {
                  if (provider.isGrid) {
                    return GridViewScreen(songModel: favList);
                   
                  } else {
                     return ListViewScreen(
                        songModel: songFavController.favoriteSongs);
                  }
                }
              },
            ),
          ),
        );
      },
    );
  }
}
