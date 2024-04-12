import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sunchaser2/models/exposure_log.dart';

class ExposureDisplay extends StatelessWidget {
  const ExposureDisplay({super.key, required this.luxInt, required this.loaded});
  final int luxInt;
  final bool loaded;

  @override
  Widget build(BuildContext context) {
    ExposureLog exposureLog = Provider.of<ExposureLog>(context);
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text('Your outdoor sun exposure today (mins): '),
          const SizedBox(height: 10),
          Text('${exposureLog.mins}', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 60)),
          const SizedBox(height: 30),
          const Text('Current light level (lux): '),
          const SizedBox(height: 10),
          loaded ? Text('$luxInt', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 60)) : 
          const Text('Logging starts when sun finder is activated', style: TextStyle(fontWeight: FontWeight.bold)),
        ],
        )
    );
  }
}