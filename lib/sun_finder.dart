import 'package:flutter/material.dart';
import 'cloud_query.dart';

class SunFinder extends StatefulWidget {
  const SunFinder({super.key});

  @override
  State<SunFinder> createState() => _SunFinderState();
}

class _SunFinderState extends State<SunFinder> {
  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Container(
                    color:Colors.white,
                    height:  MediaQuery.of(context).size.height / 2.5,
                    child: Center(
                      child: !isLoading ? TextButton(
                        onPressed: () async {
                          setState(() => isLoading = true);
                          final queryResult = await getParks();
                          print(queryResult);
                          setState(() => isLoading = false);
                        },
                        style: TextButton.styleFrom(
                          backgroundColor: Colors.orange,
                          ), 
                        child: const Text('Find nearest sun'),
                        ) 
                        : const Center(child:CircularProgressIndicator())
                      ),
                    );
  }
}
