import 'package:flutter/material.dart';

class ScreenUtil {
  static double? screenWidth;
  static double? screenHeight;
  static double? screenPixelRatio;

  static void init(BuildContext context) {
    screenWidth = MediaQuery.of(context).size.width;
    screenHeight = MediaQuery.of(context).size.height;
    screenPixelRatio = MediaQuery.of(context).devicePixelRatio;
  }

  static double setWidth(double width) {
    return screenWidth! * (width / 375.0);
  }

  static double setHeight(double height) {
    return screenHeight! * (height / 812.0);
  }

  static double setSp(double fontSize) {
    double scaleWidth = screenWidth! / 375.0;
    double scaleHeight = screenHeight! / 812.0;
    double scaleText = scaleWidth < scaleHeight ? scaleWidth : scaleHeight;
    return (fontSize * scaleText);
  }
}
