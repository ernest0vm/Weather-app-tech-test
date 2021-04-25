import 'package:flutter/material.dart';
import 'package:travel_app/app.dart';
import 'package:travel_app/environment.dart';

void main() {
  final Environment environment = Environment(
    serviceBaseUrl: 'https://search.reservamos.mx/api/v2',
    weatherBaseUrl: 'https://api.openweathermap.org/data/2.5',
    weatherIconBaseUrl: 'http://openweathermap.org/img/wn',
    weatherApiKey: 'a5a47c18197737e8eeca634cd6acb581',
    child: App(),
  );
  runApp(environment);
}
