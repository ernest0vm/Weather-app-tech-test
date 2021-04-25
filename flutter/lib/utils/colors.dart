import 'package:flutter/material.dart';

class AppColors {
  //colors
  static const Color primary = Colors.lightBlue;
  static const Color secondary = Colors.white;

  // gradients
  static const LinearGradient verticalGradient = LinearGradient(
      begin: FractionalOffset.topCenter,
      end: FractionalOffset.bottomCenter,
      stops: [0.10, 0.90],
      colors: [AppColors.secondary, AppColors.primary],
      tileMode: TileMode.clamp);

  static const LinearGradient invertedVerticalGradient = LinearGradient(
      begin: FractionalOffset.topCenter,
      end: FractionalOffset.bottomCenter,
      stops: [0.10, 0.90],
      colors: [AppColors.primary, AppColors.secondary],
      tileMode: TileMode.clamp);
}
