import 'package:flutter/material.dart';

class ParksList extends StatefulWidget{
  const ParksList({super.key, required this.queryResult});
  final Map<String, dynamic> queryResult;

  @override
  State<ParksList> createState() => _ParksListState();
}

class _ParksListState extends State<ParksList> {
  bool selected = false;

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
        for (var row in widget.queryResult.keys)
          InkWell(
            onTap: () {
              setState(() => selected = true);
            },
              child: Ink(
                height: 50,
                color: !selected ? Colors.amber[600] : Colors.red, 
                child: Text('${widget.queryResult[row]['name']} - ${widget.queryResult[row]['perc'].floor()}% sunny', textAlign: TextAlign.center)
            )
          )
      ]
    );
  }
}