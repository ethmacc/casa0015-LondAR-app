import 'package:flutter/material.dart';

class ParksList extends StatefulWidget{
  const ParksList({super.key, required this.queryResult});
  final Map<String, dynamic> queryResult;

  @override
  State<ParksList> createState() => _ParksListState();
}

class _ParksListState extends State<ParksList> {
  int selectedindex = 0;
  @override
  Widget build(BuildContext context) { 
    return ListView.builder(
      itemCount: widget.queryResult.length,
      padding: const EdgeInsets.all(8),
      itemBuilder: (context, i) {
        return ListTile(
            onTap: () {
              setState(() => selectedindex = i); 
            },
            tileColor: !(selectedindex == i) ? Colors.amber[600] : Colors.red,
            title: Text('${widget.queryResult[i.toString()]['name']} - ${widget.queryResult[i.toString()]['perc'].floor()}% sunny', textAlign: TextAlign.center)
          );
      }
    );
  }
}