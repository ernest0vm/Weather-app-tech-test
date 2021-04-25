import 'package:flutter/material.dart';

class AppStyles {
  static const TextStyle currentTemp =
      TextStyle(fontSize: 70, fontWeight: FontWeight.w300);

  static const TextStyle dailyForeCastTemp =
      TextStyle(fontSize: 40, fontWeight: FontWeight.bold);
  static TextStyle dailyForeCastDate = TextStyle(
      fontSize: 16, fontWeight: FontWeight.w300, color: Colors.grey.shade700);
  static const TextStyle dailyForeCastDescription =
      TextStyle(fontSize: 24, fontWeight: FontWeight.w500);

  static const TextStyle weatherExtraItemText =
      TextStyle(fontSize: 14, fontWeight: FontWeight.w300);

  static const TextStyle simpleForecastItemMax =
      TextStyle(fontSize: 16, fontWeight: FontWeight.w400);
  static const TextStyle simpleForecastItemMin =
      TextStyle(fontSize: 14, fontWeight: FontWeight.w300);

  static const TextStyle sectionTitleLight = TextStyle(
    fontSize: 24,
    fontWeight: FontWeight.w500,
    color: Colors.white,
    shadows: [
      Shadow(color: Colors.black, offset: Offset(0, 1)),
    ],
  );

  static TextStyle sectionTitleDark = TextStyle(
    fontSize: 24,
    fontWeight: FontWeight.w500,
    color: Colors.black,
  );
}
