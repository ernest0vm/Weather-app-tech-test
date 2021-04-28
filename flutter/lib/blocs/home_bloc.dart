import 'package:flutter/material.dart';
import 'package:location/location.dart';
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

  final BehaviorSubject<List<PlacesModel>> _placesFrom =
      BehaviorSubject<List<PlacesModel>>();

  final BehaviorSubject<PlacesModel> _selectedPlace =
      BehaviorSubject<PlacesModel>();

  // getters
  Stream<WeatherModel> get getWeatherStream => _weather.stream;
  WeatherModel get getWeather => _weather.value;
  Stream<List<PlacesModel>> get getPlacesListStream => _places.stream;
  List<PlacesModel> get getPlacesList => _places.value;
  Stream<List<PlacesModel>> get getPlacesFromListStream => _placesFrom.stream;
  List<PlacesModel> get getPlacesFromList => _placesFrom.value;
  Stream<PlacesModel> get getSelectedPlaceStream => _selectedPlace.stream;
  PlacesModel get getSelectedPlace => _selectedPlace.value;

  // setters
  void setWeather(WeatherModel weather) {
    _weather.sink.add(weather);
  }

  void setPlaces(List<PlacesModel> places) {
    _places.sink.add(places);
  }

  void setPlacesFrom(List<PlacesModel> placesFrom) {
    _placesFrom.sink.add(placesFrom);
  }

  void setSelectedPlace(PlacesModel place) {
    _selectedPlace.sink.add(place);
  }

  // functions
  Future<void> requestWeather(String lat, String lng) async {
    setWeather(null);
    FinalResponse response = await ApiManager.instance.getWeatherInfo(lat, lng);

    if (response.hasData) {
      WeatherModel weather = WeatherModel.fromJson(response.data);
      setWeather(weather);
    }
  }

  Future<void> requestCities(String name) async {
    if (name.isNotEmpty) {
      FinalResponse response = await ApiManager.instance.getPlacesByNameAndFrom(name, null);

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
        setPlacesFrom(places);
      }
    } else {
      setPlaces(null);
    }
  }

  Future<void> requestCitiesFrom(String name, String from) async {
    if (name.isNotEmpty) {
      FinalResponse response = await ApiManager.instance.getPlacesByNameAndFrom(name, from);

      if (response.hasData) {
        List<PlacesModel> places = <PlacesModel>[];

        for (var item in response.data) {
          PlacesModel place = PlacesModel.fromJson(item);
          if (place != null) {
            places.add(place);
          }
        }

        places.retainWhere((place) => place.resultType == ResultType.city);
        setPlacesFrom(places);
      }
    } else {
      setPlacesFrom(null);
    }
  }

  String getIconUrl(BuildContext context, String iconName) {
    return '${Environment.of(context).weatherIconBaseUrl}/$iconName@2x.png';
  }

  Future<void> requestLocation() async {
    Location location = new Location();

    bool _serviceEnabled;
    PermissionStatus _permissionGranted;
    LocationData _locationData;

    _serviceEnabled = await location.serviceEnabled();
    if (!_serviceEnabled) {
      _serviceEnabled = await location.requestService();
      if (!_serviceEnabled) {
        return;
      }
    }

    _permissionGranted = await location.hasPermission();
    if (_permissionGranted == PermissionStatus.denied) {
      _permissionGranted = await location.requestPermission();
      if (_permissionGranted != PermissionStatus.granted) {
        await requestCities("CDMX");
        setSelectedPlace(getPlacesList.first);
        PlacesModel selectedPlace = getSelectedPlace;
        if (selectedPlace != null) {
          requestWeather(selectedPlace.lat, selectedPlace.long);
        }
        return;
      }
    }

    _locationData = await location.getLocation();

    requestWeather(
        _locationData.latitude.toString(), _locationData.longitude.toString());
  }

  void dispose() {
    _weather?.close();
    _places?.close();
    _placesFrom?.close();
    _selectedPlace?.close();

  }
}
