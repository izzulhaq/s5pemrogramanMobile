import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../../../data/weather.dart';

class WeatherController extends GetxController {
  var weather = Weather(cityName: '', temperature: 0, description: '', humidity: 0, windSpeed: 0).obs;
  var isLoading = false.obs;
  final apiKey = 'fec4b031c1b28f9e74e1c8d081a120a5'; 

  Future<void> fetchWeather(String cityName) async {
    try {
      isLoading(true);
      final response = await http.get(Uri.parse(
        'https://api.openweathermap.org/data/2.5/weather?q=$cityName&appid=$apiKey',
      ));

      if (response.statusCode == 200) {
        var jsonData = json.decode(response.body);
        weather.value = Weather.fromJson(jsonData);
      } else {
        Get.snackbar('Error', 'Failed to load weather data');
      }
    } catch (e) {
      Get.snackbar('Error', 'An error occurred');
    } finally {
      isLoading(false);
    }
  }
}
