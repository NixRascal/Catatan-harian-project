import 'package:flutter/material.dart';

class AppColors {
  AppColors._();

  static const Color background = Color(0xFFF7F9FB);
  static const Color surface = Color(0xFFF7F9FB);
  static const Color surfaceLowest = Color(0xFFFFFFFF);
  static const Color surfaceLow = Color(0xFFF2F4F6);
  static const Color surfaceContainer = Color(0xFFECEEF0);
  static const Color surfaceHigh = Color(0xFFE6E8EA);
  static const Color surfaceHighest = Color(0xFFE0E3E5);

  static const Color onSurface = Color(0xFF191C1E);
  static const Color onSurfaceVariant = Color(0xFF444748);
  static const Color muted = Color(0xFF747877);
  static const Color outline = Color(0xFF747877);
  static const Color outlineVariant = Color(0xFFC4C7C7);

  static const Color primary = Color(0xFF000000);
  static const Color primaryHover = Color(0xFF2D3133);
  static const Color primaryOn = Color(0xFFFFFFFF);
  static const Color primarySoft = Color(0x14000000);

  static const Color secondary = Color(0xFF515F74);
  static const Color error = Color(0xFFBA1A1A);

  static const Color hover = Color(0x0A151C27);
  static const Color field = Color(0xFFFFFFFF);
  static const Color fieldBorder = Color(0xFFE2E5EA);

  static const Map<String, Color> tints = {
    'peach': Color(0xFFFFEEE2),
    'rose': Color(0xFFFFE4EA),
    'mint': Color(0xFFDDF4E6),
    'lavender': Color(0xFFEDE4FF),
    'sky': Color(0xFFDDEAFE),
    'yellow': Color(0xFFFFF4CC),
    'paper': Color(0xFFF2F4F6),
  };

  static const List<String> tintOrder = [
    'peach',
    'rose',
    'mint',
    'lavender',
    'sky',
    'yellow',
    'paper',
  ];

  static Color tintFor(String? key, {int fallbackIndex = 0}) {
    if (key != null && tints.containsKey(key)) return tints[key]!;
    return tints[tintOrder[fallbackIndex % tintOrder.length]]!;
  }
}
