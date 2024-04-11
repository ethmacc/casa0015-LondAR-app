import 'package:cloud_functions/cloud_functions.dart';
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
    // You can also use a `ReCaptchaEnterpriseProvider` provider instance as an
    // argument for `webProvider`
    webProvider: ReCaptchaV3Provider('recaptcha-v3-site-key'),
    // Default provider for Android is the Play Integrity provider. You can use the "AndroidProvider" enum to choose
    // your preferred provider. Choose from:
    // 1. Debug provider
    // 2. Safety Net provider
    // 3. Play Integrity provider
    androidProvider: AndroidProvider.debug,
    // Default provider for iOS/macOS is the Device Check provider. You can use the "AppleProvider" enum to choose
        // your preferred provider. Choose from:
        // 1. Debug provider
        // 2. Device Check provider
        // 3. App Attest provider
        // 4. App Attest provider with fallback to Device Check provider (App Attest provider is only available on iOS 14.0+, macOS 14.0+)
    appleProvider: AppleProvider.appAttest,
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
