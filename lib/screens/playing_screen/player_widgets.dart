import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:music_app/controllers/get_all_song_controller.dart';
import 'package:music_app/controllers/get_recent_song_controller.dart';
import 'package:music_app/screens/playing_screen/playlist_icon.dart';
import 'package:music_app/screens/playing_screen/widgets/song_playpause.dart';
import 'package:music_app/utils/special_button.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'package:provider/provider.dart';

import '../../controllers/nowPlaying/nowplaying_controller.dart';

// ignore: must_be_immutable
class PlayingControls extends StatelessWidget {
  
   PlayingControls({
    super.key,
    required this.songModel,
    required this.firstsong,
    required this.lastsong,
    required this.count,
  });
  final int count;
  final bool firstsong;
  final bool lastsong;
  final SongModel songModel;

  bool isPlaying = true;

  bool isShuffling = false;

  @override
  Widget build(BuildContext context) {
     WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<NowPlayingPageController>(context, listen: false)
          .initState(count);
    });
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
// shuffle
            IconButton(
              onPressed: () {
                isShuffling == false
                    ? GetAllSongController.audioPlayer
                        .setShuffleModeEnabled(true)
                    : GetAllSongController.audioPlayer
                        .setShuffleModeEnabled(false);
              },
              icon: StreamBuilder<bool>(
                stream:
                    GetAllSongController.audioPlayer.shuffleModeEnabledStream,
                builder: (BuildContext context, AsyncSnapshot snapshot) {
                  if (snapshot.hasData) {
                    isShuffling = snapshot.data;
                  }
                  if (isShuffling) {
                    return Icon(
                      Icons.shuffle_rounded,
                      color: Colors.purple[300],
                    );
                  } else {
                    return const Icon(
                      Icons.shuffle_rounded,
                    );
                  }
                },
              ),
            ),

// repeat
            IconButton(
              onPressed: () {
                GetAllSongController.audioPlayer.loopMode == LoopMode.one
                    ? GetAllSongController.audioPlayer.setLoopMode(LoopMode.all)
                    : GetAllSongController.audioPlayer
                        .setLoopMode(LoopMode.one);
              },
              icon: StreamBuilder<LoopMode>(
                stream: GetAllSongController.audioPlayer.loopModeStream,
                builder: (context, snapshot) {
                  final loopMode = snapshot.data;
                  if (LoopMode.one == loopMode) {
                    return Icon(
                      Icons.repeat_one,
                      color: Colors.purple[300],
                    );
                  } else {
                    return const Icon(
                      Icons.repeat,
                      color: Colors.black,
                    );
                  }
                },
              ),
            ),
// Playlist
            PlaylistIcon(favsongModels: songModel),
          ],
        ),
        const SizedBox(
          height: 15,
        ),
        SizedBox(
          height: 80,
          child: Padding(
            padding: const EdgeInsets.only(left: 8.0, right: 8),
            child: Row(
              children: [
                Expanded(
                  child: SpecialButton(
                    childIcon:
// Previous songs
                        firstsong
                            ? IconButton(
                                iconSize: 40,
                                onPressed: null,
                                icon: Icon(
                                  Icons.skip_previous,
                                  color: Colors.grey.withOpacity(0.4),
                                ),
                              )
                            : Consumer<GetRecentSongController>(
                                builder: (context, recentSong, child) {
                                  return IconButton(
                                    iconSize: 40,
                                    onPressed: () {
                                      if (GetAllSongController
                                          .audioPlayer.hasPrevious) {
                                        recentSong.addRecentlyPlayed(
                                            GetAllSongController
                                                .playingSong[
                                                    GetAllSongController
                                                        .audioPlayer
                                                        .currentIndex!]
                                                .id);
                                        GetAllSongController.audioPlayer
                                            .seekToPrevious();
                                      }
                                    },
                                    icon: const Icon(
                                      Icons.skip_previous,
                                    ),
                                  );
                                },
                              ),
                  ),
                ),
                Expanded(

                  flex: 2,
                  child:SpecialButton(childIcon:
                   SongPauseButton(songModel: songModel, iconPlay:  const Icon(
                  Icons.play_arrow,
                  color: Colors.black,
                  size: 35,
                ), iconPause:  const Icon(
                  Icons.pause,
                  color: Colors.black,
                  size: 35,
                ),)
                
                
                )
                  
                ),
                Expanded(
                  child: SpecialButton(
                    childIcon:
// skip to next
                        lastsong
                            ? IconButton(
                                iconSize: 40,
                                onPressed: null,
                                icon: Icon(
                                  Icons.skip_next,
                                  color: Colors.grey.withOpacity(0.4),
                                ),
                              )
                            : Consumer<GetRecentSongController>(
                                builder: (context, recentSong, child) {
                                  return IconButton(
                                    iconSize: 40,
                                    onPressed: () {
                                      if (GetAllSongController
                                          .audioPlayer.hasNext) {
                                        recentSong.addRecentlyPlayed(
                                            GetAllSongController
                                                .playingSong[
                                                    GetAllSongController
                                                        .audioPlayer
                                                        .currentIndex!]
                                                .id);
                                        GetAllSongController.audioPlayer
                                            .seekToNext();
                                      }
                                    },
                                    icon: const Icon(
                                      Icons.skip_next,
                                    ),
                                  );
                                },
                              ),
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(
          height: 20,
        )
      ],
    );
  }
}
