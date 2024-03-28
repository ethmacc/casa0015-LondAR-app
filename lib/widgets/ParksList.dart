import 'package:flutter/material.dart';

class ParksList extends StatelessWidget{
  const ParksList({super.key, required this.queryResult});
  final Map<String, dynamic> queryResult;

  @override
  Widget build(BuildContext context) {  
    return ListView(
      padding: const EdgeInsets.all(8),
      children: <Widget>[
        Container(
          height: 50,
          color: Colors.white,
          child: const Center(child: Text('Top sunniest parks:')),
        ),
        for (var row in queryResult.keys)
          Container(
              height: 50,
              color: Colors.amber[600],
              child: Center(child: Text('${queryResult[row]['name']} - ${queryResult[row]['perc'].floor()}% sunny')),
            )
      ]
    );
  }
}