import 'package:flutter/material.dart';
import 'package:chart_app/screens/splashscreen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';
import 'package:chart_app/services/Authservices.dart';

void main() async {



  // This needs to be called before any Firebase services can be used
  WidgetsFlutterBinding.ensureInitialized();
  FirebaseApp app =
  await Firebase.initializeApp().catchError((error) => print(error));

  runApp(
    ChangeNotifierProvider<AuthService>(
      create: (context) => AuthService(),
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      color: Colors.amberAccent.shade400,
      debugShowCheckedModeBanner: false,
      home: Splash(),
    );
  }
}