import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart';
import 'package:travel_app/models/final_response.dart';

class ResponseBuilder {
  static Future<FinalResponse> fromStream(StreamedResponse response) async {
    FinalResponse _response = FinalResponse();
    bool hasData = false;
    bool hasError = true;

    if (response.statusCode >= 200 && response.statusCode <= 299) {
      hasData = true;
    } else if (response.statusCode >= 300 && response.statusCode <= 599) {
      hasData = false;
    }
    hasError = !hasData;

    _response.statusCode = response.statusCode;
    _response.request = response.request;
    _response.hasData = hasData;
    _response.hasError = hasError;

    if (hasData) {
      _response.data = json.decode(await response.stream.bytesToString());
    } else {
      _response.error = response.reasonPhrase;
    }
    _debugResponse(_response);
    return _response;
  }

  static void _debugResponse(FinalResponse response) {
    debugPrint("""
  
  REQUEST =====================================================================
  method: ${response.request.method}
  url: ${response.request.url.toString()}
  headers: ${response.request.headers.isNotEmpty ? response.request.headers.toString() : "no headers"}
  body: ${response.request.body.isNotEmpty ? response.request.body.toString() : "no body"}
  RESPONSE =====================================================================
  statusCode: ${response.statusCode.toString()}
  hasData: ${response.hasData.toString()}
  hasError: ${response.hasError.toString()}
  body: ${response.data.toString()}
  error: ${(response.error ?? "error not found")}
  END ==========================================================================
  """);
  }
}
