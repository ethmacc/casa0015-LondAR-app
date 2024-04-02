import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_map_location_marker/flutter_map_location_marker.dart';
import 'package:latlong2/latlong.dart';

class MarkupMap extends StatefulWidget{
  const MarkupMap({super.key, required this.queryResult});
  final Map<String, dynamic> queryResult;

  @override
  State<MarkupMap> createState() => _MarkupMapState();
}

class _MarkupMapState extends State<MarkupMap>{
  final int selectedindex = 4;
  @override
  Widget build(BuildContext context) {
    return FlutterMap(
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
                    for (var row in widget.queryResult.keys)
                      Marker(
                          point: LatLng(widget.queryResult[row]['lat'], widget.queryResult[row]['long']),
                          child: Icon(
                            Icons.location_on,
                            color:!(selectedindex == int.parse(row)) ? Colors.amber[700] : Colors.red,
                            )
                          )
                    ]
                  )
              ],
            );
  }
}
