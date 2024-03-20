import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_map_location_marker/flutter_map_location_marker.dart';
import 'package:cloud_functions/cloud_functions.dart';
import 'package:geolocator/geolocator.dart';
import 'package:intl/intl.dart';

Future<String> getParks(String date, String time) async {
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
  final DateTime datetime_now = DateTime.now(); 

  final dateFormatter = DateFormat('yyyy-MM-dd');
  final timeFormatter = DateFormat('HH:mm:ss');

  final formattedDate = dateFormatter.format(datetime_now);
  final formattedTime = timeFormatter.format(datetime_now);

  //Additional code to run cloud function 
  final result = await FirebaseFunctions.instance.httpsCallable('calcParkShading').call(
    {
      "lat": position.latitude,
      "long": position.longitude,
      "date": formattedDate,
      "time": formattedTime, 
    },
  );
  return result.data as String;
}

class MyHomePage extends StatelessWidget {
  const MyHomePage({super.key, required this.title});
  final String title;

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Theme.of(context).colorScheme.inversePrimary,
          title: Text(title),
        ),
        body: Column(children: <Widget>[
          SizedBox(
            height:MediaQuery.of(context).size.height / 2.2,
            child: FlutterMap(
              options: const MapOptions(
                minZoom: 8,
                maxZoom: 18,
                initialZoom: 13,
              ),
              children: [
                TileLayer(
                  urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                ),
                const RichAttributionWidget(
                  attributions: [
                    TextSourceAttribution(
                      'OpenStreetMap contributors',)
                  ],
                ),
                CurrentLocationLayer(
                  alignPositionOnUpdate: AlignOnUpdate.always,
                ),
              ],
              )
          ),
          const PreferredSize(
            preferredSize: Size.fromHeight(50.0),
            child: TabBar(
              labelColor:Colors.black,
              tabs: [
                Tab(
                  text: 'Sun Finder'
                ),
                Tab(
                  text: 'Heliodon',
                )
              ],
              )
            ),
            Expanded(
              child: TabBarView(
                children: [
                  Container(
                    color:Colors.white,
                    height:  MediaQuery.of(context).size.height / 2.5,
                    child: Center(
                      child: TextButton(
                        onPressed: () {  },
                        style: TextButton.styleFrom(
                          backgroundColor: Colors.orange,
                          ), 
                        child: const Text('Find nearest sun'),
                        )
                      ),
                    ),
                  Container(
                    color: Colors.blue,
                    height:  MediaQuery.of(context).size.height / 2.5,
                    )
                ],
                )
              )
        ]
      )
      )
    );
  }
}