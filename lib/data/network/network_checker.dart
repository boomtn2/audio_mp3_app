import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:get/get.dart';

class NetWorkChecker {
  static Rx<ConnectivityResult> connectivityResult =
      ConnectivityResult.none.obs;

  static Future<void> init() async {
    connectivityResult.value = await (Connectivity().checkConnectivity());
    Connectivity().onConnectivityChanged.listen((event) {
      connectivityResult.value = event;
    });
  }

  static Future<bool> get isConnected async {
    connectivityResult.value = await Connectivity().checkConnectivity();
    return (connectivityResult.value == ConnectivityResult.mobile ||
        connectivityResult.value == ConnectivityResult.wifi);
  }
}
