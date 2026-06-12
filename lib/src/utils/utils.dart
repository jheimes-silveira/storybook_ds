import 'package:flutter/services.dart';

class Utils {
  static copyClipboard(String copy) {
    Clipboard.setData(ClipboardData(text: copy));
  }

  static Future<String> pasteClipboard() async {
    ClipboardData? data = await Clipboard.getData('text/plain');
    return data!.text ?? '';
  }

  static String colorToHex(Color color) {
    int r = (color.r * 255.0).round().clamp(0, 255);
    int g = (color.g * 255.0).round().clamp(0, 255);
    int b = (color.b * 255.0).round().clamp(0, 255);
    int a = (color.a * 255.0).round().clamp(0, 255);
    String red = r.toRadixString(16).padLeft(2, '0');
    String green = g.toRadixString(16).padLeft(2, '0');
    String blue = b.toRadixString(16).padLeft(2, '0');
    String alpha = a.toRadixString(16).padLeft(2, '0');
    return '#$alpha$red$green$blue'.toUpperCase();
  }
}
