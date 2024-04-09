import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_map_location_marker/flutter_map_location_marker.dart';
import 'package:latlong2/latlong.dart';
import '../models/selected_mark.dart';
import 'package:provider/provider.dart';
import '../models/mark_list.dart';

class MarkupMap extends StatefulWidget{
  const MarkupMap({super.key, required this.loaded, required this.queryResult});
  final bool loaded;
  final Map<String, dynamic> queryResult;

  @override
  State<MarkupMap> createState() => _MarkupMapState();
}

class _MarkupMapState extends State<MarkupMap> with TickerProviderStateMixin {
  late MapController _mapController;

  @override
   void initState() {
     super.initState();
     _mapController = MapController();
   }

  //from animated_map_controller by JaffaKetchup
  void _animatedMapMove(LatLng destLocation, double destZoom) {
    // Create some tweens. These serve to split up the transition from one location to another.
    // In our case, we want to split the transition be<tween> our current map center and the destination.
    final latTween = Tween<double>(
        begin: _mapController.camera.center.latitude, end: destLocation.latitude);
    final lngTween = Tween<double>(
        begin: _mapController.camera.center.longitude, end: destLocation.longitude);
    final zoomTween = Tween<double>(begin: _mapController.camera.zoom, end: destZoom);

    // Create a animation controller that has a duration and a TickerProvider.
    final controller = AnimationController(
        duration: const Duration(milliseconds: 500), vsync: this);
    // The animation determines what path the animation will take. You can try different Curves values, although I found
    // fastOutSlowIn to be my favorite.
    final Animation<double> animation =
        CurvedAnimation(parent: controller, curve: Curves.fastOutSlowIn);

    controller.addListener(() {
      _mapController.move(
          LatLng(latTween.evaluate(animation), lngTween.evaluate(animation)),
          zoomTween.evaluate(animation));
    });

    animation.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        controller.dispose();
      } else if (status == AnimationStatus.dismissed) {
        controller.dispose();
      }
    });

    controller.forward();
  }

  @override
  Widget build(BuildContext context) {
    SelectedMark selectedMark = Provider.of<SelectedMark>(context);
    InputMarkList inputMarkList = Provider.of<InputMarkList>(context);
    late LatLng startPt;

    List<Marker> resultMarkers = [
      for (var row in widget.queryResult.keys)
        Marker(
            point: LatLng(widget.queryResult[row]['lat'], widget.queryResult[row]['long']),
            child: Icon(
              Icons.location_on,
              shadows: const <Shadow>[Shadow(color: Colors.grey, blurRadius: 15.0)],
              color:!(selectedMark.idx == int.parse(row)) ? Colors.amberAccent: Colors.amber[800],
              )
            )
    ];

    if (widget.loaded && inputMarkList.marks.isNotEmpty) {
      startPt =  inputMarkList.marks[0].point;
    } else {
      startPt = const LatLng(51.5, 0.127);
    }

    return FlutterMap(
              options: MapOptions(
                minZoom: 8,
                maxZoom: 18,
                initialZoom: 14.5,
                initialCenter: startPt,
                onTap: !widget.loaded ? (tapPos, latlng) {
                  setState(() {
                    inputMarkList.setAlign(AlignOnUpdate.never);
                    inputMarkList.clearMarkers();
                    inputMarkList.addMarker(
                      Marker( 
                        point: latlng,
                        child: const Icon(
                          Icons.location_on,
                          shadows: <Shadow>[Shadow(color: Colors.grey, blurRadius: 15.0)],
                          color: Colors.blue,
                          )
                        )
                      );
                    _animatedMapMove(latlng, 14.5);
                    //moveCenter(latlng);
                  });
                } : null,
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
                  alignPositionOnUpdate: !(widget.loaded && inputMarkList.marks.isNotEmpty) ? inputMarkList.aln: AlignOnUpdate.never,
                ),
                MarkerLayer(
                  markers: inputMarkList.marks + resultMarkers
                  )
              ],
            );
  }
}
