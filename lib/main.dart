import 'package:cloud_functions/cloud_functions.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';
import 'package:sunchaser2/models/IndexSetter.dart';
import 'package:sunchaser2/models/posSetter.dart';
import 'firebase_options.dart';
import 'screens/home.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  FirebaseFunctions.instance.useFunctionsEmulator('localhost', 5001);
  runApp(
    MultiProvider(
      providers:[
        ChangeNotifierProvider(create: (context) => IndexSetter()),
        ChangeNotifierProvider(create: (context) => posSetter())
      ],
      child: MyApp())
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'SunChaser Prototype',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: const Color.fromARGB(255, 255, 179, 0)),
        useMaterial3: true,
      ),
      home: const HomePage(loaded: false, queryResult: <String, dynamic>{},),
    );
  }
}
