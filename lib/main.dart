import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_firebase_task/pages/top_page.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  if (kIsWeb) {
    await dotenv.load(fileName: ".env.development");
    await Firebase.initializeApp(
        options: FirebaseOptions(
      apiKey: dotenv.get("APIKEY"),
      authDomain: dotenv.get("AUTH_DOMAIN"),
      projectId: dotenv.get("PROJECT_ID"),
      storageBucket: dotenv.get("STORAGE_BUCKET"),
      messagingSenderId: dotenv.get("APP_ID"),
      appId: dotenv.get("APIKEY"),
      measurementId: dotenv.get("MEASUREMENT_ID"),
    ));
  } else {
    await Firebase.initializeApp();
  }
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const TopPage(title: 'Flutter Demo Home Page'),
    );
  }
}
