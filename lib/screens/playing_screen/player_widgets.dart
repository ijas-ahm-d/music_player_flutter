import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:music_app/controllers/get_all_song_controller.dart';
import 'package:music_app/screens/playing_screen/playlist_icon.dart';
import 'package:music_app/theme/button.dart';
import 'package:on_audio_query/on_audio_query.dart';

class PlayingControls extends StatefulWidget {
  const PlayingControls({
    super.key,
    required this.favSongModel,
    required this.firstsong,
    required this.lastsong,
    required this.count,
  });
  final int count;
  final bool firstsong;
  final bool lastsong;
  final SongModel favSongModel;

  @override
  State<PlayingControls> createState() => _PlayingControlsState();
}

class _PlayingControlsState extends State<PlayingControls> {
  bool isPlaying = true;
  bool isShuffling = false;

  @override
  Widget build(BuildContext context) {
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
            PlaylistIcon(favsongModels: widget.favSongModel),
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
                        widget.firstsong
                            ? IconButton(
                                iconSize: 40,
                                onPressed: null,
                                icon: Icon(
                                  Icons.skip_previous,
                                  color: Colors.grey.withOpacity(0.4),
                                ),
                              )
                            : IconButton(
                                iconSize: 40,
                                onPressed: () {
                                  if (GetAllSongController
                                      .audioPlayer.hasPrevious) {
                                    GetAllSongController.audioPlayer
                                        .seekToPrevious();
                                  }
                                },
                                icon: const Icon(
                                  Icons.skip_previous,
                                ),
                              ),
                  ),
                ),
                Expanded(
                  flex: 2,
                  child: SpecialButton(
                    childIcon:
// play pause
                        IconButton(
                      onPressed: () {
                        if (mounted) {
                          setState(
                            () {
                              if (GetAllSongController.audioPlayer.playing) {
                                GetAllSongController.audioPlayer.pause();
                              } else {
                                GetAllSongController.audioPlayer.play();
                              }
                              isPlaying = !isPlaying;
                            },
                          );
                        }
                      },
                      icon: isPlaying
                          ? const Icon(Icons.pause)
                          : const Icon(Icons.play_arrow),
                      iconSize: 30,
                    ),
                  ),
                ),
                Expanded(
                  child: SpecialButton(
                    childIcon:
// skip to next
                        widget.lastsong
                            ? IconButton(
                                iconSize: 40,
                                onPressed: null,
                                icon: Icon(
                                  Icons.skip_next,
                                  color: Colors.grey.withOpacity(0.4),
                                ),
                              )
                            : IconButton(
                                iconSize: 40,
                                onPressed: () {
                                  if (GetAllSongController
                                      .audioPlayer.hasNext) {
                                    GetAllSongController.audioPlayer
                                        .seekToNext();
                                  }
                                },
                                icon: const Icon(
                                  Icons.skip_next,
                                ),
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
