import 'package:flutter/material.dart';
import '../widgets/MarkupMap.dart';
import '../widgets/ParksList.dart';
import '../widgets/SunFinder.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key, required this.loaded, required this.queryResult});
  final bool loaded;
  final Map<String, dynamic> queryResult;

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
        length: 2,
        child: Scaffold(
          appBar: AppBar(
            backgroundColor: Theme.of(context).colorScheme.inversePrimary,
            title: const Text('Sunchaser'),
          ),
          body: Column(children: <Widget>[
            SizedBox(
              height:MediaQuery.of(context).size.height / 2.2,
              child: MarkupMap(loaded: loaded, queryResult: queryResult,)
            ),
            const PreferredSize(
              preferredSize: Size.fromHeight(50.0),
              child: TabBar(
                labelColor:Colors.black,
                tabs: [
                  Tab(
                    text: 'Sun Finder'
                  ),
                  Tab(
                    text: 'Heliodon',
                  )
                ],
                )
              ),
              Expanded(
                child: TabBarView(
                  children: [
                    !loaded ? const SunFinder() : ParksList(queryResult: queryResult,),
                    Container(
                      color: Colors.blue,
                      height:  MediaQuery.of(context).size.height / 2.5,
                      )
                  ],
                  )
                )
          ]
        )
        )
      );
  }
}