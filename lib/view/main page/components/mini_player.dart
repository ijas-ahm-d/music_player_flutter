import 'package:flutter/material.dart';
import 'package:music_app/components/special_button.dart';
import 'package:music_app/controllers/get_all_song_controller.dart';
import 'package:music_app/view/playing_screen/playing.dart';
import 'package:music_app/utils/const/colors.dart';
import 'package:music_app/utils/const/text_styles.dart';
import 'package:provider/provider.dart';
import 'package:text_scroll/text_scroll.dart';
import '../../../controllers/get_recent_song_controller.dart';

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
              border: Border.all(color: AppColors.appColor2, width: 3),
              childIcon: Stack(
                children: [
                  Consumer<GetRecentSongController>(
                      builder: (context, recentSong, child) {
                    return Row(
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
                                      style: TextStyles.onText(
                                        16,
                                        FontWeight.bold,
                                        AppColors.kblack,
                                      ),
                                      velocity: const Velocity(
                                        pixelsPerSecond: Offset(40, 0),
                                      ),
                                    );
                                  } else {
                                    return Text(
                                      GetAllSongController
                                          .playingSong[GetAllSongController
                                              .audioPlayer.currentIndex!]
                                          .displayNameWOExt,
                                      textAlign: TextAlign.center,
                                      style: TextStyles.subText(),
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
                                  color: AppColors.kblack,
                                ),
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
                                  recentSong.addRecentlyPlayed(
                                      GetAllSongController
                                          .playingSong[GetAllSongController
                                              .audioPlayer.currentIndex!]
                                          .id);

                                  if (GetAllSongController
                                      .audioPlayer.hasPrevious) {
                                    await GetAllSongController.audioPlayer
                                        .seekToPrevious();
                                    await GetAllSongController.audioPlayer
                                        .play();
                                  } else {
                                    await GetAllSongController.audioPlayer
                                        .play();
                                  }
                                },
                                icon: const Icon(Icons.skip_previous),
                                color: AppColors.appColor2,
                              ),

                        // play and Pause
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                              backgroundColor:
                                  AppColors.kWhite.withOpacity(0.8),
                              shape: const CircleBorder()),
                          onPressed: () async {
                            if (GetAllSongController.audioPlayer.playing) {
                              await GetAllSongController.audioPlayer.pause();
                            } else {
                              await GetAllSongController.audioPlayer.play();
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
                                  color: AppColors.appColor2,
                                  size: 35,
                                );
                              } else {
                                return Icon(
                                  Icons.play_circle,
                                  color: AppColors.appColor2,
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
                            Provider.of<GetRecentSongController>(
                              context,
                              listen: false,
                            ).addRecentlyPlayed(
                              GetAllSongController
                                  .playingSong[GetAllSongController
                                      .audioPlayer.currentIndex!]
                                  .id,
                            );
                            if (GetAllSongController.audioPlayer.hasNext) {
                              await GetAllSongController.audioPlayer
                                  .seekToNext();

                              await GetAllSongController.audioPlayer.play();
                            } else {
                              await GetAllSongController.audioPlayer.play();
                            }
                          },
                          icon: const Icon(
                            Icons.skip_next,
                            size: 32,
                          ),
                          color: AppColors.appColor2,
                        )
                      ],
                    );
                  })
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
