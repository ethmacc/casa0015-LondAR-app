import 'package:flutter/material.dart';
import 'cloud_query.dart';
import 'home.dart';

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
          print(queryResult['park1_perc'].floor().toString());
          setState(() => isLoading = false);
          if (!context.mounted) return;
          Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => HomePage(loaded: true, queryResult: queryResult))
            );
        },
        style: TextButton.styleFrom(
          backgroundColor: Colors.orange,
          ), 
        child: const Text('Find nearest sun'),
      ),
    );
  }


}

