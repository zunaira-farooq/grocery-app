import 'package:flutter/material.dart';
import 'package:grocery_list/onboarding_screen.dart';
import 'package:grocery_list/splash_screen.dart';
import 'package:hive_flutter/adapters.dart';


void main() async {
  //initialize hive
  await Hive.initFlutter();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: 'GorceryGo',
      debugShowCheckedModeBanner: false,
      home: SplashScreen(),
    );
  }
}