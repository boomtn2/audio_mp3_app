import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../data/network/base_response.dart';
import '../../models/audio.dart';

class SearchPageController extends GetxController {
  RxList<Audio> data = <Audio>[].obs;

  Map<String, bool> selectedItems = <String, bool>{}.obs;
  TextEditingController textEditingController = TextEditingController();

  RxBool isLoading = false.obs;
  void search() {
    if (data.length > 0) {
      data.removeRange(0, data.length);
    }

    isLoading.value = true;

    var response = Get.find<BaseResponse>();
    if (response.success == true && response.data != null) {
      //so sanh txt tile truyen || tac gia
      if (textEditingController.value.text.isEmpty) {
        response.data.forEach((element) {
          Audio audio = Audio.toJson(element);
          data.add(audio);
        });
      } else {
        response.data.forEach((element) {
          Audio audio = Audio.toJson(element);
          if (areStringsSimilar(audio.title, textEditingController.text) ||
              areStringsSimilar(audio.author, textEditingController.text)) {
            data.add(audio);
          }
        });
      }

      //so sanh the loại

      selectedItems.forEach((key, value) {
        for (int i = 0; i < data.length; ++i) {
          if (value == true) {
            if (areStringsSimilar(key, data[i].theLoai) == false) {
              data.remove(data[i]);
              if (data.length > 0) {
                --i;
              }
            }
          }
        }
      });
    }
    isLoading.value = false;
  }

  bool areStringsSimilar(String str1, String str2) {
    // Chuyển đổi cả hai chuỗi về in thường
    String lowerStr1 = str1.toLowerCase();
    String lowerStr2 = str2.toLowerCase();

    // So sánh chuỗi đã chuyển đổi
    return lowerStr1.contains(lowerStr2) || lowerStr2.contains(lowerStr1);
  }
}
