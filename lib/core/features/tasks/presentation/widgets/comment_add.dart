import 'package:flutter/material.dart';

Color getCardBackgoundColor(int index) {
  switch (index % 3) {
    case 0:
      return Color(0xff9BCEC1);
    case 1:
      return Color(0xffFFEBD3);
    case 2:
      return Color(0xffFFB6A6);
    default:
      return Color(0xff9BCEC1);
  }
}
