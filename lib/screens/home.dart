import 'dart:async';
import 'package:flutter/material.dart';
import 'package:light/light.dart';
import 'package:provider/provider.dart';
import 'package:sunchaser2/models/weather_models.dart';
import '../widgets/markup_map.dart';
import '../widgets/parks_list.dart';
import '../widgets/sun_finder.dart';
import '../widgets/exposure_display.dart';
import '../models/exposure_log.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key, required this.loaded, required this.queryResult, required this.weatherResult});
  final bool loaded;
  final Map<String, dynamic> queryResult;
  final WeatherResponse weatherResult;
  
  @override
  State<HomePage> createState() => _homePageState();
}

class _homePageState extends State<HomePage> {
  int _luxInt = 0;
  Light? _light;
  StreamSubscription? _subscription;
  Timer? timer;
  late ExposureLog exposureLog;

  dynamic show30MinDialog() {
     if (exposureLog.mins == 5) {
        return showDialog(
          context: context, 
          builder: (context) {
            return AlertDialog(
              title: const Text('Daily Target Reached!'),
              content: const Text("Congratulations, you've spent 30mins in outdoor sunlight today!"),
              actions: [
                TextButton(onPressed: () {
                  Navigator.pop(context);
                }, child: const Text('OK'))
              ]
            );
          }
        );
      }
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
    } on LightException catch (exception) {
      print(exception);
    }
  }

  void stopListening() {
    _subscription?.cancel();
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
    startListening();
    exposureLog = Provider.of<ExposureLog>(context, listen:false);
    timer = Timer.periodic(const Duration(seconds: 5), (Timer t) => logReading(_luxInt));
  }

  @override
  void dispose() {
    stopListening();
    timer?.cancel();
    super.dispose();
  }
  
  @override
  Widget build(BuildContext context) {
      
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
            const PreferredSize(
              preferredSize: Size.fromHeight(50.0),
              child: TabBar(
                labelColor:Colors.black,
                tabs: [
                  Tab(
                    text: 'Sun Finder'
                  ),
                  Tab(
                    text: 'Sun Exposure',
                  )
                ],
                )
              ),
              Expanded(
                child: TabBarView(
                  children: [
                    !widget.loaded ? const SunFinder() : ParksList(queryResult: widget.queryResult, weatherResult: widget.weatherResult),
                    Container(
                      color: Colors.amber[600],
                      height:  MediaQuery.of(context).size.height / 2.5,
                      child: ExposureDisplay(luxInt: _luxInt),
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