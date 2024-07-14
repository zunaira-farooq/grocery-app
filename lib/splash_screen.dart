import 'package:flutter/material.dart';
import 'package:grocery_list/home_page.dart';
import 'package:grocery_list/onboarding_screen.dart';
import 'package:hive/hive.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {

  @override
  void initState() {
    super.initState();
    _navigateToNextScreen();
  }

  _navigateToNextScreen() async {
    await Future.delayed(const Duration(seconds: 8));
    var box = await Hive.openBox('userBox');
    bool isOnboarded = box.get('isOnboarded', defaultValue: false);

    if(isOnboarded) {
      //navigate to home page
      Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const HomePage()),
      );
    } else {
      //navigate to onboarding page
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context)=> const OnboardingScreen()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: Color(0xFF9B9BFF),
      body: Center(
        child: Text(
          'GorceryGo',
          style: TextStyle(
            fontSize: 70,
            fontWeight: FontWeight.bold,
            color: Color(0xFF151738),
          ),
        ),
      ),
    );
  }
}

