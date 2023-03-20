import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:music_app/screens/home_screen/listview_screen.dart';
import 'package:on_audio_query/on_audio_query.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

List<SongModel> allsongs = [];
List<SongModel> foundSongs = [];
final _audioQuery = OnAudioQuery();

@override
class _SearchScreenState extends State<SearchScreen> {
  @override
  void initState() {
    songsLoading();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.black),
        backgroundColor: Colors.white,
        title: TextField(
          textAlign: TextAlign.start,
          onChanged: (value) => updateList(value),
          style: const TextStyle(
              color: Colors.black, fontSize: 18, fontWeight: FontWeight.w500),
          decoration: InputDecoration(
              counterStyle: const TextStyle(),
              fillColor: Colors.transparent,
              filled: true,
              hintText: 'Search Song',
              hintStyle: const TextStyle(color: Colors.grey),
              border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(25),
                  borderSide: BorderSide.none)),
        ),
      ),
      body: foundSongs.isEmpty
          ? Center(child: Lottie.asset('assets/lottie/noResult.json'))
          : ListViewScreen(songModel: foundSongs),
    );
  }

  void songsLoading() async {
    allsongs = await _audioQuery.querySongs(
      sortType: null,
      orderType: OrderType.ASC_OR_SMALLER,
      uriType: UriType.EXTERNAL,
      ignoreCase: true,
    );
    foundSongs = allsongs;
  }

  void updateList(String enteredText) {
    List<SongModel> results = [];
    if (enteredText.isEmpty) {
      results = allsongs;
    } else {
      results = allsongs
          .where((element) => element.displayNameWOExt
              .toLowerCase()
              .contains(enteredText.toLowerCase()))
          .toList();
    }
    setState(() {
      foundSongs = results;
    });
  }
}
