import 'package:flutter/material.dart';
import 'package:hive_flutter/adapters.dart%20';
import 'package:music_app/controllers/get_all_song_controller.dart';
import 'package:music_app/controllers/get_recent_song_controller.dart';
import 'package:music_app/database/musica_db.dart';
import 'package:music_app/provider/song_model_provider.dart';
import 'package:music_app/screens/home_screen/home.dart';
import 'package:music_app/screens/playing_screen/playing.dart';
import 'package:music_app/screens/playlist_screen/playlist_addsongs.dart';
import 'package:music_app/theme/button.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'package:provider/provider.dart';

class SinglePlaylist extends StatefulWidget {
  const SinglePlaylist(
      {super.key, required this.playlist, required this.findex});
  final MusicaModel playlist;
  final int findex;
  @override
  State<SinglePlaylist> createState() => _PlaylistListState();
}

class _PlaylistListState extends State<SinglePlaylist> {
  @override
  Widget build(BuildContext context) {
    late List<SongModel> songPlaylist;
    return ValueListenableBuilder(
      valueListenable: Hive.box<MusicaModel>('playlistDb').listenable(),
      builder: (BuildContext context, Box<MusicaModel> music, Widget? child) {
        songPlaylist =
            listPlaylist(music.values.toList()[widget.findex].songId);
        return Scaffold(
          backgroundColor: Theme.of(context).scaffoldBackgroundColor,
          floatingActionButton: FloatingActionButton(
            tooltip: "Add songs",
            backgroundColor: Colors.black54,
            child: const Icon(
              Icons.add,
              color: Colors.white,
            ),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => PlaylistAddSong(
                    playlist: widget.playlist,
                  ),
                ),
              );
            },
          ),
          body: CustomScrollView(
            slivers: [
              SliverAppBar(
                flexibleSpace: FlexibleSpaceBar(
                  title: Text(
                    widget.playlist.name,
                    style: const TextStyle(color: Colors.purple),
                  ),
                  background: Image.asset(
                    'assets/images/dp.jpg',
                    fit: BoxFit.cover,
                  ),
                ),
                pinned: true,
                expandedHeight: MediaQuery.of(context).size.width,
              ),
              SliverList(
                delegate: SliverChildListDelegate(
                  [
                    songPlaylist.isEmpty
                        ? const Center(
                            child: Text('Add some songs'),
                          )
                        : ListView.builder(
                            shrinkWrap: true,
                            physics: const ScrollPhysics(),
                            itemBuilder: (context, index) {
                              return Padding(
                                padding: const EdgeInsets.symmetric(
                                    vertical: 2, horizontal: 10),
                                child: SpecialButton(
                                  // colour: Colors.grey[300],
                                  childIcon: ListTile(
                                    leading: QueryArtworkWidget(
                                      id: songPlaylist[index].id,
                                      type: ArtworkType.AUDIO,
                                      artworkWidth: 50,
                                      artworkHeight: 50,
                                      keepOldArtwork: true,
                                      artworkBorder: BorderRadius.circular(6),
                                      nullArtworkWidget: Container(
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(6),
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
                                    title: Text(
                                        songPlaylist[index].displayNameWOExt,
                                        maxLines: 1,
                                        style: title),
                                    subtitle: Text(
                                      songPlaylist[index].artist.toString(),
                                      maxLines: 1,
                                      style: artistStyle,
                                    ),
                                    trailing: SizedBox(
                                      width: 60,
                                      height: 60,
                                      child: SpecialButton(
                                        // colour: Colors.grey[300],
                                        childIcon: IconButton(
                                          icon: Icon(
                                            Icons.remove,
                                            color:
                                                Colors.purple.withOpacity(0.5),
                                          ),
                                          onPressed: () {
                                            songDeleteFromPlaylist(
                                                songPlaylist[index]);
                                          },
                                        ),
                                      ),
                                    ),
                                    onTap: () {
                                      GetAllSongController.audioPlayer
                                          .setAudioSource(
                                              GetAllSongController
                                                  .createSongList(songPlaylist),
                                              initialIndex: index);
                                      GetRecentSongController.addRecentlyPlayed(
                                          songPlaylist[index].id);
                                      context
                                          .read<SongModelProvider>()
                                          .setid(songPlaylist[index].id);

                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => NowPlaying(
                                            songModel: songPlaylist,
                                            count: songPlaylist.length,
                                          ),
                                        ),
                                      );
                                    },
                                  ),
                                ),
                              );
                            },
                            itemCount: songPlaylist.length,
                          )
                  ],
                ),
              )
              // Image.asset('images/dp.jpg')
            ],
          ),
        );
      },
    );
  }

  void songDeleteFromPlaylist(SongModel data) {
    widget.playlist.deleteData(data.id);
    const removePlaylist = SnackBar(
        backgroundColor: Colors.black,
        content: Text(
          'Song deleted from Playlist',
          style: TextStyle(color: Colors.redAccent),
        ));
    ScaffoldMessenger.of(context).showSnackBar(removePlaylist);
  }

  List<SongModel> listPlaylist(List<int> data) {
    List<SongModel> plsongs = [];
    for (int i = 0; i < GetAllSongController.songscopy.length; i++) {
      for (int j = 0; j < data.length; j++) {
        if (GetAllSongController.songscopy[i].id == data[j]) {
          plsongs.add(GetAllSongController.songscopy[i]);
        }
      }
    }
    return plsongs;
  }
}
