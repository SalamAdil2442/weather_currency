import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:weather_app_test/model/data_models.dart';

class WeatherApi {
  final String apiKey;
  final String baseUrl = 'https://api.openweathermap.org/data/2.5/weather';

  WeatherApi(this.apiKey);

  Future<Weather> getWeather(String cityName) async {
    final url =
        '$baseUrl?q=$cityName&appid=$apiKey&units=metric';

    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = json.decode(response.body);
      return Weather(
        cityName: data['name'],
        temperature: data['main']['temp'].toDouble(),
        condition: _mapCondition(data['weather'][0]['main']),
      );
    } else {
      throw Exception('Failed to load weather data');
    }
  }

  WeatherCondition _mapCondition(String condition) {
   
    switch (condition) {
      case 'Clear':
        return WeatherCondition.sunny;
      case 'Rain':
        return WeatherCondition.rainy;
      case 'Clouds':
        return WeatherCondition.cloudy;
      case 'Snow':
        return WeatherCondition.snowy;
      case 'Thunderstorm':
        return WeatherCondition.thunderstorm;
      default:
        return WeatherCondition.sunny;
    }
  }
}
