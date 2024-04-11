import 'dart:async';
import 'package:flutter/material.dart';
import 'package:light/light.dart';
import 'package:provider/provider.dart';
import 'package:sunchaser2/models/selected_mark.dart';
import 'package:sunchaser2/models/weather_models.dart';
import 'package:sunchaser2/screens/error.dart';
import 'package:sunchaser2/widgets/markup_map.dart';
import 'package:sunchaser2/widgets/parks_list.dart';
import 'package:sunchaser2/widgets/sun_finder.dart';
import 'package:sunchaser2/widgets/exposure_display.dart';
import 'package:sunchaser2/models/exposure_log.dart';
import 'package:geolocator/geolocator.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key, required this.loaded, required this.queryResult, required this.weatherResult});
  final bool loaded;
  final Map<String, dynamic> queryResult;
  final WeatherResponse weatherResult;
  
  @override
  State<HomePage> createState() => _homePageState();
}

class _homePageState extends State<HomePage> with SingleTickerProviderStateMixin {
  late SelectedMark selectedMark;
  int _luxInt = 0;
  Light? _light;
  StreamSubscription? _subscription;
  StreamSubscription? positionStream;
  Timer? timer;
  late ExposureLog exposureLog;
  final LocationSettings locationSettings = const LocationSettings(
    accuracy: LocationAccuracy.high,
    distanceFilter: 100,
  );
  late TabController _tabController;

  dynamic show30MinDialog() {
     if (exposureLog.mins == 5) {
        return showDialog(
          context: context, 
          builder: (context) {
            return AlertDialog(
              title: const Text('Daily Target Reached!'),
              content: const Text("Congratulations, you've spent 5mins in outdoor sunlight today!"),
              actions: [
                TextButton(onPressed: () {
                  Navigator.pop(context);
                }, 
                child: const Text('OK'))
              ]
            );
          }
        );
      }
  }

  dynamic notifyArrival() {
    return showDialog(
      context: context, 
      builder: (context) {
        return  AlertDialog(
          title:  const Text('Destination Reached'),
          content: const Text("You've arrived at your selected park, please switch tabs to start logging your sun intake"),
          actions: [
                TextButton(onPressed: () {
                  Navigator.pop(context);
                  _tabController.animateTo(1);
                }, 
                child: const Text('OK'))
              ]
        );
      }
      );
  }

  void onData(int luxValue) async {
    setState(() {
      _luxInt = luxValue;
    });
  }

  void startListening() {
    _light = Light();
    try {
      _subscription = _light?.lightSensorStream.listen(onData);
    } on LightException {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const ErrorPage(errorMessage: 'Error, light sensor missing or not reachable'))
      ); 
    }
  }

  void startGeoListening(){
    if (widget.loaded) {
      positionStream = Geolocator.getPositionStream(locationSettings: locationSettings).listen(
      (Position? position) {
        if (position != null) {
          if (Geolocator.distanceBetween(
            position.latitude, position.longitude, 
            widget.queryResult[selectedMark.idx.toString()]['lat'], widget.queryResult[selectedMark.idx.toString()]['long']) < 100) {
              positionStream?.cancel();
              selectedMark.clearChange();
              notifyArrival();
          }
        }
      });
    }
  }

  void stopListening() {
    _subscription?.cancel();
  }

  void stopGeoListening() {
    positionStream?.cancel();
  }

  void logReading(int reading) {
    if (reading > 10000) {
      exposureLog.increment();
      show30MinDialog();
    }
  }

  @override
  void initState() {
    super.initState();
    selectedMark = Provider.of<SelectedMark>(context, listen:false);
    exposureLog = Provider.of<ExposureLog>(context, listen:false);
    if (widget.loaded) {
      startListening();
    }
    startGeoListening();
    timer = Timer.periodic(const Duration(seconds: 10), (Timer t) => logReading(_luxInt));
    _tabController = TabController(vsync: this, length: 2);
  }

  @override
  void dispose() {
    _tabController.dispose;
    stopListening();
    stopGeoListening();
    timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
      selectedMark = Provider.of<SelectedMark>(context, listen:true);
      if (selectedMark.isChanged) {
        stopGeoListening();
        startGeoListening();
      }
      return DefaultTabController(
        length: 2,
        child: Scaffold(
          appBar: AppBar(
            backgroundColor: Theme.of(context).colorScheme.inversePrimary,
            title: const Text('SunChaser', style: TextStyle(fontWeight: FontWeight.bold),),
          ),
          body: Column(children: <Widget>[
            SizedBox(
              height:MediaQuery.of(context).size.height / 2.2,
              child: MarkupMap(loaded: widget.loaded, queryResult: widget.queryResult,)
            ),
             PreferredSize(
              preferredSize: const Size.fromHeight(50.0),
              child: TabBar(
                controller: _tabController,
                labelColor:Colors.black,
                tabs: const [
                  Tab(
                    text: 'Sun Finder'
                  ),
                  Tab(
                    text: 'Sun Intake',
                  )
                ],
                )
              ),
              Expanded(
                child: TabBarView(
                  controller: _tabController,
                  children: [
                    !widget.loaded ? const SunFinder() : ParksList(queryResult: widget.queryResult, weatherResult: widget.weatherResult),
                    Container(
                      color: Colors.amber[600],
                      height:  MediaQuery.of(context).size.height / 2.5,
                      child: ExposureDisplay(luxInt: _luxInt, loaded:widget.loaded),
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