import 'package:flutter/material.dart';
import 'package:music_app/components/special_button.dart';
import 'package:music_app/utils/const/colors.dart';
import 'package:music_app/utils/const/text_styles.dart';
import 'package:music_app/view/artist/components/inside_artist_page.dart';
import 'package:on_audio_query/on_audio_query.dart';

class ArtistGrid extends StatelessWidget {
  final AsyncSnapshot<List<ArtistModel>> item;
  const ArtistGrid({super.key, required this.item});

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      shrinkWrap: true,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          childAspectRatio: 1.05,
          crossAxisSpacing: 2,
          mainAxisSpacing: 2),
      itemBuilder: (context, index) {
        final artistName = item.data![index].artist;
        String artist =
            artistName == "<unknown>" ? "Unknown artist" : artistName;
        return Padding(
          padding: const EdgeInsets.all(4.0),
          child: InkWell(
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
            child: SpecialButton(
              childIcon: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(10),
                      child: QueryArtworkWidget(
                        id: item.data![index].id,
                        type: ArtworkType.ARTIST,
                        artworkBorder: BorderRadius.circular(6),
                        artworkWidth:
                            MediaQuery.of(context).size.height * 1 / 12,
                        artworkHeight:
                            MediaQuery.of(context).size.height * 1 / 12,
                        keepOldArtwork: true,
                        artworkFit: BoxFit.cover,
                        nullArtworkWidget: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(6),
                            color: Colors.purple.withOpacity(0.3),
                          ),
                          height: MediaQuery.of(context).size.height * 1 / 12,
                          width: MediaQuery.of(context).size.height * 1 / 12,
                          child: Icon(Icons.album_outlined,
                              color: Colors.purple.withOpacity(0.5), size: 50),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(8, 0, 8, 0),
                      child: Container(
                        alignment: Alignment.center,
                        child: Text(
                          artist,
                          maxLines: 1,
                          style: TextStyles.onText(
                            16,
                            FontWeight.bold,
                            AppColors.kblack,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
      itemCount: item.data!.length,
    );
  }
}
