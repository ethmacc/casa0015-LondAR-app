import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_map_location_marker/flutter_map_location_marker.dart';
import 'package:latlong2/latlong.dart';
import '../models/IndexSetter.dart';
import 'package:provider/provider.dart';
import '../models/posSetter.dart';

class MarkupMap extends StatefulWidget{
  const MarkupMap({super.key, required this.loaded, required this.queryResult});
  final bool loaded;
  final Map<String, dynamic> queryResult;

  @override
  State<MarkupMap> createState() => _MarkupMapState();
}

class _MarkupMapState extends State<MarkupMap>{
  late MapController _mapController;

  @override
   void initState() {
     super.initState();
     _mapController = MapController();
   }

  void moveCenter(latlng) {
    _mapController.move(latlng, 14.5);
  }

  @override
  Widget build(BuildContext context) {
    IndexSetter _indexSetter = Provider.of<IndexSetter>(context);
    posSetter _posSetter = Provider.of<posSetter>(context);
    late LatLng startPt;

    List<Marker> resultMarkers = [
      for (var row in widget.queryResult.keys)
        Marker(
            point: LatLng(widget.queryResult[row]['lat'], widget.queryResult[row]['long']),
            child: Icon(
              Icons.location_on,
              color:!(_indexSetter.idx == int.parse(row)) ? Colors.amber[700] : Colors.red,
              )
            )
    ];

    if (widget.loaded && _posSetter.marks.isNotEmpty) {
      startPt =  _posSetter.marks[0].point;
    } else {
      startPt = LatLng(51.5, 0.127);
    }

    return FlutterMap(
              options: MapOptions(
                minZoom: 8,
                maxZoom: 18,
                initialZoom: 14.5,
                initialCenter: startPt,
                onTap: (tapPos, latlng) {
                  setState(() {
                    _posSetter.setAlign(AlignOnUpdate.never);
                    _posSetter.clearMarkers();
                    _posSetter.addMarker(
                      Marker( 
                        point: latlng,
                        child: const Icon(
                          Icons.location_on,
                          color: Colors.blue,
                          )
                        )
                      );
                    moveCenter(latlng);
                  });
                },
              ),
              mapController: _mapController,
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
                  alignPositionOnUpdate: !(widget.loaded && _posSetter.marks.isNotEmpty) ? _posSetter.aln: AlignOnUpdate.never,
                ),
                MarkerLayer(
                  markers: _posSetter.marks + resultMarkers
                  )
              ],
            );
  }
}
