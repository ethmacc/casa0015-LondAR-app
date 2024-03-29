import 'package:flutter/material.dart';
import '../services/cloud_query.dart';
import '../screens/home.dart';
import '../screens/error.dart';

class SunFinder extends StatefulWidget {
  const SunFinder({super.key});

  @override
  State<SunFinder> createState() => _SunFinderState();
}

class _SunFinderState extends State<SunFinder> {
  bool querySent = false;
  bool isLoading = false;
  late dynamic queryResult;

  @override
  Widget build(BuildContext context) {
    return Container(
                    color:Colors.white,
                    height:  MediaQuery.of(context).size.height / 2.5,
                    child: !isLoading ? sunFinderButton() : const Center(child:CircularProgressIndicator())
                    );
  }

  Widget sunFinderButton() {
    return Center(
      child: TextButton(
        onPressed: () async {
          setState(() => isLoading = true);
          queryResult = await getParks();
          print(queryResult);
          setState(() => isLoading = false);
          if (!context.mounted) return;
            if (queryResult is Map<String, dynamic> && queryResult['0'] != "No parks") {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => HomePage(loaded: true, queryResult : queryResult))
              ); 
            }
            else if (queryResult['0'] == "No parks") {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const ErrorPage(errorMessage: 'Error, no parks found in the area. This may be due to our contributors not having the data yet',))
              ); 
            }
            else {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const ErrorPage(errorMessage: 'Oops, an unexpected error occured!'))
              ); 
            }
          },
          style: TextButton.styleFrom(
          backgroundColor: Colors.amber[600],
          ), 
        child: const Text('Find me some sun!'),
      ),
    );
  }
}

