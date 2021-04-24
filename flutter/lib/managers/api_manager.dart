import 'package:flutter/material.dart';
import "package:http/http.dart" as http;
import 'package:travel_app/environment.dart';
import 'package:travel_app/helpers/response_builder.dart';
import 'package:travel_app/models/final_response.dart';
import 'package:travel_app/models/places_model.dart';

class ApiManager {
  // singleton
  ApiManager._internal();
  static ApiManager _instance = ApiManager._internal();
  static ApiManager get instance => _instance;

  // private members
  BuildContext _context;

  void init(BuildContext context) {
    debugPrint("ApiManager initizalized.");
    _context = context;
  }

  Future<FinalResponse> getWeatherInfo(
    double lat,
    double lng,
  ) async {
    String endpoint =
        '${Environment.of(_context).weatherBaseUrl}/onecall?lat=$lat&lon=$lng&exclude=minutely,hourly&appid=${Environment.of(_context).weatherApiKey}';
    http.Request request = http.Request('GET', Uri.parse(endpoint));

    http.StreamedResponse response = await request.send();
    FinalResponse finalResponse = await ResponseBuilder.fromStream(response);
    return finalResponse;
  }

  Future<FinalResponse> getPlacesByName(String name) async {
    String endpoint =
        '${Environment.of(_context).serviceBaseUrl}/places?q=$name';
    http.Request request = http.Request('GET', Uri.parse(endpoint));

    http.StreamedResponse response = await request.send();
    FinalResponse finalResponse = await ResponseBuilder.fromStream(response);
    return finalResponse;
  }

  
}
