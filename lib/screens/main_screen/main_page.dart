import 'package:flutter/material.dart';
import 'package:music_app/controllers/get_all_song_controller.dart';
import 'package:music_app/screens/mini_playing_screen/mini_player.dart';
import 'package:music_app/screens/recent_screen/recent.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'package:music_app/screens/favorite_screen/favorite.dart';
import 'package:music_app/screens/home_screen/home.dart';
import 'package:music_app/screens/playlist_screen/playlist.dart';
import 'package:music_app/screens/settings_screen/settings.dart';
import 'package:music_app/screens/favorite_screen/favorite_db.dart';

bool isGrid = false;


class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  int _currentIndex = 0;
  List<Widget> body = const [
    HomePage(),
    FavoritePage(),
    RecentPage(),
    PlaylistPage(),
    SettingsPage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(

      body: ValueListenableBuilder(
        valueListenable: FavoriteDb.favoriteSongs,
        builder: (context, List<SongModel> music, child) {
          return Stack(
            children: [
              body[_currentIndex],
              Positioned(
                bottom: 0,
                right: 0,
                left: 0,
                child: Column(
                  children: [
                    if (GetAllSongController.audioPlayer.currentIndex != null)
                      Column(
                        children: const [MiniPlayer()],
                      )
                    else
                      const SizedBox()
                  ],
                ),
              ),
            ],
          );
        },
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
        selectedIndex: _currentIndex,
        onDestinationSelected: (int newIndex) {
          setState(
            () {
              _currentIndex = newIndex;
            },
          );
        },
      ),
    );
  }
}
