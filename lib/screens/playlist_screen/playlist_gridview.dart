import 'dart:math';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
// import 'package:music_app/database/musica_db.dart';
import 'package:music_app/screens/playlist_screen/playlist_dialog.dart';
import 'package:music_app/screens/playlist_screen/playlist_list.dart';
import 'package:music_app/theme/button.dart';

import '../../model/musica_db.dart';

class PlaylistGridView extends StatefulWidget {
  const PlaylistGridView({
    Key? key,
    required this.musicList,
  }) : super(key: key);
  final Box<MusicaModel> musicList;
  @override
  State<PlaylistGridView> createState() => _PlaylistGridViewState();
}

class _PlaylistGridViewState extends State<PlaylistGridView> {
  final TextEditingController playlistnamectrl = TextEditingController();
  GlobalKey<FormState> formkey = GlobalKey<FormState>();

  @override
  void initState() {
    playlistnamectrl.text = widget.musicList.name;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    int imageChanger = 1;
    return GridView.builder(
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 0.75,
        crossAxisSpacing: 2,
        mainAxisSpacing: 2,
      ),
      shrinkWrap: true,
      itemCount: widget.musicList.length,
      itemBuilder: (context, index) {
        final data = widget.musicList.values.toList()[index];
        imageChanger = Random().nextInt(6) + 1;
        return ValueListenableBuilder(
          valueListenable: Hive.box<MusicaModel>('playlistDb').listenable(),
          builder: (BuildContext context, Box<MusicaModel> musicList,
              Widget? child) {
            return Padding(
              padding: const EdgeInsets.all(4),
              child: InkWell(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) {
                        return SinglePlaylist(
                          playlist: data,
                          findex: index,
                        );
                      },
                    ),
                  );
                },
                child: SpecialButton(
                  childIcon: Padding(
                    padding: const EdgeInsets.all(2.0),
                    child: Column(
                      children: [
                        Container(
                          margin: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                              image: DecorationImage(
                                  image: AssetImage(
                                    'assets/images/playlist/playlistCover$imageChanger.jpg',
                                  ),
                                  fit: BoxFit.cover)),
                          height: MediaQuery.of(context).size.height * 2 / 12,
                          width: MediaQuery.of(context).size.height * 2 / 12,
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 10.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              SizedBox(
                                width: MediaQuery.of(context).size.width *
                                    0.90 /
                                    4,
                                child: Text(
                                  data.name,
                                  maxLines: 1,
                                  style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16,
                                      color: Colors.black),
                                ),
                              ),
                              SizedBox(
                                height: 60,
                                width: 60,
                                child: SpecialButton(
                                  childIcon: IconButton(
                                    onPressed: () {
                                      moredialogplaylist(context, index,
                                          musicList, formkey, playlistnamectrl);
                                    },
                                    icon: const Icon(
                                      Icons.more_vert,
                                      color: Colors.black,
                                    ),
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
              ),
            );
          },
        );
      },
    );
  }
}
