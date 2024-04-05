import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_map_location_marker/flutter_map_location_marker.dart';

class InputMarkList extends ChangeNotifier {
  AlignOnUpdate _alignOnUpdate = AlignOnUpdate.always;
  AlignOnUpdate get aln => _alignOnUpdate;

  List<Marker> inputMarkers = [];
  List<Marker> get marks => inputMarkers;

  void setAlign(AlignOnUpdate setting) {
    _alignOnUpdate = setting;
    notifyListeners();
  }

  void clearMarkers() {
    inputMarkers.clear();
    notifyListeners();
  }

  void addMarker(Marker mark) {
    inputMarkers.add(mark);
    notifyListeners();
  }
}