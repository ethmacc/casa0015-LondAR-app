import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
//import 'package:latlong2/latlong.dart';
import 'package:flutter_map_location_marker/flutter_map_location_marker.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'SunChaser Prototype',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // TRY THIS: Try running your application with "flutter run". You'll see
        // the application has a purple toolbar. Then, without quitting the app,
        // try changing the seedColor in the colorScheme below to Colors.green
        // and then invoke "hot reload" (save your changes or press the "hot
        // reload" button in a Flutter-supported IDE, or press "r" if you used
        // the command line to start the app).
        //
        // Notice that the counter didn't reset back to zero; the application
        // state is not lost during the reload. To reset the state, use hot
        // restart instead.
        //
        // This works for code too, not just values: Most code changes can be
        // tested with just a hot reload.
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.orange),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'SunChaser'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Theme.of(context).colorScheme.inversePrimary,
          title: Text(widget.title),
        ),
        body: Column(children: <Widget>[
          Container(
            height:MediaQuery.of(context).size.height / 2.2,
            child: FlutterMap(
              options: MapOptions(
                minZoom: 8,
                maxZoom: 18,
                initialZoom: 13,
              ),
              children: [
                TileLayer(
                  urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                ),
                RichAttributionWidget(
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
          PreferredSize(
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
                        child: Text('Find nearest sun'),
                        style: TextButton.styleFrom(
                          backgroundColor: Colors.orange,
                          ),
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
