import '/views/home/home.dart';
import '/views/home/home_binding.dart';
import '/views/search/search_binding.dart';
import '/views/search/search_page.dart';

import 'package:get/get.dart';

import '../../views/error_network/error_network.dart';
import '../../views/splash_page/splash_page.dart';
import 'app_routes_name.dart';

class AppRoutes {
  static final page = [
    GetPage(
      name: AppRoutesName.splash,
      page: () => SplashPage(),
    ),
    GetPage(
      name: AppRoutesName.home,
      page: () => Home(),
      binding: Homebinding(),
    ),
    GetPage(
      name: AppRoutesName.errornetwork,
      page: () => ErrorNetWork(),
      // binding: Homebinding(),
    ),
    GetPage(
      name: AppRoutesName.search,
      page: () => SearchPage(),
      binding: SearchBinding(),
    ),
  ];
}
