import '/data/network/base_response.dart';
import 'package:get/get.dart';
import 'home_controller.dart';

class Homebinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut<HomeController>(
      () => HomeController(response: Get.find<BaseResponse>()),
    );
  }
}
