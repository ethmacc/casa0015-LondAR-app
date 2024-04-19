import 'package:flutter/material.dart';
class MapLock extends ChangeNotifier {
  bool locked = false;
  bool get isLocked => locked;

  void Lock() {
    locked = true;
    notifyListeners();
  }

  void Unlock() {
    locked = false;
    notifyListeners();
  }
}