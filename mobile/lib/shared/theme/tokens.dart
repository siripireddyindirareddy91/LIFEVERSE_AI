import 'package:flutter/material.dart';

abstract final class Aurora {
  static const voidColor = Color(0xFF090B17);
  static const plum = Color(0xFF291538);
  static const orchid = Color(0xFFB45CFF);
  static const teal = Color(0xFF37E5C5);
  static const amber = Color(0xFFFFCA79);
  static const rose = Color(0xFFF18DBD);
  static const mist = Color(0xFFD9F5F0);
  static const silver = Color(0xFFA8A9BC);
  static const light = Color(0xFFF8F6FF);
  static const gradient = LinearGradient(
    colors: [plum, voidColor],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
}

abstract final class Space {
  static const xs = 4.0;
  static const sm = 8.0;
  static const md = 16.0;
  static const lg = 24.0;
  static const xl = 32.0;
  static const xxl = 48.0;
}

abstract final class ShapeTokens {
  static const radius = 24.0;
  static const controlRadius = 14.0;
  static const elevation = 0.0;
}

abstract final class MotionTokens {
  static const standard = Duration(milliseconds: 240);
  static Duration duration(BuildContext context) =>
      MediaQuery.disableAnimationsOf(context) ? Duration.zero : standard;
}
