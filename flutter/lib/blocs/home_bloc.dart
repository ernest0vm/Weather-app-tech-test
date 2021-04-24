import 'package:rxdart/rxdart.dart';
import 'package:travel_app/managers/api_manager.dart';
import 'package:travel_app/models/final_response.dart';
import 'package:travel_app/models/places_model.dart';
import 'package:travel_app/models/weather_model.dart';

mixin HomeBloc {
  final BehaviorSubject<WeatherModel> _weather =
      BehaviorSubject<WeatherModel>();

  final BehaviorSubject<List<PlacesModel>> _places =
      BehaviorSubject<List<PlacesModel>>();

  Stream<WeatherModel> get getWeatherStream => _weather.stream;
  Stream<List<PlacesModel>> get getPlacesListStream => _places.stream;

  void setWeather(WeatherModel weather) {
    _weather.sink.add(weather);
  }

  void setPlaces(List<PlacesModel> places) {
    _places.sink.add(places);
  }

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
      List<PlacesModel> places = response.data.forEach((place) => PlacesModel.fromJson(place));
      setPlaces(places);
    }
  }

  void dispose() {
    _weather?.close();
    _places?.close();
  }
}
