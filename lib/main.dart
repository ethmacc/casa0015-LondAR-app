import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:provider/provider.dart';
import 'package:sunchaser2/models/exposure_log.dart';
import 'package:sunchaser2/models/route.dart';
import 'package:sunchaser2/models/selected_mark.dart';
import 'package:sunchaser2/models/mark_list.dart';
import 'package:sunchaser2/models/weather_models.dart';
import 'firebase_options.dart';
import 'screens/home.dart';
import 'package:firebase_app_check/firebase_app_check.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(  
    options: DefaultFirebaseOptions.currentPlatform,
  );
  await FirebaseAppCheck.instance.activate(
    androidProvider: AndroidProvider.debug,
  );
  await dotenv.load(fileName: "assets/.env");
  runApp(
    MultiProvider(
      providers:[
        ChangeNotifierProvider(create: (context) => SelectedMark()),
        ChangeNotifierProvider(create: (context) => InputMarkList()),
        ChangeNotifierProvider(create: (context) => ExposureLog()),
        ChangeNotifierProvider(create: (context) => RouteModel())
      ],
      child: const MyApp())
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'SunChaser',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: const Color.fromARGB(255, 255, 179, 0)),
        useMaterial3: true,
      ),
      home: const HomePage(loaded: false, queryResult: <String, dynamic>{}, weatherResult: WeatherResponse(clouds: 0)),
    );
  }
}
