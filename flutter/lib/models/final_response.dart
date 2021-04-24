import 'package:http/http.dart';

class FinalResponse {
  int statusCode;
  bool hasData;
  bool hasError;
  dynamic data;
  String error;
  Request request;

  FinalResponse(
      {this.statusCode,
      this.hasData,
      this.hasError,
      this.data,
      this.error,
      this.request});

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['statusCode'] = this.statusCode;
    data['hasData'] = this.hasData;
    data['hasError'] = this.hasError;
    data['data'] = this.data;
    data['error'] = this.error;
    data['request'] = this.request.toString();
    return data;
  }
}
