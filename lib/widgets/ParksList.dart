import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/IndexSetter.dart';

class ParksList extends StatefulWidget{
  const ParksList({super.key, required this.queryResult});
  final Map<String, dynamic> queryResult;

  @override
  State<ParksList> createState() => _ParksListState();
}

class _ParksListState extends State<ParksList> {
  late IndexSetter _indexSetter;

  @override
  void initState() {
    super.initState();
    _indexSetter = Provider.of<IndexSetter>(context, listen:false);
  }

  void updateIndex(int i) {
    _indexSetter.setIndex(i);
  }

  @override
  Widget build(BuildContext context) { 
    IndexSetter _indexSetter = Provider.of<IndexSetter>(context);
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
                  tileColor: !(_indexSetter.idx == i) ? Colors.amber[600] : Colors.red,
                  title: Text('${widget.queryResult[i.toString()]['name']} - ${widget.queryResult[i.toString()]['perc'].floor()}% sunny', textAlign: TextAlign.center)
                );
            }
          )
        )
      ],
    );
  }
}