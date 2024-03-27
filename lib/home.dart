import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_map_location_marker/flutter_map_location_marker.dart';
import 'package:sunchaser2/parksList.dart';
import 'SunFinderStart.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key, required this.loaded, required this.queryResult});
  final bool loaded;
  final Map<String, dynamic> queryResult;

  @override @override
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