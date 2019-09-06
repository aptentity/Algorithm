import 'package:flutter/rendering.dart';
import 'dart:ui' as ui show window;

double getAdapterRatio() {
  double screenWidth = 750;
  if (null == screenWidth || screenWidth <= 0) {
    screenWidth = 750;
  }
  screenWidth = screenWidth / 2;
  return ui.window.physicalSize.width / screenWidth;
}

double getAdapterRatioRatio() {
  return getAdapterRatio() / ui.window.devicePixelRatio;
}

Size getScreenAdapterSize() {
  double screenWidth = 750;
  if (null == screenWidth || screenWidth <= 0) {
    screenWidth = 750;
  }
  screenWidth = screenWidth / 2;
  return Size(screenWidth, ui.window.physicalSize.height / getAdapterRatio());
}

class ScreenAdaptConfig {
  double width;
  double height;

  ScreenAdaptConfig(this.width, this.height);
}
/*
const double SCREEN_WIDTH = 400;

double getAdapterRatio() {
  return ui.window.physicalSize.width / SCREEN_WIDTH;
}

double getAdapterRatioRatio() {
  return getAdapterRatio() / ui.window.devicePixelRatio;
}

Size getScreenAdapterSize() {
  return Size(SCREEN_WIDTH, ui.window.physicalSize.height / getAdapterRatio());
}
class ScreenAdaptConfig {
  double width;
  double height;

  ScreenAdaptConfig(this.width, this.height);
}*/
