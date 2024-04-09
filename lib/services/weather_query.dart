import 'dart:convert';
import 'package:sunchaser2/models/weather_models.dart';
import 'package:http/http.dart' as http;
import 'package:sunchaser2/keys.dart';

Future<WeatherResponse> getWeather(dynamic position) async {
  final response = await http.get(Uri.parse('https://api.openweathermap.org/data/2.5/weather?lat=${position.latitude}&lon=${position.longitude}&appid=$apiKey'));
  
  if (response.statusCode == 200) {
    return WeatherResponse.fromJson(jsonDecode(response.body) as Map<String, dynamic>);
  } else {
    throw Exception('Failed to load weather data');
  }
}

