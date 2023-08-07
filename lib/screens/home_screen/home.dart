import 'dart:developer';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/material.dart';
import 'package:music_app/controllers/get_all_song_controller.dart';
import 'package:music_app/screens/home_screen/gridview_screen.dart';
import 'package:music_app/screens/home_screen/listview_screen.dart';
import 'package:music_app/screens/search_screen/search_page.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'package:music_app/controllers/favorite_db.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';

TextStyle title = const TextStyle(
    color: Colors.black, fontWeight: FontWeight.bold, fontSize: 16);
TextStyle artistStyle = const TextStyle(color: Colors.black38, fontSize: 14);

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

List<SongModel> startSong = [];

class _HomePageState extends State<HomePage> {
  final OnAudioQuery _audioQuery = OnAudioQuery();
  List<SongModel> allSongs = [];

  @override
  void initState() {
    // requestPermission();

    super.initState();
  }

// Future<bool> requestPermission(Permission permission) async {
//   const storage = Permission.storage;
//   const mediaAccess = Permission.accessMediaLocation;
//   final deviceInfo = await DeviceInfoPlugin().androidInfo;

//   try {
//     log("in permission");
//     if (await permission.isGranted) {
//       log("11111111111111");
//       await mediaAccess.isGranted && await storage.isGranted;
//       return true;
//     } else if (deviceInfo.version.sdkInt > 32) {
//       bool permissionStatus = await Permission.audio.request().isGranted;
//         setState(() {

//   });
//       return permissionStatus;
//     } else {
//       log("2222222222");
//       var result = await storage.request();
//       log("aaaaaaaaaaaaaaa");
//       var mediaresult = await mediaAccess.request();
//       log("0000000000000000000");
//       if (result == PermissionStatus.granted &&
//           mediaresult == PermissionStatus.granted) {
//         log("33333333333");
//          setState(() {

//   });
//         return true;
//       } else {
//         log("4444444444");
//         return false;
//       }

//     }
//   } catch (e) {
//     log("Error: $e");
//     return false;
//   }

// }

  void requestPermission() async {
    log("come to request permission");
    final deviceInfo = await DeviceInfoPlugin().androidInfo;
    try {
      log("11111111");
      bool permissionStatus = await _audioQuery.permissionsStatus();
      log("222222222");
      if (!permissionStatus) {
        log("waiting....");
        if (deviceInfo.version.sdkInt > 32) {
          await Permission.audio.request();
          log("111111111111111111");
        } else {
          log("000000000000000");
          await _audioQuery.permissionsRequest();
          log("222222222222222222");
          Permission.storage.request();
          log("3333333333333333333");
        }
      }
      log("555555");
      setState(() {});
      Permission.storage.request();
      log("66666");
    } catch (e) {
      log("666666");
      log("Error $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    final isGrid = Provider.of<FavoriteDb>(context).isGrid;
    return Scaffold(
      backgroundColor: Colors.grey[300],

//APPBAR
      appBar: AppBar(
        title: const Text('All songs'),
        actions: [
// Grid Button
          IconButton(
            onPressed: () {
              Provider.of<FavoriteDb>(context, listen: false).gridList();
            },
            icon: isGrid
                ? const Icon(Icons.format_list_bulleted)
                : const Icon(Icons.grid_view),
          ),

// search button
          Padding(
            padding: const EdgeInsets.only(left: 10, right: 10),
            child: IconButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const SearchScreen(),
                  ),
                );
              },
              icon: const Icon(Icons.search),
            ),
          )
        ],
      ),
//BODY
      body: FutureBuilder<List<SongModel>>(
        future: _audioQuery.querySongs(
          sortType: null,
          orderType: OrderType.ASC_OR_SMALLER,
          uriType: UriType.EXTERNAL,
          ignoreCase: true,
        ),
        builder: (context, item) {
         
          if (item.data == null) {
            return const Center(
              child: CircularProgressIndicator(
                strokeWidth: 2,
              ),
            );
          }

          if (item.data!.isEmpty) {
            return Center(
              child: Text(
                'No songs found',
                style: title,
              ),
            );
          }

          if (!Provider.of<FavoriteDb>(context, listen: false).isInitialized) {
            Provider.of<FavoriteDb>(context, listen: false)
                .initialize(item.data!);
          }
          GetAllSongController.songscopy = item.data!;
          startSong = item.data!;

          return !isGrid
              ? ListViewScreen(songModel: item.data!)
              : GridViewScreen(songModel: item.data!);
        },
      ),
    );
  }
}
