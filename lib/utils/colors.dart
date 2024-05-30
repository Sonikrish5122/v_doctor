import 'dart:ui';
import 'package:flutter/material.dart';

Color hexToColor(String hex) {
  assert(RegExp(r'^#([0-9a-fA-F]{6})|([0-9a-fA-F]{8})$').hasMatch(hex),
      'hex color must be #rrggbb or #rrggbbaa');

  return Color(
    int.parse(hex.substring(1), radix: 16) +
        (hex.length == 7 ? 0xff000000 : 0x00000000),
  );
}

class ColorConstants {
  static Color primaryColor = hexToColor('#5871FE');
  static Color accentColor = hexToColor('#FEAE03');
  static Color secondaryAppColor = hexToColor('#5E92F3');
  static Color secondaryTextColor = hexToColor('#808080');
  static Color white = hexToColor('#FFFFFF');
  static Color tabbarColor = hexToColor('#c69c70');
  static Color btnColor = hexToColor('#f5f1f0');
  static Color homebackground = hexToColor('#f6f6f6');
  static Color iconBackground = hexToColor('#616161');
  static Color PendingBackground = hexToColor('#fead03');
  static Color appontmentDetailsTxt = hexToColor('#636363');
  static Color SwitchColor = hexToColor('#f9ab03');
  static Color activeTrackColor = hexToColor('#f8e3b6');
  static Color DateSelecte = hexToColor('#FEAE03');
  static Color LightGray = hexToColor('#6a6a6a');
}
