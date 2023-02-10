import 'dart:math';

import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:music_app/database/musica_db.dart';
import 'package:music_app/screens/playlist_screen/playlist_dialog.dart';
import 'package:music_app/screens/playlist_screen/playlist_list.dart';
import 'package:music_app/theme/button.dart';
// import 'package:music_app/screens/playlist_screen/playlist_dialog.dart';
// import 'package:music_app/screens/playlist_screen/playlist_list.dart';

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
          childAspectRatio: 1,
          crossAxisSpacing: 2,
          mainAxisSpacing: 2),
      // physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      itemCount: widget.musicList.length,
      itemBuilder: (context, index) {
        final data = widget.musicList.values.toList()[index];
        imageChanger = Random().nextInt(5) + 1;
        // List images = [
        
        //   'assets/images/playlist/playlist$imageChanger.jpg',
        //   // 'assets/images/playlist/playlist2.jpg',
        //   // 'assets/images/playlist/playlist3.jpg',
        //   // 'assets/images/playlist/playlist4.jpg',
        //   // 'assets/images/playlist/playlist5.jpg',
       
        // ];

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
                            backgroundImage:
                            'assets/images/playlist/playlist$imageChanger.jpg',
                            // images[index]
                            //  images[index > 4 ? images.length:index]
                            // index >= 3 ? images[images.length-index] : images[index],
                            );
                      },
                    ),
                  );
                },
                child: SpecialButton(
                  // colour: Colors.grey[300],
                  childIcon: Padding(
                    padding: const EdgeInsets.all(2.0),
                    child: Column(
                      children: [
                        Container(
                          margin: const EdgeInsets.all(10),
                          // padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                              image: DecorationImage(image: AssetImage(
                                  // index>= 3 ? images[images.length-index] : images[index],
                                  'assets/images/playlist/playlist$imageChanger.jpg'),
                                   fit: BoxFit.cover)
                              // borderRadius: BorderRadius.circular(6),
                              // color: Colors.purple.withOpacity(0.3),
                              ),
                          height: MediaQuery.of(context).size.height * 1 / 12,
                          width: MediaQuery.of(context).size.height * 1 / 12,
                          // child: Icon(
                          //   Icons.queue_music,
                          //   color: Colors.purple.withOpacity(0.5),
                          //   size: 40,
                          // ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 10.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              SizedBox(
                                width: MediaQuery.of(context).size.width *
                                    0.99 /
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
