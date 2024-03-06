import '/data/local/hive_services.dart';
import '/views/home/home_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';

import '../widgets/item_playlist.dart';

class FavoriteAudio extends StatefulWidget {
  FavoriteAudio({super.key});

  @override
  State<FavoriteAudio> createState() => _FavoriteAudioState();
}

class _FavoriteAudioState extends State<FavoriteAudio> {
  RxBool isHideListAuthor = false.obs;
  RxBool isHideListAudio = true.obs;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    HiveServices.getData();
  }

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => ListView(
        children: [
          InkWell(
            onTap: () {
              isHideListAuthor.value = !isHideListAuthor.value;
            },
            child: Card(
              color: Colors.yellow,
              child: ListTile(
                leading: isHideListAuthor.value
                    ? Icon(Icons.arrow_downward)
                    : Icon(Icons.ads_click),
                title: Center(child: Text("Tác Giả Theo Dõi")),
                subtitle: Center(child: Text("Bấm vào để xem thêm")),
                trailing: isHideListAuthor.value
                    ? Icon(Icons.arrow_downward)
                    : Icon(Icons.ads_click),
              ),
            ),
          ),
          Visibility(
            visible: isHideListAuthor.value,
            child: Column(
                mainAxisSize: MainAxisSize.min,
                children: HiveServices.favoriteAuthor
                    .map((element) => Card(
                          child: ListTile(
                            leading: Text("Tác Giả:"),
                            title: Text(element.author),
                            trailing: Icon(Icons.arrow_forward),
                          ),
                        ))
                    .toList()),
          ),
          Card(
            color: Colors.blue,
            child: ListTile(
              leading: Icon(Icons.arrow_downward),
              title: Center(child: Text("Danh Sách Truyện Theo Dõi")),
              trailing: Icon(Icons.arrow_downward),
            ),
          ),
          Visibility(
            visible: isHideListAudio.value,
            child: Column(
                mainAxisSize: MainAxisSize.min,
                children: HiveServices.favoriteAudio
                    .map((element) => ItemPlaylist(
                          audio: Get.find<HomeController>()
                              .getAudioToID(id: element.id),
                          isHideImg: false,
                        ))
                    .toList()),
          ),
        ],
      ),
    );
  }
}
