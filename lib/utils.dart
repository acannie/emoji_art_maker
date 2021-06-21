import 'dart:math';

import 'package:flutter/material.dart';

// ロジック系の関数
class Utils {
  Map<String, Map<String, dynamic>>? emojis = {
    "red": {"rgb": Color.fromARGB(255, 255, 0, 0), "emoji": "🟥"},
    "orange": {"rgb": Color.fromARGB(255, 255, 165, 0), "emoji": "🟧"},
    "yellow": {"rgb": Color.fromARGB(255, 255, 255, 0), "emoji": "🟨"},
    "green": {"rgb": Color.fromARGB(255, 0, 255, 0), "emoji": "🟩"},
    "blue": {"rgb": Color.fromARGB(255, 0, 0, 255), "emoji": "🟦"},
    "purple": {"rgb": Color.fromARGB(255, 128, 0, 128), "emoji": "🟪"},
    "brown": {"rgb": Color.fromARGB(255, 128, 0, 0), "emoji": "🟫"},
    "black": {"rgb": Color.fromARGB(255, 0, 0, 0), "emoji": "⬛️"},
    "white": {"rgb": Color.fromARGB(255, 255, 255, 255), "emoji": "⬜️"}
  };

  double _colorDistance(Color pixel, Color emoji) {
    double doubledEuclideanDistance = 0.0;
    // doubledEuclideanDistance += pow((pixel.red - emoji.red), 2);
    // doubledEuclideanDistance += pow((pixel.green - emoji.green), 2);
    // doubledEuclideanDistance += pow((pixel.blue - emoji.blue), 2);
    HSVColor hsvPixel = HSVColor.fromColor(pixel);
    HSVColor hsvEmoji = HSVColor.fromColor(emoji);
    double hueDistance = min((hsvPixel.hue - hsvEmoji.hue).abs(),
        360 - (hsvPixel.hue - hsvEmoji.hue).abs());

    doubledEuclideanDistance += pow(hueDistance, 2);
    doubledEuclideanDistance +=
        pow((hsvPixel.saturation * 360 - hsvEmoji.saturation * 360), 2);
    doubledEuclideanDistance +=
        pow((hsvPixel.value * 360 - hsvEmoji.value * 360), 2);
    return sqrt(doubledEuclideanDistance);
  }

  String similarEmoji(Color pixel) {
    if (pixel.alpha == 0) {
      return emojis!["white"]!["emoji"]!;
    }
    double smallestDistance = sqrt(pow(255, 2) * 3);
    String targetEmoji = "?";
    emojis!.forEach((String key, dynamic value) {
      double distance = _colorDistance(pixel, value["rgb"]);
      if (distance < smallestDistance) {
        smallestDistance = distance;
        targetEmoji = value["emoji"];
      }
    });

    return targetEmoji;
  }

  int abgrToArgb(int argbColor) {
    int r = (argbColor >> 16) & 0xFF;
    int b = argbColor & 0xFF;
    return (argbColor & 0xFF00FF00) | (b << 16) | r;
  }
}
