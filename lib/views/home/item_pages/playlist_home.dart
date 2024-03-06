import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../res/routes/app_routes_name.dart';
import '../home_controller.dart';
import '../widgets/item_playlist.dart';

class PlayListAudioHome extends StatefulWidget {
  const PlayListAudioHome({super.key});

  @override
  State<PlayListAudioHome> createState() => _PlayListAudioHomeState();
}

class _PlayListAudioHomeState extends State<PlayListAudioHome> {
  @override
  Widget build(BuildContext context) {
    return Obx(
      () => CustomScrollView(
        slivers: [
          SliverAppBar(
            floating: true,
            snap: true,
            backgroundColor: Colors.black,
            actions: [
              InkWell(
                onTap: () {
                  Get.toNamed(AppRoutesName.search);
                },
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      "Tìm Kiếm",
                      style: TextStyle(color: Colors.yellow),
                    ),
                    Icon(
                      Icons.search,
                      color: Colors.white,
                      size: 30,
                    ),
                  ],
                ),
              ),
            ],
            title: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                CircleAvatar(
                  backgroundImage: AssetImage("assets/images/avt.jpg"),
                  radius: 20,
                ),
                Text(
                  "AUDIO",
                  style: TextStyle(fontFamily: "Roboto", color: Colors.white),
                ),
              ],
            ),
          ),

          SliverList(
            delegate: SliverChildBuilderDelegate(
              (context, index) {
                final lazyLoadController = Get.find<HomeController>();
                if (index == lazyLoadController.audios.length - 1 &&
                    lazyLoadController.audios.length !=
                        lazyLoadController.dataAudios.length) {
                  lazyLoadController.loadMoreItems();
                  return lazyLoadController.isLoading.value
                      ? Center(child: CircularProgressIndicator())
                      : Container();
                }

                return ItemPlaylist(
                  audio: lazyLoadController.audios[index],
                  isHideImg: false,
                );
              },
              childCount: Get.find<HomeController>().audios.length,
            ),
          ),

          // Loading indicator widget
        ],
      ),
    );
  }
}
