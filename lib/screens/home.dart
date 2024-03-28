import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_map_location_marker/flutter_map_location_marker.dart';
import 'package:latlong2/latlong.dart';
import '../widgets/ParksList.dart';
import '../widgets/SunFinderStart.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key, required this.loaded, required this.queryResult});
  final bool loaded;
  final Map<String, dynamic> queryResult;

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Theme.of(context).colorScheme.inversePrimary,
          title: const Text('Sunchaser'),
        ),
        body: Column(children: <Widget>[
          SizedBox(
            height:MediaQuery.of(context).size.height / 2.2,
            child: FlutterMap(
              options: const MapOptions(
                minZoom: 8,
                maxZoom: 18,
                initialZoom: 14.5,
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
                MarkerLayer(
                  markers: [
                    for (var row in queryResult.keys)
                      Marker(
                          point: LatLng(queryResult[row]['lat'], queryResult[row]['long']),
                          child: const Icon(
                            Icons.location_on,
                            color:Colors.red,
                            )
                          )
                    ]
                  )
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
                  !loaded ? const SunFinder() : ParksList(queryResult: queryResult,),
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