import 'package:flutter/material.dart';
import 'package:music_app/components/common_snack_bar.dart';
import 'package:music_app/controllers/favorite_db.dart';
import 'package:music_app/utils/const/colors.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'package:provider/provider.dart';

class FavIcon extends StatelessWidget {
  const FavIcon({super.key, required this.songModel});
  final SongModel songModel;
  @override
  Widget build(BuildContext context) {
    return Consumer<FavoriteDb>(
      builder: (context, songFavController, child) {
        return IconButton(
          onPressed: () {
            if (songFavController.isFavor(songModel)) {
              songFavController.delete(songModel.id);

              CommonSnackbar().snackBarShow(
                context,
                'Song removed from favorites',
              );
            } else {
              songFavController.add(songModel);

              CommonSnackbar().snackBarShow(
                context,
                'Song added to favorites',
              );
            }
          },
// icon
          icon: songFavController.isFavor(songModel)
              ? const Icon(
                  Icons.favorite,
                  color: AppColors.spRed,
                )
              : const Icon(
                  Icons.favorite_outline,
                  color: Colors.grey,
                ),
        );
      },
    );
  }
}
