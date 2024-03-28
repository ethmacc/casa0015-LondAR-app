import 'package:cloud_functions/cloud_functions.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:intl/intl.dart';
import 'dart:async';

Future<Object> getParks() async {
  //Adapted from https://pub.dev/packages/geolocator
  bool serviceEnabled;
  LocationPermission permission;

  // Test if location services are enabled.
  serviceEnabled = await Geolocator.isLocationServiceEnabled();
  if (!serviceEnabled) {
    return Future.error('Location services are disabled.');
  }

  permission = await Geolocator.checkPermission();
  if (permission == LocationPermission.denied) {
    permission = await Geolocator.requestPermission();
    if (permission == LocationPermission.denied) {
      return Future.error('Location permissions are denied');
    }
  }
  
  if (permission == LocationPermission.deniedForever) {
    return Future.error(
      'Location permissions are permanently denied, we cannot request permissions.');
  } 

  Position position = await Geolocator.getCurrentPosition();

  //Adapted from https://www.dhiwise.com/post/understanding-the-importance-of-flutter-get-current-timestamp
  final DateTime datetimeNow = DateTime.now(); 

  final dateFormatter = DateFormat('yyyy-MM-dd');
  final timeFormatter = DateFormat('HH:mm:ss');

  final formattedDate = dateFormatter.format(datetimeNow);
  final formattedTime = timeFormatter.format(datetimeNow);

  try {
    final result = await FirebaseFunctions.instance.httpsCallable('calcParkShading').call(
      {
        "lat": position.latitude,
        "long": position.longitude,
        "dateStr": formattedDate,
        "timeStr": '18:00:00', 
      },
    );
    return result.data;
  } on FirebaseFunctionsException catch (error) {
    print(error.code);
    print(error.details);
    print(error.message);
    print({
        "lat": position.latitude,
        "long": position.longitude,
        "dateStr": formattedDate,
        "timeStr": '18:00:00', 
      });
    return 'FunctionError';
  }
}