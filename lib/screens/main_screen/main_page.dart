import 'package:flutter/material.dart';
import 'package:music_app/controllers/get_all_song_controller.dart';
import 'package:music_app/screens/mini_playing_screen/mini_player.dart';
import 'package:music_app/screens/recent_screen/recent.dart';
// import 'package:on_audio_query/on_audio_query.dart';
import 'package:music_app/screens/favorite_screen/favorite.dart';
import 'package:music_app/screens/home_screen/home.dart';
import 'package:music_app/screens/playlist_screen/playlist.dart';
import 'package:music_app/screens/settings_screen/settings.dart';
import 'package:provider/provider.dart';

// import '../../controllers/favorite_db.dart';
import '../../controllers/song_model_provider.dart';

// import 'package:music_app/screens/favorite_screen/favorite_db.dart';
class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  List<Widget> body = [
    const HomePage(),
    const FavoritePage(),
    RecentPage(),
    const PlaylistPage(),
    const SettingsPage(),
  ];

  @override
  Widget build(BuildContext context) {
    final currentIndex = Provider.of<SongModelProvider>(context).currentIndex;
    final isPlayingSong = Provider.of<SongModelProvider>(context).isPlayingSong;

    return Scaffold(
      body: Stack(
        children: [
          body[currentIndex],
          Visibility(
            visible: isPlayingSong,
            child: Positioned(
              bottom: 0,
              right: 0,
              left: 0,
              child: Column(
                children: [
                  if (GetAllSongController.audioPlayer.currentIndex != null &&
                      currentIndex != 4)
                   const Column(
                      children:  [MiniPlayer()],
                    )
                  else
                    const SizedBox()
                ],
              ),
            ),
          ),
        ],
      ),

//BOTTOM NAVIGATON BAR
      bottomNavigationBar: NavigationBar(
        elevation: 5,
        backgroundColor: Colors.white.withOpacity(0.8),
        destinations: const [
          NavigationDestination(
            icon: Icon(
              Icons.home_outlined,
            ),
            selectedIcon: Icon(Icons.home),
            label: 'Home',
          ),
          NavigationDestination(
            icon: Icon(Icons.favorite_outline),
            label: 'Favorite',
            selectedIcon: Icon(Icons.favorite, color: Colors.redAccent),
          ),
          NavigationDestination(
            icon: Icon(Icons.history),
            label: 'Recent',
          ),
          NavigationDestination(
              icon: Icon(Icons.playlist_play_outlined), label: 'Playlist'),
          NavigationDestination(
              icon: Icon(Icons.settings_outlined),
              selectedIcon: Icon(Icons.settings),
              label: 'Settings'),
        ],
        selectedIndex: currentIndex,
        onDestinationSelected: (int newIndex) {
          Provider.of<SongModelProvider>(context, listen: false)
              .pageIndex(newIndex);
        },
      ),
    );
  }
}
