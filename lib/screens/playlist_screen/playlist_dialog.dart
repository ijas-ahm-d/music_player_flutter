import 'package:flutter/material.dart';
import 'package:music_app/controllers/playlist/playlist_db.dart';
import 'package:provider/provider.dart';
import '../../model/musica_db.dart';

Future moredialogplaylist(
    context, index, musicList, formkey, playlistnamectrl) {
  return showDialog(
    context: context,
    builder: (ctx) => SimpleDialog(
      contentPadding: const EdgeInsets.only(top: 10, bottom: 8),
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(15))),
      backgroundColor: Colors.white,
      children: [
        SimpleDialogOption(
          onPressed: () {
            Navigator.of(context).pop();
            playlistnamectrl.clear();
            editplaylist(index, context, formkey, playlistnamectrl);
          },
          child: Row(
            children: const [
              Icon(
                Icons.edit,
                color: Colors.grey,
              ),
              SizedBox(width: 4),
              Text(
                'Edit playlist Name',
                style: TextStyle(
                    color: Colors.black,
                    fontSize: 16,
                    fontWeight: FontWeight.w600),
              ),
            ],
          ),
        ),
        const SizedBox(
          height: 8,
        ),
        SimpleDialogOption(
          onPressed: () {
            Navigator.of(context).pop();
            showdialog(context, musicList, index);
          },
          child: Row(
            children: const [
              Icon(
                Icons.delete,
                color: Colors.grey,
              ),
              SizedBox(width: 4),
              Text(
                'Delete',
                style: TextStyle(
                    color: Colors.black,
                    fontSize: 16,
                    fontWeight: FontWeight.w600),
              ),
            ],
          ),
        ),
      ],
    ),
  );
}

Future<dynamic> showdialog(context, musicList, index) {
  return showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        backgroundColor: Colors.white,
        title: const Text(
          'Delete Playlist',
          style: TextStyle(
              color: Colors.black, fontSize: 17, fontWeight: FontWeight.w600),
        ),
        content: const Text(
          'Are you sure you want to delete this playlist?',
          style: TextStyle(
            color: Colors.black,
            fontSize: 15,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: const Text(
              'No',
              style: TextStyle(
                color: Colors.black,
                fontSize: 15,
              ),
            ),
          ),
          TextButton(
            onPressed: () {
              musicList.deleteAt(index);
              Navigator.pop(context);
              final snackBar = SnackBar(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(25),
                ),
                width: MediaQuery.of(context).size.width * 3.5 / 5,
                behavior: SnackBarBehavior.floating,
                backgroundColor: Colors.black,
                content: const Text(
                  'Playlist is deleted',
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.white),
                ),
                duration: const Duration(milliseconds: 450),
              );
              ScaffoldMessenger.of(context).showSnackBar(snackBar);
            },
            child: const Text(
              'Yes',
              style: TextStyle(
                color: Colors.black,
                fontSize: 15,
              ),
            ),
          ),
        ],
      );
    },
  );
}

Future editplaylist(index, context, formkey, playlistnamectrl) {
  return showDialog(
    context: context,
    builder: (ctx) => SimpleDialog(
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(
          Radius.circular(15),
        ),
      ),
      backgroundColor: Colors.white,
      children: [
        const SimpleDialogOption(
          child: Text(
            'Edit Playlist Name',
            textAlign: TextAlign.center,
            style: TextStyle(
                color: Colors.black, fontSize: 18, fontWeight: FontWeight.w600),
          ),
        ),
        const SizedBox(
          height: 8,
        ),
        SimpleDialogOption(
          child: Form(
            key: formkey,
            child: TextFormField(
              maxLength: 10,
              controller: playlistnamectrl,
              decoration: InputDecoration(
                  fillColor: const Color.fromARGB(90, 158, 158, 158),
                  filled: true,
                  border: OutlineInputBorder(
                    borderSide: BorderSide.none,
                    borderRadius: BorderRadius.circular(25),
                  ),
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
                updateplaylistname(index, formkey, playlistnamectrl, context);

                Navigator.of(context).pop();
              },
              child: const Text(
                'Update',
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

void updateplaylistname(index, formkey, playlistnamectrl, context) {
  if (formkey.currentState!.validate()) {
    final names = playlistnamectrl.text.trim();
    if (names.isEmpty) {
      return;
    } else {
      final playlistname = MusicaModel(name: names, songId: []);
      // final datas =
      //     PlaylistDb.playlistDb.values.map((e) => e.name.trim()).toList();

      // if (datas.contains(playlistname.name)) {
      //   snackBarShow(context, "playlist already exist");
      //   Navigator.pop(context);

      // }
//       Consumer<PlaylistDb>(
//         builder: (context, value, child) {
//  final playlistname = MusicaModel(name: names, songId: []);
//           return value.editPlaylist(index, playlistname);
//         },
      // );

      Provider.of<PlaylistDb>(context, listen: false)
          .editPlaylist(index, playlistname);

      // PlaylistDb.editPlaylist(index, playlistname);
    }
  }
}
