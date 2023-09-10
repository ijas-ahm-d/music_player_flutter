import 'package:flutter/material.dart';
import 'package:music_app/components/special_button.dart';
import 'package:music_app/utils/const/colors.dart';
import 'package:music_app/utils/const/text_styles.dart';
import 'package:music_app/view/artist/components/inside_artist_page.dart';
import 'package:on_audio_query/on_audio_query.dart';

class ArtistList extends StatelessWidget {
  final AsyncSnapshot<List<ArtistModel>> item;

  const ArtistList({
    super.key,
    required this.item,
  });

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      shrinkWrap: true,
      itemBuilder: (context, index) {
        final artistName = item.data![index].artist;
        String artist =
            artistName == "<unknown>" ? "Unknown artist" : artistName;
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 2, horizontal: 10),
          child: SpecialButton(
            childIcon: ListTile(
              leading: QueryArtworkWidget(
                id: item.data![index].id,
                type: ArtworkType.ARTIST,
                artworkWidth: 50,
                artworkHeight: 50,
                artworkFit: BoxFit.cover,
                keepOldArtwork: true,
                artworkBorder: BorderRadius.circular(6),
                nullArtworkWidget: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(6),
                    color: Colors.purple.withOpacity(0.3),
                  ),
                  height: 50,
                  width: 50,
                  child: Icon(
                    Icons.album_outlined,
                    color: Colors.purple.withOpacity(0.5),
                  ),
                ),
              ),
             
              title: Text(
                artist,
                maxLines: 1,
                style: TextStyles.onText(
                  16,
                  FontWeight.bold,
                  AppColors.kblack,
                ),
              ),

              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ArtistInsideList(
                      artistName: artistName,
                    ),
                  ),
                );
              },
            ),
          ),
        );
      },
      itemExtent: 80,
      itemCount: item.data!.length,
    );
  }
}
