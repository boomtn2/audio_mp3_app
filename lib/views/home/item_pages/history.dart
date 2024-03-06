import 'package:final_nghe_audio/views/playlistaudio/playlist_audio.dart';

import '/data/local/hive_services.dart';
import '/views/home/home_controller.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';

class HistoryAudio extends StatelessWidget {
  const HistoryAudio({super.key});

  @override
  Widget build(BuildContext context) {
    final _controller = Get.find<HomeController>();
    _controller.getDataTimeLine();
    return Obx(
      () => ListView.builder(
        itemCount: _controller.timeLines.length,
        itemBuilder: (context, index) => InkWell(
          onTap: () {
            final audio =
                _controller.getAudioToID(id: _controller.timeLines[index].id);
            Get.to(() => PlayListPage(audio: audio));
          },
          child: Card(
            color: const Color.fromARGB(255, 185, 156, 145),
            child: ListTile(
              trailing: Icon(
                Icons.skip_next,
                color: Colors.white,
              ),
              title: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    _controller.timeLines[index].ngayThangNam,
                    style: TextStyle(
                        color: Colors.black, fontWeight: FontWeight.bold),
                  ),
                  Text(
                    "[ Tập ${_controller.timeLines[index].index + 1} ] [${_controller.timeLines[index].parseTimeString()}]",
                    style: TextStyle(
                        color: Colors.black, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
              subtitle: Text(
                _controller.timeLines[index].tile,
                style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                    fontSize: 15),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
