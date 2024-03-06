import '/res/routes/app_routes_name.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';

import 'data/local/hive_services.dart';
import 'data/network/network_checker.dart';
import 'res/routes/app_routes.dart';
import 'views/playlistaudio/playlist_audio.dart';

Future initApp() async {
  WidgetsFlutterBinding.ensureInitialized();
  await NetWorkChecker.init();
  await HiveServices.init();
}

class AudioApp extends StatelessWidget {
  const AudioApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: AppRoutesName.initial,
      getPages: AppRoutes.page,
    );
  }
}
