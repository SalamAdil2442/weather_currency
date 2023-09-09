import 'package:flutter/material.dart';
import 'package:weather_app_test/controller/api_services.dart';
import 'package:weather_app_test/model/rates_model.dart';
import 'package:weather_app_test/screens/view/conversion_card.dart';
import 'package:weather_app_test/widget/colors.dart';

class currency_screen extends StatefulWidget {
  currency_screen({super.key});

  @override
  State<currency_screen> createState() => _currency_screenState();
}

class _currency_screenState extends State<currency_screen> {
  late Future<RatesModel> ratesModel;
  late Future<Map> currenciesModel;

  @override
  void initState() {
    super.initState();
    _fetchData();
  }

  Future<void> _fetchData() async {
    ratesModel = fetchRates();
    currenciesModel = fetchCurrencies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: appcolors.whitecolor,
      body: FutureBuilder<RatesModel>(
          future: ratesModel,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(
                child: CircularProgressIndicator(),
              );
            } else {
              return FutureBuilder<Map>(
                  future: currenciesModel,
                  builder: (context, index) {
                    if (index.connectionState == ConnectionState.waiting) {
                      return const Center(
                        child: CircularProgressIndicator(),
                      );
                    } else if (index.hasError) {
                      return Center(child: Text('Error: ${index.error}'));
                    } else {
                      return ConversionCard(
                        rates: snapshot.data!.rates,
                        currencies: index.data!,
                      );
                    }
                  });
            }
          }),
    );
  }
}
