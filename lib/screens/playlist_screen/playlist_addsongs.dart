import 'package:flutter/material.dart';
import 'package:music_app/controllers/playlist/playlist_controller.dart';
import 'package:music_app/screens/home_screen/home.dart';
import 'package:music_app/utils/special_button.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'package:provider/provider.dart';
import '../../model/musica_db.dart';

class PlaylistAddSong extends StatefulWidget {
  const PlaylistAddSong({super.key, required this.playlist});
  final MusicaModel playlist;
  @override
  State<PlaylistAddSong> createState() => _PlaylistAddSongState();
}

class _PlaylistAddSongState extends State<PlaylistAddSong> {
  bool isPlaying = true;
  final OnAudioQuery audioQuery = OnAudioQuery();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        title: const Text("Add songs"),
      ),
      body: FutureBuilder<List<SongModel>>(
        future: audioQuery.querySongs(
            sortType: null,
            orderType: OrderType.ASC_OR_SMALLER,
            uriType: UriType.EXTERNAL,
            ignoreCase: true),
        builder: (context, item) {
          if (item.data == null) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          if (item.data!.isEmpty) {
            return const Center(
              child: Text('No songs availble'),
            );
          }
          return ListView.builder(
            shrinkWrap: true,
            itemBuilder: (context, index) {
              return Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 2, horizontal: 10),
                child: Consumer<MusicPlaylistController>(
                  builder: (context, playlistProvider, child) {
                    return SpecialButton(
                      childIcon: ListTile(
                        leading: QueryArtworkWidget(
                          id: item.data![index].id,
                          type: ArtworkType.AUDIO,
                          artworkWidth: 50,
                          artworkHeight: 50,
                          keepOldArtwork: true,
                          artworkBorder: BorderRadius.circular(6),
                          nullArtworkWidget: Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(6),
                              color: Colors.purple.withOpacity(0.3),
                            ),
                            height: 50,
                            width: 50,
                            child: Icon(
                              Icons.music_note,
                              color: Colors.purple.withOpacity(0.5),
                            ),
                          ),
                        ),
                        title: Text(item.data![index].displayNameWOExt,
                            maxLines: 1, style: title),
                        subtitle: Text(
                          item.data![index].artist.toString(),
                          maxLines: 1,
                          style: artistStyle,
                        ),
                        trailing: SizedBox(
                          height: 60,
                          width: 60,
                          child: SpecialButton(
                            childIcon: !widget.playlist
                                    .isValueIn(item.data![index].id)
                                ? IconButton(
                                    onPressed: () {
                                      playlistProvider.addSongsToPlaylist(
                                          songModel: widget.playlist,
                                          data: item.data![index],
                                          context: context);
                                   
                                    },
                                    icon: Icon(
                                      Icons.add,
                                      color: Colors.purple.withOpacity(0.5),
                                    ),
                                  )
                                : IconButton(
                                    onPressed: () {
                                      playlistProvider.removeSongsFromPlaylist(
                                          songModel: widget.playlist,
                                          data: item.data![index], context: context);
                                      
                                    },
                                    icon: Icon(
                                      Icons.remove,
                                      color: Colors.purple.withOpacity(0.5),
                                    ),
                                  ),
                          ),
                        ),
                      ),
                    );
                  },
                ),
              );
            },
            itemCount: item.data!.length,
          );
        },
      ),
    );
  }

}
