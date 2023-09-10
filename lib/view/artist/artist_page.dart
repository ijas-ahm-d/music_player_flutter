import 'package:flutter/material.dart';
import 'package:music_app/controllers/favorite_db.dart';
import 'package:music_app/utils/const/colors.dart';
import 'package:music_app/utils/const/text_styles.dart';
import 'package:music_app/view/artist/components/artist_grid.dart';
import 'package:music_app/view/artist/components/artist_list.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'package:provider/provider.dart';

class ArtistPage extends StatelessWidget {
  ArtistPage({super.key});
  final _audioQuery = OnAudioQuery();

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<FavoriteDb>();
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        title: const Text('Albums'),
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
      body: FutureBuilder<List<ArtistModel>>(
        future: _audioQuery.queryArtists(
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
                'No Artist found',
                style: TextStyles.onText(
                  16,
                  FontWeight.bold,
                  AppColors.kblack,
                ),
              ),
            );
          }

          return provider.isGrid
              ? ArtistGrid(item: item)
              : ArtistList(item: item);
        },
      ),
    );
  }
}
