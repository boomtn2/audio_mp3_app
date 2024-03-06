import '/data/local/hive_services.dart';
import '/data/network/base_response.dart';
import '/models/audio.dart';
import 'package:get/get.dart';

import '../../models/time_line.dart';

class HomeController extends GetxController {
  HomeController({required this.response});
  RxList<Audio> audios = <Audio>[].obs;
  List<Audio> dataAudios = [];
  BaseResponse response;
  RxBool isLoading = false.obs;
  RxInt currenPage = 0.obs;

  RxList<TimeLine> timeLines = <TimeLine>[].obs;

  void getDataTimeLine() {
    timeLines.clear();
    List<TimeLine> listTimeLine = [];

    HiveServices.getDataTimeLine().forEach((key, value) {
      listTimeLine.add(TimeLine.json(value));
    });

    timeLines.addAll(sapXepTimeLine(listTimeLine));

    if (timeLines.length > 10) {
      for (int i = timeLines.length - 1; i >= 10; --i) {
        HiveServices.removeTimeLine(key: timeLines[i].id);
      }
    }
  }

  List<TimeLine> sapXepTimeLine(List<TimeLine> listTimeLine) {
    for (int i = 0; i < listTimeLine.length - 1; ++i) {
      for (int j = i; j < listTimeLine.length; ++j) {
        if (listTimeLine[i]
            .getDateTime()
            .isBefore(listTimeLine[j].getDateTime())) {
          var temp = listTimeLine[i];
          listTimeLine[i] = listTimeLine[j];
          listTimeLine[j] = temp;
        }
      }
    }

    return listTimeLine;
  }

  Audio getAudioToID({required String id}) {
    for (int i = 0; i < dataAudios.length; ++i) {
      if (dataAudios[i].id.contains(id)) {
        return dataAudios[i];
      }
    }
    return Audio.none();
  }

  init() async {
    if (response.success == true && response.data != null) {
      response.data.forEach((element) {
        Audio audio = Audio.toJson(element);
        print(audio.theLoai);
        dataAudios.add(audio);
      });
      if (audios.isEmpty) {
        for (int i = 0;
            i < (dataAudios.length > 5 ? 5 : dataAudios.length);
            i++) {
          audios.add(dataAudios[i]);
        }
      }
    }
  }

  loadMoreItems() {
    if (audios.length < dataAudios.length) {
      isLoading.value = true;
      int max = dataAudios.length - 10 >= audios.length
          ? audios.length + 10
          : dataAudios.length;

      Future.delayed(Duration(seconds: 1), () {
        for (int i = audios.length; i < max; i++) {
          audios.add(dataAudios[i]);
        }
        isLoading.value = false;
      });
    }
  }
}
