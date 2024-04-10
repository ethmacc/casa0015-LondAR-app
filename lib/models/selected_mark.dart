import 'package:flutter/material.dart';

class SelectedMark extends ChangeNotifier {
  int index = 0;
  int get idx => index;
  bool changeBool = false;
  bool get isChanged => changeBool;

  void setIndex(int target) {
    index = target;
    changeBool = true;
    notifyListeners();
  }

  void clearChange() {
    changeBool = false;
    notifyListeners();
  }
}