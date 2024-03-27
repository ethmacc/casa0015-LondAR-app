import 'package:flutter/material.dart';

class ParksList extends StatelessWidget{
  const ParksList({super.key, required this.queryResult});
  final Map<String, dynamic> queryResult;

  @override
  Widget build(BuildContext context) {
    final String park1 = queryResult['park1'];
    final int park1_perc = queryResult['park1_perc'].floor();
    final String park2 = queryResult['park2'];
    final int park2_perc = queryResult['park2_perc'].floor();
    final String park3 = queryResult['park3'];
    final int park3_perc = queryResult['park3_perc'].floor();
  
    return ListView(
      padding: const EdgeInsets.all(8),
      children: <Widget>[
        Container(
          height: 50,
          color: Colors.white,
          child: const Center(child: Text('Top sunniest parks:')),
        ),
        Container(
          height: 50,
          color: Colors.amber[600],
          child: Center(child: Text('$park1 - $park1_perc% sunny')),
        ),
        Container(
          height: 50,
          color: Colors.amber[500],
          child: Center(child: Text('$park2 - $park2_perc% sunny')),
        ),
        Container(
          height: 50,
          color: Colors.amber[100],
          child: Center(child: Text('$park3 - $park3_perc% sunny')),
        ),]
    );
  }
}