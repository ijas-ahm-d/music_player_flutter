import 'package:flutter/material.dart';
import 'package:music_app/screens/favorite_screen/favorite_db.dart';
import 'package:on_audio_query/on_audio_query.dart';

class FavIcon extends StatefulWidget {
  const FavIcon({super.key, required this.songModel});
  final SongModel songModel;
  @override
  State<FavIcon> createState() => _FavIconState();
}

class _FavIconState extends State<FavIcon> {
  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: FavoriteDb.favoriteSongs,
      builder: (context, List<SongModel> favoriteData, child) {
        return IconButton(
          onPressed: () {
// if the song is in fav list
            if (FavoriteDb.isFavor(widget.songModel)) {
// remove from the fav
              FavoriteDb.delete(widget.songModel.id);
//fav removed snackbar
              final remove = SnackBar(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(25),
                ),
                width: MediaQuery.of(context).size.width * 3.5 / 5,
                behavior: SnackBarBehavior.floating,
                content: const Text(
                  'Song removed from favorites',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      color: Colors.white, fontWeight: FontWeight.w500),
                ),
                duration: const Duration(milliseconds: 850),
                backgroundColor: Colors.black,
              );
              ScaffoldMessenger.of(context).showSnackBar(remove);
            } else {
// add to fav song
              FavoriteDb.add(widget.songModel);
// add to fav snackbar
              final add = SnackBar(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(25),
                ),
                width: MediaQuery.of(context).size.width * 3.5 / 5,
                behavior: SnackBarBehavior.floating,
                backgroundColor: Colors.black,
                content: const Text(
                  'Song added to favorites',
                   textAlign: TextAlign.center,
                  style: TextStyle(
                      color: Colors.white, fontWeight: FontWeight.w500),
                ),
                duration: const Duration(milliseconds: 850),
              );
              ScaffoldMessenger.of(context).showSnackBar(add);
            }
            FavoriteDb.favoriteSongs.notifyListeners();
          },
// icon
          icon: FavoriteDb.isFavor(widget.songModel)
              ? const Icon(
                  Icons.favorite,
                  color: Colors.redAccent,
                )
              : const Icon(
                  Icons.favorite_outline,
                  color: Colors.white,
                ),
        );
      },
    );
  }
}
