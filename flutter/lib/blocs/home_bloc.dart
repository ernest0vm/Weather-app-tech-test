
import 'package:flutter/material.dart';
import 'package:rxdart/rxdart.dart';
import 'package:travel_app/environment.dart';
import 'package:travel_app/managers/api_manager.dart';
import 'package:travel_app/models/final_response.dart';
import 'package:travel_app/models/places_model.dart';
import 'package:travel_app/models/weather_model.dart';
import 'package:travel_app/utils/enums.dart';

mixin HomeBloc {
  //streams
  final BehaviorSubject<WeatherModel> _weather =
      BehaviorSubject<WeatherModel>();

  final BehaviorSubject<List<PlacesModel>> _places =
      BehaviorSubject<List<PlacesModel>>();

  // getters
  Stream<WeatherModel> get getWeatherStream => _weather.stream;
  WeatherModel get getWeather => _weather.value;
  Stream<List<PlacesModel>> get getPlacesListStream => _places.stream;
  List<PlacesModel> get getPlacesList => _places.value;

  // setters
  void setWeather(WeatherModel weather) {
    _weather.sink.add(weather);
  }

  void setPlaces(List<PlacesModel> places) {
    _places.sink.add(places);
  }

  // functions
  Future<void> requestWeather(double lat, double lng) async {
    FinalResponse response = await ApiManager.instance.getWeatherInfo(lat, lng);

    if (response.hasData) {
      WeatherModel weather = WeatherModel.fromJson(response.data);
      setWeather(weather);
    }
  }

  Future<void> requestCities(String name) async {
    FinalResponse response = await ApiManager.instance.getPlacesByName(name);

    if (response.hasData) {
      List<PlacesModel> places = <PlacesModel>[];

      for (var item in response.data) {
        PlacesModel place = PlacesModel.fromJson(item);
        if (place != null) {
          places.add(place);
        }
      }

      places.retainWhere((place) => place.resultType == ResultType.city);
      setPlaces(places);
    }
  }

  String getIconUrl(BuildContext context, String iconName) {
    return '${Environment.of(context).weatherIconBaseUrl}/$iconName@2x.png';
  }

  void dispose() {
    _weather?.close();
    _places?.close();
  }
}
