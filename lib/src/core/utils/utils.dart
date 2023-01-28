import 'package:flutter/services.dart';

class Utils {
  static copyClipboard(String copy) {
    Clipboard.setData(ClipboardData(text: copy));
  }

  static Future<String> pasteClipboard() async {
    ClipboardData? data = await Clipboard.getData('text/plain');
    return data!.text ?? '';
  }
}
