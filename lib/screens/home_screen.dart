import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:weather_app_test/controller/Weather%20API%20Service.dart';
import 'package:weather_app_test/model/data_models.dart';
import 'package:weather_app_test/widget/colors.dart';

class weather_screen extends StatefulWidget {
  @override
  State<weather_screen> createState() => _weather_screenState();
}

class _weather_screenState extends State<weather_screen> {
  final WeatherApi weatherApi = WeatherApi('6b7364ea3a34ffe4dc6cbed505163b2f');
  String search_country = "erbil";
  TextEditingController _search = TextEditingController();

  List<WeatherData> weatherDataList = [];

  Future<List<WeatherData>> fetchWeatherData(String search_country) async {
    final response = await http.get(Uri.parse(
        'https://api.openweathermap.org/data/2.5/forecast?q=${search_country}&appid=6b7364ea3a34ffe4dc6cbed505163b2f&units=metric&cnt=5'));
    if (response.statusCode == 200) {
      final Map<String, dynamic> data = json.decode(response.body);
      final List<dynamic> list = data['list'];
      setState(() {
        weatherDataList =
            list.map((json) => WeatherData.fromJson(json)).toList();
      });
      return weatherDataList;
    } else {
      throw Exception('Failed to load weather data');
    }
  }

  @override
  void initState() {
    super.initState();
    fetchWeatherData(search_country.toString());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: EdgeInsets.symmetric(vertical: 35, horizontal: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            FutureBuilder<Weather>(
              future: weatherApi.getWeather(search_country),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  final weather = snapshot.data!;
                  return Column(
                    children: <Widget>[
                      Text(
                        'City: ${weather.cityName}',
                        style: TextStyle(fontSize: 20),
                      ),
                      Text(
                        'Temperature: ${weather.temperature}°C',
                        style: TextStyle(fontSize: 20),
                      ),
               
                    ],
                  );
                } else if (snapshot.hasError) {
                  return Text('you have to select your city');
                }
                return CircularProgressIndicator();
              },
            ),
            Container(
              height: 50,
              width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(width: 2, color: appcolors.bluecolor)),
              child: TextFormField(
                controller: _search,
                keyboardType: TextInputType.name,
                decoration: InputDecoration(
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                      width: 2,
                      color: appcolors.bluecolor,
                    ),
                    borderRadius: BorderRadius.circular(15),
                  ),
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15)),
                  prefixIcon: Icon(
                    Icons.search,
                    color: appcolors.bluecolor,
                  ),
                  hintText: 'search',
                  hintStyle: TextStyle(color: appcolors.black),
                ),
              ),
            ),
            SizedBox(
              height: 20,
            ),
            SizedBox(
              width: MediaQuery.of(context).size.width,
              child: ElevatedButton(
                  onPressed: () {
                    setState(() {
                      search_country = _search.text;
                    });
                  },
                  child: Text("search")),
            ),
            FutureBuilder<List<WeatherData>>(
              future: fetchWeatherData(search_country),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  final weather = snapshot.data!;
                  return Expanded(
                    child: ListView.builder(
                      itemCount: weatherDataList.length,
                      itemBuilder: (context, index) {
                        return WeatherCard(data: weatherDataList[index]);
                      },
                    ),
                  );
                } else if (snapshot.hasError) {
                  return Text('you have to select your city');
                }
                return CircularProgressIndicator();
              },
            ),
          ],
        ),
      ),
    );
  }
}

class WeatherData {
  final DateTime dateTime;
  final String description;
  final double temperature;
  final String icon;

  WeatherData({
    required this.dateTime,
    required this.description,
    required this.temperature,
    required this.icon,
  });

  factory WeatherData.fromJson(Map<String, dynamic> json) {
    final DateTime dateTime =
        DateTime.fromMillisecondsSinceEpoch(json['dt'] * 1000);
    final String description = json['weather'][0]['description'];
    final double temperature = json['main']['temp'];
    final String icon = json['weather'][0]['icon'];
    return WeatherData(
      dateTime: dateTime,
      description: description,
      temperature: temperature,
      icon: icon,
    );
  }
}

class WeatherCard extends StatelessWidget {
  final WeatherData data;

  WeatherCard({required this.data});

  @override
  Widget build(BuildContext context) {
    final formattedDate = DateFormat('E, MMM d, HH:mm').format(data.dateTime);
    return Card(
      margin: EdgeInsets.all(8.0),
      elevation: 4.0,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              formattedDate,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            Image.network(
              'https://openweathermap.org/img/w/${data.icon}.png',
              width: 50,
              height: 50,
            ),
            Text(
              data.description,
              style: TextStyle(
                fontSize: 16,
              ),
            ),
            Text(
              '${data.temperature.toStringAsFixed(1)}°C',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
