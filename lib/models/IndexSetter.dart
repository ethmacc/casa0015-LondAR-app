import 'package:flutter/material.dart';

class IndexSetter extends ChangeNotifier {
  int index = 0;
  int get idx => index;

  void setIndex(int target) {
    index = target;
    notifyListeners();
  }
}