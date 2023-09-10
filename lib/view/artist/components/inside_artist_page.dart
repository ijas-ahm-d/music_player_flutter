import 'package:flutter/material.dart';
import 'package:music_app/controllers/favorite_db.dart';
import 'package:music_app/view/home_screen/components/gridview_screen.dart';
import 'package:music_app/view/home_screen/components/listview_screen.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'package:provider/provider.dart';

class ArtistInsideList extends StatelessWidget {
  final String artistName;
  ArtistInsideList({
    super.key,
    required this.artistName,
  });
  final _audioQuery = OnAudioQuery();
  @override
  Widget build(BuildContext context) {
    final provider = context.watch<FavoriteDb>();
    String artist = artistName == "<unknown>" ? "Unknown artist" : artistName;
    return Scaffold(
      appBar: AppBar(
        title: Text(artist),
        actions: [
          IconButton(
            onPressed: () {
              provider.gridList();
            },
            icon: provider.isGrid
                ? const Icon(Icons.format_list_bulleted)
                : const Icon(Icons.grid_view),
          ),
          const SizedBox(
            width: 10,
          )
        ],
      ),
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: FutureBuilder<List<SongModel>>(
        future: _audioQuery.querySongs(
            ignoreCase: true,
            orderType: OrderType.ASC_OR_SMALLER,
            uriType: UriType.EXTERNAL),
        builder: (context, items) {
          if (items.data == null) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          List<SongModel> songByArtist =
              items.data!.where((song) => song.artist == artistName).toList();

          return provider.isGrid
              ? GridViewScreen(songModel: songByArtist)
              : ListViewScreen(songModel: songByArtist);
        },
      ),
    );
  }
}
