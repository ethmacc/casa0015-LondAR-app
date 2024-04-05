import 'package:flutter/material.dart';
import 'package:flutter_map_location_marker/flutter_map_location_marker.dart';
import 'package:geolocator/geolocator.dart';
import 'package:provider/provider.dart';
import '../services/cloud_query.dart';
import '../screens/home.dart';
import '../screens/error.dart';
import '../models/mark_list.dart';

class SunFinder extends StatefulWidget {
  const SunFinder({super.key});

  @override
  State<SunFinder> createState() => _SunFinderState();
}

class _SunFinderState extends State<SunFinder> with AutomaticKeepAliveClientMixin {
  bool querySent = false;
  bool isLoading = false;
  late dynamic queryResult;
  TimeOfDay selectedTime = TimeOfDay.now();

  @override
  bool wantKeepAlive = true;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Container(
                    color:Colors.white,
                    height:  MediaQuery.of(context).size.height / 2.5,
                    child: !isLoading ? sunFinderButton() : const Center(child:CircularProgressIndicator())
                    );
  }

  Widget sunFinderButton() {
    InputMarkList inputMarkList = Provider.of<InputMarkList>(context, listen: false);

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          const Icon(
            Icons.location_on,
            color: Colors.blue,
          ),
          const Text('Tap the map to set a custom location'),
          ElevatedButton(
            onPressed: () {
              inputMarkList.clearMarkers();
              inputMarkList.setAlign(AlignOnUpdate.always);
            }, 
            child: const Text('Clear and use current location')
            ),
          const SizedBox(height: 30),
          Text('Selected time: ${selectedTime.hour.toString().padLeft(2, '0')}:${selectedTime.minute.toString().padLeft(2, '0')}', textAlign: TextAlign.center,), //timepicker from https://www.youtube.com/watch?v=dVKoi32znEk
          ElevatedButton(
            onPressed: () async {
              final TimeOfDay? timeOfDay = await showTimePicker(
                context: context, 
                initialTime: selectedTime,
                initialEntryMode: TimePickerEntryMode.input,
                );
                if (timeOfDay != null) {
                  setState(() {
                    selectedTime = timeOfDay;
                  });
                }
            }, 
            child: const Text('Choose another time')
          ),
          const SizedBox(height: 30),
          ElevatedButton(
            onPressed: () async {
              late dynamic position;
              setState(() => isLoading = true);
              if (inputMarkList.marks.isNotEmpty) {
                position = inputMarkList.marks[0].point;
              } else {
                position = await Geolocator.getCurrentPosition();
              }
              queryResult = await getParks(position, selectedTime);
              setState(() => isLoading = false);
              if (!context.mounted) return;
                if (queryResult is Map<String, dynamic>) {
                  if (queryResult['0'] == "No parks") {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const ErrorPage(errorMessage: 'Error, no parks found in the area. This may be due to our contributors not having the data yet',))
                    ); 
                  }
                  else if (queryResult['0'] == "After sunset") {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const ErrorPage(errorMessage: 'Specified time is after sunset!'))
                    );
                  } else {
                      Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => HomePage(loaded: true, queryResult : queryResult))
                    ); 
                  }
                }
                else {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const ErrorPage(errorMessage: 'Oops, an unexpected error occured!'))
                  ); 
                }
              },
              style: ElevatedButton.styleFrom(
              backgroundColor: Colors.amber[600],
              ), 
            child: const Text('Find me some sun!'),
          ),
        ]
      )
    );
  }
}

