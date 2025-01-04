import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:paybiz/core/app/routes.dart';
import 'package:paybiz/ui/theme/colors.dart';
import 'package:shared_preferences/shared_preferences.dart';

class OnboardingPage2 extends StatelessWidget {
  const OnboardingPage2({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset('assets/images/onboard2.PNG', height: 450.h),
            const SizedBox(height: 20),
            const Text(
              'Make Fast and Secure Transfers',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 10),
            const Text(
              'Transfer money to anyone in seconds with complete security.',
              style: TextStyle(fontSize: 16),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 30),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xff0D6EFD),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
                minimumSize: const Size(double.infinity, 60),
                elevation: 0,
              ),
              onPressed: () async {
                // Mark onboarding as completed
                final prefs = await SharedPreferences.getInstance();
                await prefs.setBool('isFirstTime', false);

                // Navigate to the next screen
                Navigator.pushReplacementNamed(context, Routes.unAuthenticated);
              },
              child: const Text(
                'Get Started',
                style: TextStyle(color: AppColors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
