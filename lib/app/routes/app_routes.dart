import 'package:get/get.dart';
import 'package:inpocuaca/app/modules/home/bindings/home_binding.dart';
import '../modules/home/views/weather_screen.dart';
import '../modules/home/views/webview_screen.dart'; // Tambahkan ini

class AppRoutes {
  static const initial = Routes.weatherScreen;

  static final routes = [
    GetPage(
      name: Routes.weatherScreen,
      page: () => WeatherScreen(),
      binding: HomeBinding(),
    ),
    GetPage(
      name: Routes.webviewScreen, // Definisikan rute untuk WebView
      page: () => WebViewScreen(), // Panggil halaman WebViewScreen
    ),
  ];
}

class Routes {
  static const weatherScreen = '/weather';
  static const webviewScreen = '/webview'; // Tambahkan rute untuk WebView
}
