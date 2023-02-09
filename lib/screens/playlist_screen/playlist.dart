import 'package:flutter/material.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:music_app/database/musica_db.dart';
import 'package:music_app/screens/home_screen/home.dart';
import 'package:music_app/screens/playlist_screen/playlist_db.dart';
import 'package:music_app/screens/playlist_screen/playlist_gridview.dart';

class PlaylistPage extends StatefulWidget {
  const PlaylistPage({super.key});

  @override
  State<PlaylistPage> createState() => _PlaylistPageState();
}

final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
TextEditingController nameController = TextEditingController();

class _PlaylistPageState extends State<PlaylistPage> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: Hive.box<MusicaModel>('playlistDb').listenable(),
      builder: (context, Box<MusicaModel> musicList, child) {
        return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,

          resizeToAvoidBottomInset: false,
          appBar: AppBar(
            title: const Text('Playlist'),
          ),
          floatingActionButton: FloatingActionButton(
            tooltip: "Add new playlist",
            onPressed: () {
              nameController.clear();
              newplaylist(context, _formKey);
            },
            backgroundColor: Colors.black54,
            child: const Icon(
              Icons.playlist_add,
              color: Colors.white,
            ),
          ),
          body: SizedBox(
            width: double.infinity,
            height: double.infinity,
            child: Hive.box<MusicaModel>('playlistDb').isEmpty
                ?  Center(
                    child: Text('No playlist',style: title,),
                  )
                : PlaylistGridView(
                    musicList: musicList,
                  ),
          ),
        );
      },
    );
  }

  // New Playlist
  Future newplaylist(BuildContext context, formKey) {
    return showDialog(
      context: context,
      builder: (ctx) => SimpleDialog(
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(15))),
        backgroundColor: Colors.white,
        children: [
          const SimpleDialogOption(
            child: Text(
              'New to Playlist',
              style: TextStyle(
                  color: Colors.black,
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
                controller: nameController,
                maxLength: 10,
                decoration: InputDecoration(
                    counterStyle: const TextStyle(
                      color: Colors.black,
                    ),
                    fillColor: const Color.fromARGB(90, 158, 158, 158),
                    filled: true,
                    border: OutlineInputBorder(
                        borderSide: BorderSide.none,
                        borderRadius: BorderRadius.circular(25)),
                    contentPadding: const EdgeInsets.only(left: 15, top: 5)),
                style: const TextStyle(
                    color: Colors.black,
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
                      color: Colors.black,
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
                      color: Colors.black,
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
}

// Save Button Pressed
Future<void> saveButtonPressed(context) async {
  final name = nameController.text.trim();
  final music = MusicaModel(name: name, songId: []);
  final datas = PlaylistDb.playlistDb.values.map((e) => e.name.trim()).toList();
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
          style: TextStyle(color: Colors.greenAccent),
        ));
    ScaffoldMessenger.of(context).showSnackBar(snackbar4);
    Navigator.pop(context);
    nameController.clear();
  }
}
