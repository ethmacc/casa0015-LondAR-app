import 'package:flutter/material.dart';
import 'package:latlong2/latlong.dart';

class RouteModel extends ChangeNotifier {
  List<LatLng> points = [];
  List<LatLng> get pts => points;

  void clearPoints() {
    points.clear();
    notifyListeners();
  }

  void setRoute(List<LatLng> newPoints) {
    points = newPoints;
    notifyListeners();
  }
}