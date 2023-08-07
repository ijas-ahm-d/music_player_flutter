import 'package:flutter/material.dart';
import 'package:music_app/controllers/get_all_song_controller.dart';
import 'package:music_app/view/main%20page/components/mini_player.dart';
import 'package:music_app/view/recent_screen/recent.dart';
import 'package:music_app/view/favorite_screen/favorite.dart';
import 'package:music_app/view/home_screen/home.dart';
import 'package:music_app/view/playlist_screen/playlist.dart';
import 'package:music_app/view/settings_screen/settings.dart';
import 'package:music_app/utils/const/colors.dart';
import 'package:provider/provider.dart';
import '../../../controllers/song_model_provider.dart';

List<Widget> body = [
  const HomePage(),
  const FavoritePage(),
  RecentPage(),
  const PlaylistPage(),
  const SettingsPage(),
];

class MainPage extends StatelessWidget {
  const MainPage({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<SongModelProvider>();
    return Scaffold(
      body: Stack(
        children: [
          body[provider.currentIndex],
          Visibility(
            visible: provider.isPlayingSong,
            child: Positioned(
              bottom: 0,
              right: 0,
              left: 0,
              child: Column(
                children: [
                  if (GetAllSongController.audioPlayer.currentIndex != null &&
                      provider.currentIndex != 4)
                    const Column(
                      children: [MiniPlayer()],
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
        backgroundColor: AppColors.kWhite.withOpacity(0.8),
        destinations: const [
          NavigationDestination(
            icon: Icon(
              Icons.home_outlined,
            ),
            selectedIcon: Icon(
              Icons.home,
            ),
            label: 'Home',
          ),
          NavigationDestination(
            icon: Icon(
              Icons.favorite_outline,
            ),
            label: 'Favorite',
            selectedIcon: Icon(
              Icons.favorite,
              color: AppColors.spRed,
            ),
          ),
          NavigationDestination(
            icon: Icon(Icons.history),
            label: 'Recent',
          ),
          NavigationDestination(
            icon: Icon(
              Icons.playlist_play_outlined,
            ),
            label: 'Playlist',
          ),
          NavigationDestination(
              icon: Icon(
                Icons.settings_outlined,
              ),
              selectedIcon: Icon(
                Icons.settings,
              ),
              label: 'Settings'),
        ],
        selectedIndex: provider.currentIndex,
        onDestinationSelected: (int newIndex) {
          provider.pageIndex(newIndex);
        },
      ),
    );
  }
}
