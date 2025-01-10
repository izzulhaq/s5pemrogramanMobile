import 'package:get/get.dart';

import '../modules/home/bindings/home_binding.dart';
import '../modules/home/views/home_view.dart';
import '../modules/spp/views/inputspp_view.dart';
import '../modules/autentifikasi/views/login_view.dart';
import '../modules/spp/views/spp_menu_view.dart';
import 'app_routes.dart';

class AppPages {


  static final routes = [
    GetPage(
      name: AppRoutes.HOME,
      page: () => HomeView(),
      binding: HomeBinding(),
    ),
    GetPage(
      name: AppRoutes.HOMESPP,
      page: () => SppMenuView(),
    ),
    GetPage(
      name: AppRoutes.LOGIN,
      page: () => LoginView(),
    ),
  ];
}
