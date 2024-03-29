import 'package:flutter/material.dart';
import 'package:music_app/components/special_button.dart';
import 'package:music_app/controllers/get_all_song_controller.dart';
import 'package:music_app/controllers/get_recent_song_controller.dart';
import 'package:music_app/controllers/song_model_provider.dart';
import 'package:music_app/view/favorite_screen/components/favicon.dart';
import 'package:music_app/view/playing_screen/playing.dart';
import 'package:music_app/utils/const/colors.dart';
import 'package:music_app/utils/const/text_styles.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'package:provider/provider.dart';

class ListViewScreen extends StatelessWidget {
  ListViewScreen(
      {super.key,
      required this.songModel,
      this.recentLength,
      this.isRecent = false});
  final List<SongModel> songModel;
  final dynamic recentLength;
  final bool isRecent;
  final List<SongModel> allSongs = [];

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      shrinkWrap: true,
      itemBuilder: (context, index) {
        allSongs.addAll(songModel);
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 2, horizontal: 10),
          child: SpecialButton(
            childIcon: Consumer<GetRecentSongController>(
              builder: (context, recentSong, child) {
                return ListTile(
                  leading: QueryArtworkWidget(
                    id: songModel[index].id,
                    type: ArtworkType.AUDIO,
                    artworkWidth: 50,
                    artworkHeight: 50,
                    keepOldArtwork: true,
                                    artworkFit: BoxFit.cover,

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
                  // title
                  title: Text(
                    songModel[index].displayNameWOExt,
                    maxLines: 1,
                    style: TextStyles.onText(
                      16,
                      FontWeight.bold,
                      AppColors.kblack,
                    ),
                  ),
                  // artist name
                  subtitle: Text(
                    songModel[index].artist.toString(),
                    maxLines: 1,
                    style: TextStyles.onText(
                      14,
                      FontWeight.w300,
                      AppColors.kblack.withOpacity(0.7),
                    ),
                  ),
                  //fav button
                  trailing: SizedBox(
                    height: 60,
                    width: 60,
                    child: SpecialButton(
                      childIcon: FavIcon(
                        songModel: songModel[index],
                      ),
                    ),
                  ),

                  // ontap to playing screen
                  onTap: () {
                    GetAllSongController.audioPlayer.play();
                    GetAllSongController.audioPlayer.setAudioSource(
                        GetAllSongController.createSongList(songModel),
                        initialIndex: index);
                    recentSong.addRecentlyPlayed(songModel[index].id);
                    context
                        .read<SongModelProvider>()
                        .setid(songModel[index].id);
                    Provider.of<SongModelProvider>(context, listen: false)
                        .showMiniScreen();

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
                );
              },
            ),
          ),
        );
      },
      itemCount: isRecent ? recentLength : songModel.length,
    );
  }
}
