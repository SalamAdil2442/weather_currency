
import 'package:http/http.dart' as http;
import 'package:weather_app_test/model/currencies_model.dart';
import 'package:weather_app_test/model/rates_model.dart';
import 'package:weather_app_test/res/app_url.dart';

Future<RatesModel> fetchRates() async {
  var response = await http.get(Uri.parse(AppUrl.ratesUrl));
  final ratesModel = ratesModelFromJson(response.body);
  return ratesModel;
}

Future<Map> fetchCurrencies() async {
  var response = await http.get(Uri.parse(AppUrl.currenciesUrl));
  final allCurrencies = allCurrenciesFromJson(response.body);
  return allCurrencies;
}

