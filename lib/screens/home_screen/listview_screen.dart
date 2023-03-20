import 'package:flutter/material.dart';
import 'package:music_app/controllers/get_all_song_controller.dart';
import 'package:music_app/controllers/get_recent_song_controller.dart';
import 'package:music_app/controllers/song_model_provider.dart';
import 'package:music_app/screens/favorite_screen/favicon.dart';
import 'package:music_app/screens/home_screen/home.dart';
import 'package:music_app/screens/playing_screen/playing.dart';
import 'package:music_app/theme/button.dart';
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
                  // image
                  leading: QueryArtworkWidget(
                    id: songModel[index].id,
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
                  // title
                  title: Text(songModel[index].displayNameWOExt,
                      maxLines: 1, style: title),
                  // artist name
                  subtitle: Text(
                    songModel[index].artist.toString(),
                    maxLines: 1,
                    style: artistStyle,
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
                    GetAllSongController.audioPlayer.setAudioSource(
                        GetAllSongController.createSongList(songModel),
                        initialIndex: index);
                    recentSong.addRecentlyPlayed(songModel[index].id);
                    // GetRecentSongController.addRecentlyPlayed(
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
