import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:latlong2/latlong.dart';
import 'package:provider/provider.dart';
import 'package:sunchaser2/models/mark_list.dart';
import 'package:sunchaser2/models/route.dart';
import 'package:sunchaser2/models/weather_models.dart';
import '../models/selected_mark.dart';
import 'package:osrm/osrm.dart';

class ParksList extends StatefulWidget{
  const ParksList({super.key, required this.queryResult, required this.weatherResult});
  final Map<String, dynamic> queryResult;
  final WeatherResponse weatherResult;

  @override
  State<ParksList> createState() => _ParksListState();
}

class _ParksListState extends State<ParksList> {
  late SelectedMark selectedMark;
  late RouteModel routeModel;
  final osrm = Osrm();

  @override
  void initState() {
    super.initState();
    selectedMark = Provider.of<SelectedMark>(context, listen:false);
    routeModel = Provider.of<RouteModel>(context, listen: false);
  }

  void updateIndex(int i) {
    selectedMark.setIndex(i);
  }

  void changeRoute(List<LatLng> route) {
    routeModel.setRoute(route);
  }

  @override
  Widget build(BuildContext context) { 
    SelectedMark selectedMark = Provider.of<SelectedMark>(context);
    InputMarkList inputMarkList = Provider.of<InputMarkList>(context);
    RouteModel routeModel = Provider.of<RouteModel>(context);
    double clearness = (100 - widget.weatherResult.clouds) / 100;

    return Column(
      children: <Widget>[
        Container(
          padding: const EdgeInsets.all(8), 
          child: const Text('Top sunniest parks:'),
          ),
        Expanded(
          child: ListView.builder(
            itemCount: widget.queryResult.length,
            padding: const EdgeInsets.all(8),
            itemBuilder: (context, i) {
              return ListTile(
                  onTap: () {
                    setState(() => updateIndex(i)); 
                    routeModel.clearPoints();
                  },
                  tileColor: !(selectedMark.idx == i) ? Colors.amberAccent : Colors.amber[600],
                  title: Text('${widget.queryResult[i.toString()]['name']} - ${(widget.queryResult[i.toString()]['perc'] * clearness).floor()}% sunny', textAlign: TextAlign.center),
                  trailing: (selectedMark.idx == i) ? TextButton(
                    onPressed: () async {
                      late dynamic inputPos;                      if (inputMarkList.marks.isNotEmpty) {
                        inputPos = inputMarkList.marks[0].point;
                      } else {
                        inputPos = await Geolocator.getCurrentPosition();
                      }
                      final RouteRequest options = RouteRequest(
                        coordinates: [
                          (inputPos.longitude, inputPos.latitude),
                          (widget.queryResult[i.toString()]['long'], widget.queryResult[i.toString()]['lat']),
                          ]);
                      final RouteResponse route = await osrm.route(options);
                      final List<LatLng> points = route.routes.first.geometry!.lineString!.coordinates.map((e) {
                        var location = e.toLocation();
                        return LatLng(location.lat, location.lng);
                      }).toList();
                      setState(() => changeRoute(points));
                      },
                    style: TextButton.styleFrom(backgroundColor: Colors.blue, foregroundColor: Colors.white),
                    child: const Text('Show route')
                    ) : null,
                );
            }
          )
        )
      ],
    );
  }
}