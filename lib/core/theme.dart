import 'package:flutter/material.dart';

class AppColors {
  //Colors which will be used in the app
  static Color transparent = const Color.fromRGBO(0, 0, 0, 0);
  static Color lightTransparent = const Color.fromRGBO(116, 116, 116, 0.05);
  
  // New color palette based on the image
  static Color white = const Color.fromRGBO(255, 255, 255, 1);
  static Color black = const Color.fromRGBO(50, 50, 50, 1);
  static Color grey = const Color.fromRGBO(184, 184, 184, 1);
  static Color lightGrey = const Color.fromRGBO(240, 240, 240, 1);
  static Color darkGrey = const Color.fromRGBO(123, 123, 123, 1);
  static Color red = const Color.fromRGBO(235, 87, 87, 1);
  static Color green = const Color.fromRGBO(39, 174, 96, 1);
  static Color blue = const Color.fromRGBO(45, 95, 255, 1);
  
  // New primary color - warm yellow from the image
  static Color primary = const Color.fromRGBO(255, 236, 179, 1);
  static Color primaryDark = const Color.fromRGBO(240, 212, 140, 1);
  static Color secondaryYellow = const Color.fromRGBO(255, 219, 100, 1);
  static Color cardBg = const Color.fromRGBO(255, 255, 255, 1);
  static Color cardYellow = const Color.fromRGBO(255, 236, 179, 1);
  
  // Colors for the blurred navigation bar
  static Color navBarLightBg = const Color.fromRGBO(255, 236, 179, 0.9);
  static Color navBarDarkBg = const Color.fromRGBO(50, 50, 50, 0.9);
  static Color navBarShadow = const Color.fromRGBO(0, 0, 0, 0.1);
  static Color navBarActiveBg = const Color.fromRGBO(255, 219, 100, 0.5);
  static Color navBarDarkActiveBg = const Color.fromRGBO(100, 100, 100, 0.3);

  //Gradient colors for chart bars
  List<Color> gradientColors = [
    const Color.fromRGBO(45, 95, 255, 1),
    const Color.fromRGBO(131, 56, 236, 1),
  ];
}
