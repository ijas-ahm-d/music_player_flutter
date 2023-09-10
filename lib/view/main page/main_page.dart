import 'dart:developer';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/material.dart';
import 'package:music_app/controllers/get_all_song_controller.dart';
import 'package:music_app/view/artist/artist_page.dart';
import 'package:music_app/view/main%20page/components/mini_player.dart';
import 'package:music_app/view/recent_screen/recent.dart';
import 'package:music_app/view/favorite_screen/favorite.dart';
import 'package:music_app/view/home_screen/home.dart';
import 'package:music_app/view/playlist_screen/playlist.dart';
import 'package:music_app/utils/const/colors.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import '../../../controllers/song_model_provider.dart';

List<Widget> body = [
  const HomePage(),
  const FavoritePage(),
  RecentPage(),
  ArtistPage(),
  const PlaylistPage(),
];

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  @override
  void initState() {
    super.initState();
  }

  Future userPermission() async {
    log("1111111111");
    bool permission = await requestPermission();
    log("222222222222$permission");
    if (!permission) {
      log("3333333333");
      await openAppSettings();
    }
  }

  Future<bool> requestPermission() async {
    log("44444444");
    const storagePermission = Permission.storage;
    log("5555");
    const mediaAccess = Permission.accessMediaLocation;
    log("666666");
    final deviceInfo = await DeviceInfoPlugin().androidInfo;

    try {
      log("!!!!!!!!!!");
      if (await storagePermission.isGranted) {
        log("7777777");
        await mediaAccess.isGranted && await storagePermission.isGranted;
        return true;
      } else {
        log("88888888888");
        if (deviceInfo.version.sdkInt > 32) {
          log("999999");
          bool permissionStatus = await Permission.audio.request().isGranted;
          return permissionStatus;
        } else {
          log("1010101010");
          var result = await storagePermission.request();
          var mediaresult = await mediaAccess.request();
          if (result == PermissionStatus.granted &&
              mediaresult == PermissionStatus.granted) {
            log("131313131");
            return true;
          } else {
            log("141414141");
            return false;
          }
        }
      }
    } catch (e) {
      log("1511551515151");
      log("Error: $e");
      return false;
    }
  }

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
                Icons.art_track_outlined,
              ),
              label: 'Artist'),
          NavigationDestination(
            icon: Icon(
              Icons.playlist_play_outlined,
            ),
            label: 'Playlist',
          ),
        ],
        selectedIndex: provider.currentIndex,
        onDestinationSelected: (int newIndex) {
          provider.pageIndex(newIndex);
        },
      ),
    );
  }
}
