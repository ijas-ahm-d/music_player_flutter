import 'package:flutter/material.dart';
import 'package:music_app/controllers/get_all_song_controller.dart';
import 'package:music_app/screens/home_screen/home.dart';
import 'package:music_app/screens/playing_screen/playing.dart';
import 'package:provider/provider.dart';
import 'package:text_scroll/text_scroll.dart';
import '../../controllers/get_recent_song_controller.dart';
import '../../theme/button.dart';

class MiniPlayer extends StatefulWidget {
  const MiniPlayer({
    Key? key,
  }) : super(key: key);
  @override
  State<MiniPlayer> createState() => _MiniPlayerState();
}

bool firstSong = false;

bool isPlaying = false;

class _MiniPlayerState extends State<MiniPlayer> {
  @override
  void initState() {
    GetAllSongController.audioPlayer.currentIndexStream.listen(
      (index) {
        if (index != null && mounted) {
          setState(
            () {
              index == 0 ? firstSong = true : firstSong = false;
            },
          );
        }
      },
    );

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => NowPlaying(
              songModel: GetAllSongController.playingSong,
            ),
          ),
        );
      },
      child: Align(
        alignment: Alignment.bottomCenter,
        child: Padding(
          padding: const EdgeInsets.only(left: 8.0, right: 8, bottom: 0),
          child: SizedBox(
            height: 80,
            width: MediaQuery.of(context).size.width,
            child: SpecialButton(
              border: Border.all(color: Colors.purple, width: 3),
              childIcon: Stack(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Container(
                        margin: const EdgeInsets.only(left: 10),
                        width: MediaQuery.of(context).size.width * 1.5 / 4,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            StreamBuilder<bool>(
                              stream: GetAllSongController
                                  .audioPlayer.playingStream,
                              builder: (context, snapshot) {
                                bool? playingStage = snapshot.data;
                                if (playingStage != null && playingStage) {
                                  return TextScroll(
                                    GetAllSongController
                                        .playingSong[GetAllSongController
                                            .audioPlayer.currentIndex!]
                                        .displayNameWOExt,
                                    textAlign: TextAlign.center,
                                    style: title,
                                    velocity: const Velocity(
                                        pixelsPerSecond: Offset(40, 0)),
                                  );
                                } else {
                                  return Text(
                                    GetAllSongController
                                        .playingSong[GetAllSongController
                                            .audioPlayer.currentIndex!]
                                        .displayNameWOExt,
                                    textAlign: TextAlign.center,
                                    style: const TextStyle(
                                        overflow: TextOverflow.ellipsis,
                                        color: Colors.black,
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold),
                                  );
                                }
                              },
                            ),
                            TextScroll(
                              GetAllSongController
                                          .playingSong[GetAllSongController
                                              .audioPlayer.currentIndex!]
                                          .artist
                                          .toString() ==
                                      "<unknown>"
                                  ? "Unknown Artist"
                                  : GetAllSongController
                                      .playingSong[GetAllSongController
                                          .audioPlayer.currentIndex!]
                                      .artist
                                      .toString(),
                              style: const TextStyle(
                                  fontFamily: 'poppins',
                                  fontSize: 10,
                                  color: Colors.black),
                              mode: TextScrollMode.endless,
                            ),
                          ],
                        ),
                      ),
// recent
                      firstSong
                          ? IconButton(
                              iconSize: 32,
                              onPressed: null,
                              icon: Icon(
                                Icons.skip_previous,
                                color: Colors.grey.withOpacity(0.4),
                              ),
                            )
                          : IconButton(
                              iconSize: 32,
                              onPressed: () async {
                                // GetRecentSongController.addRecentlyPlayed(
                                //     GetAllSongController
                                //         .playingSong[GetAllSongController
                                //             .audioPlayer.currentIndex!]
                                //         .id);
                                if (GetAllSongController
                                    .audioPlayer.hasPrevious) {
                                  await GetAllSongController.audioPlayer
                                      .seekToPrevious();
                                  await GetAllSongController.audioPlayer.play();
                                } else {
                                  await GetAllSongController.audioPlayer.play();
                                }
                              },
                              icon: const Icon(Icons.skip_previous),
                              color: Colors.purple.withOpacity(0.7),
                            ),
// play and Pause
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.white.withOpacity(0.8),
                            shape: const CircleBorder()),
                        onPressed: () async {
                          setState(() {
                            isPlaying = !isPlaying;
                          });
                          if (GetAllSongController.audioPlayer.playing) {
                            await GetAllSongController.audioPlayer.pause();
                            setState(() {});
                          } else {
                            await GetAllSongController.audioPlayer.play();
                            setState(() {});
                          }
                        },
                        child: StreamBuilder<bool>(
                          stream:
                              GetAllSongController.audioPlayer.playingStream,
                          builder: (context, snapshot) {
                            bool? playingStage = snapshot.data;
                            if (playingStage != null && playingStage) {
                              return Icon(
                                Icons.pause_circle,
                                color: Colors.purple.withOpacity(0.7),
                                size: 35,
                              );
                            } else {
                              return Icon(
                                Icons.play_circle,
                                color: Colors.purple.withOpacity(0.7),
                                size: 35,
                              );
                            }
                          },
                        ),
                      ),
// next
                      IconButton(
                        iconSize: 35,
                        onPressed: () async {
                           Provider.of<GetRecentSongController>(context,listen: false).addRecentlyPlayed(GetAllSongController
                                      .playingSong[GetAllSongController
                                          .audioPlayer.currentIndex!].id);
                          // GetRecentSongController.addRecentlyPlayed(
                          //     GetAllSongController
                          //         .playingSong[GetAllSongController
                          //             .audioPlayer.currentIndex!]
                          //         .id);
                          if (GetAllSongController.audioPlayer.hasNext) {
                            await GetAllSongController.audioPlayer.seekToNext();
                           
                            await GetAllSongController.audioPlayer.play();
                          } else {
                            await GetAllSongController.audioPlayer.play();
                          }
                        },
                        icon: const Icon(
                          Icons.skip_next,
                          size: 32,
                        ),
                        color: Colors.purple.withOpacity(0.7),
                      )
                    ],
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
