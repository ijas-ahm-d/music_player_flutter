import 'package:flutter/material.dart';
import 'package:music_app/controllers/get_recent_song_controller.dart';
import 'package:music_app/screens/favorite_screen/favicon.dart';
import 'package:music_app/screens/home_screen/home.dart';
import 'package:music_app/screens/playing_screen/playing.dart';
import 'package:music_app/theme/button.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'package:provider/provider.dart';
import '../../controllers/get_all_song_controller.dart';
import '../../controllers/song_model_provider.dart';

class GridViewScreen extends StatelessWidget {
   GridViewScreen(
      {super.key,
      required this.songModel,
      this.isRecent = false,
      this.recentLength});
  final List<SongModel> songModel;
  final dynamic recentLength;
  final bool isRecent;

 final List<SongModel> allSongs = [];

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      shrinkWrap: true,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          childAspectRatio: 0.85,
          crossAxisSpacing: 2,
          mainAxisSpacing: 2),
      itemBuilder: (context, index) {
        allSongs.addAll(songModel);
        return Padding(
          padding: const EdgeInsets.all(4.0),
          child: Consumer<GetRecentSongController>(
            builder: (context, recentSong, child) {
              return InkWell(
                // ontap
                onTap: () {
                  GetAllSongController.audioPlayer.setAudioSource(
                      GetAllSongController.createSongList(songModel),
                      initialIndex: index);
                  recentSong.addRecentlyPlayed(songModel[index].id);
                  // GetRecentSongController

                  // .addRecentlyPlayed(
                  //     widget.songModel[index].id);
                  context
                      .read<SongModelProvider>()
                      .setid(songModel[index].id);
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => NowPlaying(
                        songModel: songModel,
                        count: songModel.length,
                      ),
                    ),
                  );
                },
                child: SpecialButton(
                  childIcon: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      children: [
                        // artwork widget
                        Container(
                          padding: const EdgeInsets.all(10),
                          child: QueryArtworkWidget(
                            id: songModel[index].id,
                            type: ArtworkType.AUDIO,
                            artworkBorder: BorderRadius.circular(6),
                            artworkWidth:
                                MediaQuery.of(context).size.height * 1 / 12,
                            artworkHeight:
                                MediaQuery.of(context).size.height * 1 / 12,
                            keepOldArtwork: true,
                            artworkFit: BoxFit.cover,
                            nullArtworkWidget: Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(6),
                                color: Colors.purple.withOpacity(0.3),
                              ),
                              height:
                                  MediaQuery.of(context).size.height * 1 / 12,
                              width:
                                  MediaQuery.of(context).size.height * 1 / 12,
                              child: Icon(Icons.music_note,
                                  color: Colors.purple.withOpacity(0.5),
                                  size: 50),
                            ),
                          ),
                        ),
                        // title
                        Padding(
                          padding: const EdgeInsets.fromLTRB(8, 0, 8, 0),
                          child: Container(
                            alignment: Alignment.center,
                            child: Text(
                              songModel[index].displayNameWOExt,
                              maxLines: 1,
                              style: title,
                            ),
                          ),
                        ),
                        // artist
                        Padding(
                          padding: const EdgeInsets.only(left: 8.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              SizedBox(
                                width:
                                    MediaQuery.of(context).size.width * 1 / 6,
                                child: Text(
                                  songModel[index].artist.toString(),
                                  maxLines: 1,
                                  style: artistStyle,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                              SizedBox(
                                width: 60,
                                height: 60,
                                child: SpecialButton(
                                  childIcon: FavIcon(
                                    songModel: songModel[index],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        );
      },
      itemCount:
          isRecent ? recentLength : songModel.length,
    );
  }
}
