import 'package:flutter/material.dart';
import 'package:hive_flutter/adapters.dart%20';
import 'package:lottie/lottie.dart';
import 'package:music_app/controllers/get_all_song_controller.dart';
import 'package:music_app/controllers/song_model_provider.dart';
import 'package:music_app/view/playing_screen/playing.dart';
import 'package:music_app/view/playlist_screen/playlist_addsongs.dart';
import 'package:music_app/utils/const/colors.dart';
import 'package:music_app/utils/const/text_styles.dart';
import 'package:music_app/components/special_button.dart';

import 'package:on_audio_query/on_audio_query.dart';
import 'package:provider/provider.dart';
import '../../model/musica_db.dart';

class SinglePlaylist extends StatelessWidget {
  const SinglePlaylist({
    super.key,
    required this.playlist,
    required this.findex,
  });
  final MusicaModel playlist;
  final int findex;

  @override
  Widget build(BuildContext context) {
    List<SongModel> songPlaylist;
    return ValueListenableBuilder(
      valueListenable: Hive.box<MusicaModel>('playlistDb').listenable(),
      builder: (BuildContext context, Box<MusicaModel> music, Widget? child) {
        songPlaylist = listPlaylist(music.values.toList()[findex].songId);
        return Scaffold(
          backgroundColor: Theme.of(context).scaffoldBackgroundColor,
          body: CustomScrollView(
            slivers: [
              SliverAppBar(
//pop button
                leading: IconButton(
                  icon: const Icon(
                    Icons.arrow_back,
                    color: Colors.white,
                    size: 32,
                  ),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                ),
                actions: [
// Add song
                  IconButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => PlaylistAddSong(
                            playlist: playlist,
                          ),
                        ),
                      );
                    },
                    icon: const Icon(
                      Icons.add,
                      color: Colors.white,
                      size: 32,
                    ),
                  ),
                  const SizedBox(
                    width: 20,
                  )
                ],
                flexibleSpace: FlexibleSpaceBar(
                  centerTitle: true,
//Title
                  title: Text(
                    playlist.name,
                    style: const TextStyle(color: Colors.white),
                  ),
                  expandedTitleScale: 2.9,
                  background: Image.asset(
                    'assets/images/playlist/playlistCoverPic.jpg',
                    fit: BoxFit.cover,
                  ),
                ),
                backgroundColor: Colors.purple.shade200,
                pinned: true,
                expandedHeight: MediaQuery.of(context).size.width * 2.5 / 4,
              ),
              SliverList(
                delegate: SliverChildListDelegate(
                  [
                    songPlaylist.isEmpty
                        ? Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                InkWell(
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => PlaylistAddSong(
                                          playlist: playlist,
                                        ),
                                      ),
                                    );
                                  },
                                  child: Lottie.asset(
                                    'assets/lottie/addPlaylist.json',
                                    width: 200,
                                  ),
                                ),
                                const Center(child: Text('Add some songs')),
                              ],
                            ),
                          )
                        : ListView.builder(
                            shrinkWrap: true,
                            physics: const ScrollPhysics(),
                            itemBuilder: (context, index) {
                              return Padding(
                                padding: const EdgeInsets.symmetric(
                                    vertical: 2, horizontal: 10),
                                child: SpecialButton(
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
                                      style: TextStyles.onText(
                                        16,
                                        FontWeight.bold,
                                        AppColors.kblack,
                                      ),
                                    ),
                                    subtitle: Text(
                                      songPlaylist[index].artist.toString(),
                                      maxLines: 1,
                                      style: TextStyles.onText(
                                        14,
                                        FontWeight.w300,
                                        AppColors.kblack.withOpacity(0.3),
                                      ),
                                    ),
                                    trailing: SizedBox(
                                      width: 60,
                                      height: 60,
                                      child: SpecialButton(
                                        childIcon: IconButton(
                                          icon: Icon(
                                            Icons.remove,
                                            color:
                                                Colors.purple.withOpacity(0.5),
                                          ),
                                          onPressed: () {
                                            songDeleteFromPlaylist(
                                                songPlaylist[index], context);
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
            ],
          ),
        );
      },
    );
  }

  void songDeleteFromPlaylist(SongModel data, context) {
    playlist.deleteData(data.id);
    final removePlaylist = SnackBar(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(25),
      ),
      width: MediaQuery.of(context).size.width * 3.5 / 5,
      behavior: SnackBarBehavior.floating,
      backgroundColor: Colors.black,
      content: const Text(
        'Song removed from Playlist',
        style: TextStyle(color: Colors.white),
      ),
      duration: const Duration(milliseconds: 550),
    );
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
