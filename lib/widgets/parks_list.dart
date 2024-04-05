import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/selected_mark.dart';

class ParksList extends StatefulWidget{
  const ParksList({super.key, required this.queryResult});
  final Map<String, dynamic> queryResult;

  @override
  State<ParksList> createState() => _ParksListState();
}

class _ParksListState extends State<ParksList> {
  late SelectedMark selectedMark;

  @override
  void initState() {
    super.initState();
    selectedMark = Provider.of<SelectedMark>(context, listen:false);
  }

  void updateIndex(int i) {
    selectedMark.setIndex(i);
  }

  @override
  Widget build(BuildContext context) { 
    SelectedMark selectedMark = Provider.of<SelectedMark>(context);
    return Column(
      children: <Widget>[
        Container(
          padding: const EdgeInsets.all(8), 
          child: const Text('Top sunniest parks:'),
          ),
        Expanded(
          child: ListView.builder(
            itemCount: widget.queryResult.length,
            padding: const EdgeInsets.all(8),
            itemBuilder: (context, i) {
              return ListTile(
                  onTap: () {
                    setState(() => updateIndex(i)); 
                  },
                  tileColor: !(selectedMark.idx == i) ? Colors.amber[600] : Colors.lightGreen,
                  title: Text('${widget.queryResult[i.toString()]['name']} - ${widget.queryResult[i.toString()]['perc'].floor()}% sunny', textAlign: TextAlign.center)
                );
            }
          )
        )
      ],
    );
  }
}