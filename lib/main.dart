import 'package:flutter/material.dart';
import 'package:rtk_mobile/loader/loader.dart';
import 'package:rtk_mobile/screens/download_logs.dart';
import 'package:rtk_mobile/screens/home1.dart';
import 'package:rtk_mobile/screens/map.dart';
import 'package:rtk_mobile/screens/settings.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData.dark().copyWith(
        primaryColor: Color(0xFF0A0E21),
        scaffoldBackgroundColor: Color(0xFF0A0E21),
      ),
      //home: Map(),
      home: LoaderScreen(),
      routes: {
        '/0': (context) => Home(),
        '/1': (context) => Map(),
        '/2': (context) => Download(),
        '/3': (context) => Settings(),
      },
    );
  }
}
