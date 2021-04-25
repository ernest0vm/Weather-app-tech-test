import "package:flutter/foundation.dart";
import "package:flutter/material.dart";
import "package:meta/meta.dart";

class Environment extends InheritedWidget {
  const Environment(
      {@required this.weatherApiKey,
      @required this.child,
      @required this.weatherBaseUrl,
      @required this.weatherIconBaseUrl,
      @required this.serviceBaseUrl,
      Key key})
      : super(key: key);

  final Widget child;
  final String weatherBaseUrl;
  final String weatherIconBaseUrl;
  final String serviceBaseUrl;
  final String weatherApiKey;

  static Environment of(BuildContext context) =>
      context.dependOnInheritedWidgetOfExactType(aspect: Environment);

  @override
  bool updateShouldNotify(InheritedWidget oldWidget) => false;

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(StringProperty("serviceBaseUrl", serviceBaseUrl));
    properties.add(StringProperty("weatherBaseUrl", weatherBaseUrl));
    properties.add(StringProperty("weatherIconBaseUrl", weatherIconBaseUrl));
    properties.add(StringProperty("weatherApiKey", weatherApiKey));
    properties.add(DiagnosticsProperty<Widget>("child", child));
  }
}
