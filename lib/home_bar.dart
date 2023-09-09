import 'package:flutter/material.dart';
import 'package:weather_app_test/model/data_models.dart';
import 'package:weather_app_test/screens/home_screen.dart';
import 'package:weather_app_test/screens/view/currency_screen.dart';

class home_screen extends StatefulWidget {
  @override
  State<home_screen> createState() => _home_screenState();
}

class _home_screenState extends State<home_screen> {
  int _selectedIndex = 0;
  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  final pages = [
    weather_screen(),
    currency_screen(),
  ];
  @override
  Widget build(BuildContext context) {

    return Scaffold(
      body: pages[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        items: <BottomNavigationBarItem>[
          BottomNavigationBarItem(
              icon: Icon(Icons.sunny, color: Colors.yellowAccent),
              label: "weather"),
          BottomNavigationBarItem(
              icon: Icon(
                Icons.currency_exchange,
                color: Colors.yellowAccent,
              ),
              label: "Currency"),
        ],
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
      ),
    );
  }
}
