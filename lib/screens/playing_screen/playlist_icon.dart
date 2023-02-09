import 'package:flutter/material.dart';
import 'package:hive_flutter/adapters.dart%20';
import 'package:music_app/database/musica_db.dart';
import 'package:music_app/screens/home_screen/home.dart';

import 'package:music_app/screens/playlist_screen/playlist_db.dart';
import 'package:music_app/theme/button.dart';
import 'package:on_audio_query/on_audio_query.dart';

class PlaylistIcon extends StatefulWidget {
  const PlaylistIcon({super.key, required this.favsongModels});
  final SongModel favsongModels;
  // final findex;
  @override
  State<PlaylistIcon> createState() => _PlaylistIconState();
}

final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
TextEditingController nameController = TextEditingController();

class _PlaylistIconState extends State<PlaylistIcon> {
  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: () {
        showPlaylistBottomSheet(context);

        // showPlaylistdialog(context);
      },
      icon: const Icon(
        Icons.playlist_add,
        color: Colors.black,
      ),
    );
  }

// plalist bottom sheet
  showPlaylistBottomSheet(context) {
    showModalBottomSheet(
      context: context,
      builder: (_) {
        return Column(
          children: [
            const Padding(
              padding: EdgeInsets.all(12.0),
              child: Text(
                'Choose Your Playlist',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
              ),
            ),
            Expanded(
              child: ValueListenableBuilder(
                  valueListenable:
                      Hive.box<MusicaModel>('playlistDb').listenable(),
                  builder: (BuildContext context, Box<MusicaModel> musicList,
                      child) {
                    return Hive.box<MusicaModel>('playlistDb').isEmpty
                        ? const Center(
                            child: SizedBox(
                              height: 150,
                              child: Center(
                                child: Text(
                                  'No Playlist found',
                                  style: TextStyle(color: Colors.black),
                                ),
                              ),
                            ),
                          )
                        : ListView.builder(
                            shrinkWrap: true,
                            physics: const ScrollPhysics(),
                            itemCount: musicList.length,
                            itemBuilder: (context, index) {
                              final data = musicList.values.toList()[index];
                              return Padding(
                                padding: const EdgeInsets.symmetric(
                                    vertical: 2, horizontal: 10),
                                child: SpecialButton(
                                  //  colour: Colors.grey[300],
                                  childIcon: ListTile(
                                    leading: Icon(
                                      Icons.queue_music,
                                      color: Colors.purple.withOpacity(0.3),
                                    ),
                                    title: Text(
                                      data.name,
                                      style: title,
                                    ),
                                    trailing: Icon(
                                      Icons.add,
                                      color: Colors.purple.withOpacity(0.3),
                                    ),
                                    onTap: () {
                                      songAddToPlaylist(widget.favsongModels,
                                          data, data.name);
                                      Navigator.pop(context);
                                    },
                                  ),
                                ),
                              );
                            },
                          );
                  }),
            )
          ],
        );
      },
    );
  }

// Add to Playlist
  void songAddToPlaylist(SongModel data, datas, String name) {
    if (!datas.isValueIn(data.id)) {
      datas.add(data.id);
      final addedToPlaylist = SnackBar(
          duration: const Duration(milliseconds: 850),
          backgroundColor: Colors.black,
          content: Text(
            'Song added to $name',
            style: const TextStyle(color: Colors.greenAccent),
          ));
      ScaffoldMessenger.of(context).showSnackBar(addedToPlaylist);
    } else {
      final alreadyInPlaylist = SnackBar(
          duration: const Duration(milliseconds: 850),
          backgroundColor: Colors.black,
          content: Text(
            'Song already added in $name',
            style: const TextStyle(color: Colors.redAccent),
          ));
      ScaffoldMessenger.of(context).showSnackBar(alreadyInPlaylist);
    }
  }

// new playlist
  Future newplaylist(BuildContext context, formKey) {
    return showDialog(
      context: context,
      builder: (ctx) => SimpleDialog(
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(10))),
        backgroundColor: const Color.fromARGB(255, 52, 6, 105),
        children: [
          const SimpleDialogOption(
            child: Text(
              'New to Playlist',
              style: TextStyle(
                  color: Color.fromARGB(255, 255, 255, 255),
                  fontSize: 18,
                  fontWeight: FontWeight.w600),
            ),
          ),
          const SizedBox(
            height: 8,
          ),
          SimpleDialogOption(
            child: Form(
              key: formKey,
              child: TextFormField(
                textAlign: TextAlign.center,
                controller: nameController,
                maxLength: 15,
                decoration: InputDecoration(
                    counterStyle: const TextStyle(
                      color: Colors.white,
                    ),
                    fillColor: Colors.white.withOpacity(0.7),
                    filled: true,
                    border: OutlineInputBorder(
                        borderSide: BorderSide.none,
                        borderRadius: BorderRadius.circular(10)),
                    contentPadding: const EdgeInsets.only(left: 15, top: 5)),
                style: const TextStyle(
                    color: Color.fromARGB(255, 0, 0, 0),
                    fontSize: 16,
                    fontWeight: FontWeight.w600),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Enter your playlist name";
                  } else {
                    return null;
                  }
                },
              ),
            ),
          ),
          const SizedBox(
            height: 8,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              SimpleDialogOption(
                onPressed: () {
                  Navigator.of(context).pop();
                  nameController.clear();
                },
                child: const Text(
                  'Cancel',
                  style: TextStyle(
                      color: Color.fromARGB(255, 255, 255, 255),
                      fontSize: 16,
                      fontWeight: FontWeight.w600),
                ),
              ),
              SimpleDialogOption(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    saveButtonPressed(context);
                  }
                },
                child: const Text(
                  'Create',
                  style: TextStyle(
                      color: Color.fromARGB(255, 255, 255, 255),
                      fontSize: 16,
                      fontWeight: FontWeight.w600),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

// Save button
  Future<void> saveButtonPressed(context) async {
    final name = nameController.text.trim();
    final music = MusicaModel(name: name, songId: []);
    final datas =
        PlaylistDb.playlistDb.values.map((e) => e.name.trim()).toList();
    if (name.isEmpty) {
      return;
    } else if (datas.contains(music.name)) {
      const snackbar3 = SnackBar(
          duration: Duration(milliseconds: 750),
          backgroundColor: Colors.black,
          content: Text(
            'playlist already exist',
            style: TextStyle(color: Colors.redAccent),
          ));
      ScaffoldMessenger.of(context).showSnackBar(snackbar3);
      Navigator.of(context).pop();
    } else {
      PlaylistDb.addPlaylist(music);
      const snackbar4 = SnackBar(
          duration: Duration(milliseconds: 750),
          backgroundColor: Colors.black,
          content: Text(
            'playlist created successfully',
            style: TextStyle(color: Colors.white),
          ));
      ScaffoldMessenger.of(context).showSnackBar(snackbar4);
      Navigator.pop(context);
      nameController.clear();
    }
  }
}
