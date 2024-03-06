import '/data/network/network_checker.dart';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../data/network/api_provider_gsheet.dart';
import '../../res/routes/app_routes_name.dart';
import '../../utils/textStyle.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    init();
  }

  void init() async {
    bool isCn = await NetWorkChecker.isConnected;

    if (isCn == true) {
      var data = await APIProviderGsheet.instance.fletchData();
      Get.lazyPut(
        () => data,
      );
      Get.offNamed(AppRoutesName.home);
    } else {
      Get.offNamed(AppRoutesName.errornetwork);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          // Background Image or Color
          Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/images/avt.jpg'),
                fit: BoxFit.cover,
              ),
            ),
          ),
          // Centered Image
          // Loading Indicator at the Bottom

          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "NGHE TRUYỆN AUDIO",
                style: textStyleViewsPlayList.copyWith(
                    color: Colors.black, fontSize: 25),
              ),
              SizedBox(
                height: 10,
              ),
              SizedBox(
                width: 150,
                child: LinearProgressIndicator(
                  backgroundColor: const Color.fromARGB(255, 17, 16, 16),
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.yellow),
                ),
              ),
              SizedBox(height: 16.0),
              Text('Đợi Mình Xíu Nha...'),
            ],
          ),
        ],
      ),
    );
  }
}
