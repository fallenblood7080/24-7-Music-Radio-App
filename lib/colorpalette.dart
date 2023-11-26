import 'package:flutter/material.dart';

class ColorPalette {
  static List<Color> retro_1 = [
    const Color(0xFF4D4C7D),
    const Color(0xFF363062),
    const Color(0xFFF99417),
    const Color(0xFFF5F5F5),
  ];
  static List<Color> retro_2 = [
    const Color(0xFFFCF5ED),
    const Color(0xFFF4BF96),
    const Color(0xFFCE5A67),
    const Color(0xFF1F1717),
  ];
  static List<Color> retro_3 = [
    const Color(0xFFEEE2DE),
    const Color(0xFFEA906C),
    const Color(0xFFB31312),
    const Color(0xFF2B2A4C),
  ];
  static List<Color> retro_4 = [
    const Color(0xFF4C4C6D),
    const Color(0xFF1B9C85),
    const Color(0xFFE8F6EF),
    const Color(0xFFFFE194),
  ];
  static List<Color> retro_5 = [
    const Color(0xFFF9F5EB),
    const Color(0xFFE4DCCF),
    const Color(0xFFEA5455),
    const Color(0xFF002B5B),
  ];
  static List<Color> vintage_1 = [
    const Color(0xFFECE3CE),
    const Color(0xFF739072),
    const Color(0xFF4F6F52),
    const Color(0xFF3A4D39),
  ];
  static List<Color> vintage_2 = [
    const Color(0xFF132043),
    const Color(0xFF1F4172),
    const Color(0xFFF1B4BB),
    const Color(0xFFFDF0F0),
  ];
  static List<Color> vintage_3 = [
    const Color(0xFF252B48),
    const Color(0xFF445069),
    const Color(0xFF5B9A8B),
    const Color(0xFFF7E987),
  ];
  static List<Color> vintage_4 = [
    const Color(0xFF393E46),
    const Color(0xFF6D9886),
    const Color(0xFFF2E7D5),
    const Color(0xFFF7F7F7),
  ];
  static List<Color> vintage_5 = [
    const Color(0xFF2B3A55),
    const Color(0xFFCE7777),
    const Color(0xFFE8C4C4),
    const Color(0xFFF2E5E5),
  ];
    static List<Color> neon_1 = [
    const Color(0xFF27005D),
    const Color(0xFF9400FF),
    const Color(0xFFAED2FF),
    const Color(0xFFE4F1FF),
  ];
      static List<Color> neon_2 = [
    const Color(0xFF793FDF),
    const Color(0xFF7091F5),
    const Color(0xFF97FFF4),
    const Color(0xFFFFFD8C),
  ];
        static List<Color> neon_3 = [
    const Color(0xFF6F61C0),
    const Color(0xFFA084E8),
    const Color(0xFF8BE8E5),
    const Color(0xFFD5FFE4),
  ];
          static List<Color> neon_4 = [
    const Color(0xFF45FFCA),
    const Color(0xFFFEFFAC),
    const Color(0xFFFFB6D9),
    const Color(0xFFD67BFF),
  ];
  static List<Color> freecodecamp = [
    const Color(0xFF2a2a40),
    const Color(0xFF0a0a23),
    const Color(0xffFeac32),
    const Color(0xFFf5f6f7),
  ];
  static List<List<Color>> colorpalettes = [
    freecodecamp,
    retro_1,
    retro_2,
    retro_3,
    retro_4,
    retro_5,
    vintage_1,
    vintage_2,
    vintage_3,
    vintage_4,
    vintage_5,
    neon_1,
    neon_2,
    neon_3,
    neon_4,
  ];
  static List<Color> getNextColorpalette(List<Color> currentPalette) {
    int index = colorpalettes.indexOf(currentPalette);
    if (index == -1) {
      return colorpalettes[0];
    } else if (index == colorpalettes.length - 1) {
      return colorpalettes[0];
    } else {
      return colorpalettes[index + 1];
    }
  }

  static String currentPaletteName(List<Color> currentPalette) {
    List<String> colorpaletteNames = [
      "freecodecamp",
      "retro 1",
      "retro 2",
      "retro 3",
      "retro 4",
      "retro 5",
      "vintage 1",
      "vintage 2",
      "vintage 3",
      "vintage 4",
      "vintage 5",
      "neon 1",
      "neon 2",
      "neon 3",
      "neon 4",
    ];
    int index = colorpalettes.indexOf(currentPalette);

    if (index != -1) {
      return colorpaletteNames[index];
    } else {
      return "Some Unknown Colors XD";
    }
  }
}
