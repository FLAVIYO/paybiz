import 'package:flutter/material.dart';
import 'package:paybiz/core/app/routes.dart';
import 'package:paybiz/ui/theme/colors.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _checkOnboardingStatus();
  }

 Future<void> _checkOnboardingStatus() async {
  final prefs = await SharedPreferences.getInstance();

  // Check if the user has completed onboarding
  final isFirstTime = prefs.getBool('isFirstTime') ?? true;
  print('SplashScreen: isFirstTime = $isFirstTime');

  // Navigate based on onboarding status
  Future.delayed(const Duration(seconds: 3), () {
    if (isFirstTime) {
      Navigator.pushReplacementNamed(context, Routes.onboarding1);
    } else {
      Navigator.pushReplacementNamed(context, Routes.unAuthenticated);
    }
  });
}


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.black, 
      body: Center(
        child: Image.asset(
          'assets/images/icon.png',
          width: 800, // Increased size
          height: 800, // Increased size
        ),
      ),
    );
  }
}
