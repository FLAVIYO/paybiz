import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:paybiz/core/app/routes.dart';
import 'package:paybiz/ui/theme/colors.dart';

class UnAuthenticatedScreen extends StatelessWidget {
  const UnAuthenticatedScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset('assets/images/unauthview.PNG', height: 450.h),
            const SizedBox(height: 20),
            ElevatedButton.icon(
              onPressed: () {
                Navigator.pushReplacementNamed(context, Routes.login);
              },
              // icon: Icon(Icons.email_outlined, size: 20.h),
              label: const Text('Continue with LogIn'),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xff0D6EFD),
                foregroundColor: AppColors.white,
                side: const BorderSide(color: AppColors.blue),
                padding: EdgeInsets.symmetric(vertical: 12.h, horizontal: 14.w),
              ),
            ),
            Spacer(),
            Text(
              'Simplify your finances',
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                    fontSize: 20.sp,
                    color: Colors.black, // Set text color to white
                  ),
            ),
            Text(
              'With just one tap at a time',
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme!.bodyLarge?.copyWith(
                    fontWeight: FontWeight.w700,
                    fontSize: 20.sp,
                    color: Colors.black, // Set text color to white
                  ),
            ),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "Are you a New User? ",
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                        color: Colors.black, // Set text color to white
                      ),
                ),
                InkWell(
                  onTap: () {
                    Navigator.pushReplacementNamed(context, Routes.signUp);
                  },
                  child: Text(
                    "Sign up",
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                          fontWeight: FontWeight.w700,
                          color: AppColors.primaryColor,
                        ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
