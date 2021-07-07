import 'package:flutter/material.dart';
import 'package:chart_app/screens/splashscreen.dart';

void main() => runApp(MyApp());

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