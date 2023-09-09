class Weather {
  final String cityName;
  final double temperature;
  final WeatherCondition condition;

  Weather({
    required this.cityName,
    required this.temperature,
    required this.condition,
  });
  
}

enum WeatherCondition {
  sunny,
  rainy,
  cloudy,
  snowy,
  thunderstorm,
}
