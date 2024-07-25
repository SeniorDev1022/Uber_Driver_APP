import 'package:flutter/material.dart';

class ColorManager {
  static Color hextocolor(String code) {
    return Color(int.parse(code.substring(1, 7), radix: 16) + 0xFF000000);
  }

  static Color primary_color = hextocolor("#0090A0");
  static Color primary_50_color = hextocolor("#C5F9FF");
  static Color dark_primary_color = hextocolor("#00393B");
  static Color primary_10_color = hextocolor("#BCECF1");
  static Color button_no_decoration_color = hextocolor("#BCECF1");
  static const Color submitButton_gradient_left_color = Color(0xFFE8EAE9);
  static const Color submitButton_gradient_right_color = Color(0xFF838483);
  static Color button_login_background_color = hextocolor("#0090A0");
  static Color primary_gery_color = hextocolor("#EAEEF1");
  static Color primary_white_color = hextocolor("#FEFCF6");
  static Color button_mainuser_left_color = hextocolor("#00393B");
  static Color button_star_color = hextocolor("#FFC107");
  static Color button_mainuser_right_color = hextocolor("#009CA1");
}
