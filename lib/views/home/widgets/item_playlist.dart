import '/data/local/hive_services.dart';
import '/models/audio.dart';
import '/models/author.dart';
import '/models/favorite_audio.dart';
import '/utils/bottomsheet_custom.dart';

import '/views/playlistaudio/playlist_audio.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../utils/textStyle.dart';

class ItemPlaylist extends StatelessWidget {
  const ItemPlaylist({super.key, required this.audio, required this.isHideImg});
  final Audio audio;
  final bool isHideImg;
  void showBottomSheet() {
    bool isDuplicateAudio = HiveServices.isDuplicateAudio(id: audio.id);
    bool isDuplicateAuthor =
        HiveServices.isDuplicateAuthor(author: audio.author);
    Get.bottomSheet(
      bottomSheetCustom(
          saveFavorite: () {
            if (isDuplicateAudio) {
              HiveServices.addFavoriteAudio(
                  audio: FavoriteAudio(id: audio.id, tile: audio.title));
            } else {
              HiveServices.removeAudio(id: audio.id);
            }
            Get.back();
          },
          follow: () {
            if (isDuplicateAuthor) {
              HiveServices.addFavoriteAuthor(
                  author: FavoriteAuthor(author: audio.author));
            } else {
              HiveServices.removeAuthor(author: audio.author);
            }

            Get.back();
          },
          error: () {},
          download: () {},
          isAddAudio: isDuplicateAudio,
          isAddAuthor: isDuplicateAuthor),
    );
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Get.to(() => PlayListPage(audio: audio));
      },
      onLongPress: () {
        showBottomSheet();
      },
      child: Column(
        children: [
          Visibility(
            visible: !isHideImg,
            child: Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: SizedBox(
                  height: MediaQuery.sizeOf(context).height / 4,
                  width: MediaQuery.sizeOf(context).width,
                  child: Image.network(
                    audio.imageUrl,
                    fit: BoxFit.fill,
                  )),
            ),
          ),
          ListTile(
            title: Row(
              children: [
                Expanded(
                  child: Text(
                    audio.title,
                    style: TextStyle(
                      fontSize: 20,
                      color: Colors.white,
                      overflow: TextOverflow.ellipsis,
                    ),
                    maxLines: 2,
                  ),
                ),
                InkWell(
                  onTap: () {
                    showBottomSheet();
                  },
                  child: Icon(
                    Icons.more_vert,
                    color: Colors.white,
                  ),
                )
              ],
            ),
            subtitle: Text(
              audio.author +
                  "  *  " +
                  audio.views.toString() +
                  "  *  " +
                  audio.date,
              style: textStyleViewsPlayList,
              maxLines: 2,
            ),
          ),
        ],
      ),
    );
  }
}
