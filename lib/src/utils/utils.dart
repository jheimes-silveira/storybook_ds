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
    String red = color.red.toRadixString(16).padLeft(2, '0');
    String green = color.green.toRadixString(16).padLeft(2, '0');
    String blue = color.blue.toRadixString(16).padLeft(2, '0');
    String alpha = color.alpha.toRadixString(16).padLeft(2, '0');
    return '#$alpha$red$green$blue'.toUpperCase();
  }
}
