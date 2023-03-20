import 'package:flutter/material.dart';
import 'package:music_app/controllers/favorite_db.dart';
import 'package:music_app/screens/playlist_screen/playlist.dart';
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
// if the song is in fav list
            if (songFavController.isFavor(songModel)) {
// remove from the fav
              songFavController.delete(songModel.id);
//fav removed snackbar
              snackBarShow(
                context,
                'Song removed from favorites',
              );
              // final remove = SnackBar(
              //   shape: RoundedRectangleBorder(
              //     borderRadius: BorderRadius.circular(25),
              //   ),
              //   width: MediaQuery.of(context).size.width * 3.5 / 5,
              //   behavior: SnackBarBehavior.floating,
              //   content: const Text(
              //     'Song removed from favorites',
              //     textAlign: TextAlign.center,
              //     style: TextStyle(
              //         color: Colors.white, fontWeight: FontWeight.w500),
              //   ),
              //   duration: const Duration(milliseconds: 850),
              //   backgroundColor: Colors.black,
              // );
              // ScaffoldMessenger.of(context).showSnackBar(remove);
            } else {
// add to fav song
              songFavController.add(songModel);
// add to fav snackbar
              snackBarShow(context, 'Song added to favorites',);
              // final add = SnackBar(
              //   shape: RoundedRectangleBorder(
              //     borderRadius: BorderRadius.circular(25),
              //   ),
              //   width: MediaQuery.of(context).size.width * 3.5 / 5,
              //   behavior: SnackBarBehavior.floating,
              //   backgroundColor: Colors.black,
              //   content: const Text(
              //     'Song added to favorites',
              //     textAlign: TextAlign.center,
              //     style: TextStyle(
              //         color: Colors.white, fontWeight: FontWeight.w500),
              //   ),
              //   duration: const Duration(milliseconds: 850),
              // );
              // ScaffoldMessenger.of(context).showSnackBar(add);
            }
            // FavoriteDb.favoriteSongs.notifyListeners();
          },
// icon
          icon: songFavController.isFavor(songModel)
              ? const Icon(
                  Icons.favorite,
                  color: Colors.redAccent,
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
