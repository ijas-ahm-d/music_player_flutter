import 'package:flutter/material.dart';
import 'package:music_app/screens/favorite_screen/favorite_db.dart';
import 'package:on_audio_query/on_audio_query.dart';

class FavIcon extends StatefulWidget {
  const FavIcon({super.key,required this.songModel});
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
            if (FavoriteDb.isFavor(widget.songModel)) {
              FavoriteDb.delete(widget.songModel.id);
              const remove = SnackBar(
                content: Text(
                  'Song removed from favorites',
                  style: TextStyle(
                      color: Colors.redAccent, fontWeight: FontWeight.w500),
                ),
                duration: Duration(seconds: 1),
                backgroundColor: Colors.black,
              );
              ScaffoldMessenger.of(context).showSnackBar(remove);
            } else {
              FavoriteDb.add(widget.songModel);
              const add = SnackBar(
                backgroundColor: Colors.black,
                content: Text(
                  'Song added to favorites',
                  style: TextStyle(
                      color: Colors.greenAccent, fontWeight: FontWeight.w500),
                ),
                duration: Duration(seconds: 1),
              );
              ScaffoldMessenger.of(context).showSnackBar(add);
            }
            FavoriteDb.favoriteSongs.notifyListeners();
          },
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
