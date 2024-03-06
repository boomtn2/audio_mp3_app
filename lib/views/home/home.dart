import '/res/routes/app_routes_name.dart';
import '/views/home/item_pages/favorite_audio.dart';
import '/views/home/item_pages/history.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'home_controller.dart';
import 'item_pages/playlist_home.dart';
import 'widgets/item_playlist.dart';

List<Widget> pages = [
  PlayListAudioHome(), //0
  FavoriteAudio(), //1
  HistoryAudio(), //2
];

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Get.find<HomeController>().init();
  }

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => SafeArea(
        child: Scaffold(
          backgroundColor: Colors.black,
          body: pages[Get.find<HomeController>().currenPage.value],
          bottomNavigationBar: BottomNavigationBar(
              backgroundColor: Colors.black,
              onTap: (value) {
                Get.find<HomeController>().currenPage.value = value;
              },
              currentIndex: Get.find<HomeController>().currenPage.value,
              unselectedItemColor: Colors.white,
              selectedItemColor: Colors.red,
              items: [
                BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home"),
                BottomNavigationBarItem(
                    icon: Icon(Icons.favorite), label: "Theo Dõi"),
                BottomNavigationBarItem(
                    icon: Icon(Icons.audio_file), label: "Lịch Sử")
              ]),
        ),
      ),
    );
  }
}
