import 'package:flutter/material.dart';
class ExposureLog extends ChangeNotifier {
  int minutes = 0;
  int get mins => minutes;

  void increment() {
    minutes++;
    notifyListeners();
  }
}