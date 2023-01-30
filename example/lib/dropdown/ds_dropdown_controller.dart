import 'package:flutter/material.dart';

class DSDropdownController extends ValueNotifier {
  bool _isOpened;
  String? _error;

  DSDropdownController({
    bool isOpened = false,
    String? error,
  })  : _isOpened = isOpened,
        _error = error,
        super(null);

  bool get isOpened => _isOpened;

  set isOpened(bool isOpened) {
    _isOpened = isOpened;
    notifyListeners();
  }

  String? get error => _error;

  set error(String? error) {
    _error = error;
    notifyListeners();
  }
}
