import 'package:flutter/material.dart';
import 'package:music_app/controllers/nowPlaying/nowplaying_controller.dart';
import 'package:music_app/screens/favorite_screen/favicon.dart';
import 'package:music_app/screens/playing_screen/player_widgets.dart';
import 'package:music_app/utils/special_button.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'package:provider/provider.dart';
import 'package:text_scroll/text_scroll.dart';

class NowPlaying extends StatefulWidget {
  const NowPlaying({
    super.key,
    required this.songModel,
    this.count = 0,
  });
  final List<SongModel> songModel;
  final int count;

  @override
  State<NowPlaying> createState() => _NowPlayingState();
}

class _NowPlayingState extends State<NowPlaying> {

  

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<NowPlayingPageController>(context, listen: false)
          .initState(widget.count);
    });
    final nowPlayingController = context.watch<NowPlayingPageController>();
    final currentIndex = nowPlayingController.cuttentIndex;
    final duration = nowPlayingController.duration;
    final position = nowPlayingController.position;
    final firstSong = nowPlayingController.firstSong;
    final lastSong = nowPlayingController.lastSong;

    return Scaffold(
      backgroundColor: isDark ? Colors.grey[900] : Colors.grey[300],
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const NeverScrollableScrollPhysics(),
          child: Column(
            children: [
// Back Button
              Padding(
                padding: const EdgeInsets.only(left: 8.0, right: 8),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    SizedBox(
                      height: 60,
                      width: 60,
                      child: SpecialButton(
                        //  colour: Colors.grey[300],
                        childIcon: IconButton(
                          onPressed: () {
                            Navigator.pop(context);
                            isDark = false;
                          },
                          icon: const Icon(Icons.arrow_back),
                        ),
                      ),
                    ),
// title
                    const Text('N O W  P L A Y I N G'),
// Favorite

                    SizedBox(
                      height: 60,
                      width: 60,
                      child: SpecialButton(
                        childIcon: FavIcon(
                          songModel: widget.songModel[currentIndex],
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 20),
              Padding(
                padding: const EdgeInsets.only(right: 8.0, left: 8.0),
                child: SpecialButton(
                  childIcon: Column(
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
// image
                          child: QueryArtworkWidget(
                            id: widget.songModel[currentIndex].id,
                            type: ArtworkType.AUDIO,
                            artworkQuality: FilterQuality.high,
                            keepOldArtwork: true,
                            artworkWidth:
                                MediaQuery.of(context).size.width * 4 / 5,
                            artworkBorder: BorderRadius.circular(10),
                            artworkHeight:
                                MediaQuery.of(context).size.width * 4 / 5,
                            artworkFit: BoxFit.cover,
// null image
                            nullArtworkWidget: SizedBox(
                              height: MediaQuery.of(context).size.width * 4 / 5,
                              width: MediaQuery.of(context).size.width * 4 / 5,
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Image.asset(
                                  'assets/images/dp.jpg',
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(12),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(
                              width: MediaQuery.of(context).size.width * 2 / 3,
                              child: Center(
// title
                                child: TextScroll(
                                  widget
                                      .songModel[currentIndex].displayNameWOExt,
                                  style: const TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold),
                                  textAlign: TextAlign.center,
                                  mode: TextScrollMode.endless,
                                  velocity: const Velocity(
                                      pixelsPerSecond: Offset(40, 0)),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(
                height: 5,
              ),
// artist
              Center(
                child: Text(
                  widget.songModel[currentIndex].artist.toString() ==
                          '<unknown>'
                      ? "Unknown Artist"
                      : widget.songModel[currentIndex].artist.toString(),
                  overflow: TextOverflow.clip,
                  maxLines: 1,
                  style: const TextStyle(fontSize: 15),
                ),
              ),

// SLIDER
              Padding(
                padding: const EdgeInsets.only(left: 8.0, right: 8),
                child: SpecialButton(
                  childIcon: Slider(
                    inactiveColor: Colors.black26,
                    activeColor: Colors.black,
                    min: const Duration(microseconds: 0).inSeconds.toDouble(),
                    max: duration.inSeconds.toDouble(),
                    value: position.inSeconds.toDouble(),
                    onChanged: (value) {
                      Provider.of<NowPlayingController>(context,listen: false).changeSlider(value);
                    },
                  ),
                ),
              ),
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 28, vertical: 0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
//STARTING TIME
                    Text(
                      nowPlayingController.formatPosition,
                      style: Theme.of(context).textTheme.labelMedium,
                    ),
// ENDING TIME
                    Text(
                      nowPlayingController.formatDuration,
                      style: Theme.of(context).textTheme.labelMedium,
                    ),
                  ],
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              PlayingControls(
                songModel: widget.songModel[currentIndex],
                firstsong: firstSong,
                lastsong: lastSong,
                count: widget.count,
              ),
            ],
          ),
        ),
      ),
    );
  }

}
