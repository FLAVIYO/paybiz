import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:paybiz/core/app/routes.dart';
import 'package:paybiz/ui/theme/colors.dart';
import 'package:paybiz/ui/theme/theme_data.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class UnauthenticatedView extends StatelessWidget {
  const UnauthenticatedView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.lightBackground,
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 40.h),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Logo
              Center(
                child: Column(
                  children: [
                    Image.asset(
                      'assets/images/unauthview.PNG',
                      height: 350.h,
                    ),
                  ],
                ),
              ),
             Spacer(),
              Column(
                children: [
                  // Login Button
                  ElevatedButton(
                    onPressed: () {
                      Navigator.pushNamed(context, Routes.login);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primaryColor,
                      padding: EdgeInsets.symmetric(vertical: 15.h),
                      minimumSize: const Size(double.infinity, 40),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8.r),
                      ),
                    ),
                    child: Text(
                      'Log In',
                      style: context.textTheme.labelLarge?.copyWith(
                        color: AppColors.white,
                      ),
                    ),
                  ),
                  SizedBox(height: 15.h),

                  // Sign Up Button
                  OutlinedButton(
                    onPressed: () {
                      Navigator.pushNamed(context, Routes.signUp);
                    },
                    style: OutlinedButton.styleFrom(
                      side: BorderSide(color: AppColors.primaryColor),
                      padding: EdgeInsets.symmetric(vertical: 15.h),
                      minimumSize: const Size(double.infinity, 40),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8.r),
                      ),
                    ),
                    child: Text(
                      'Sign Up',
                      style: context.textTheme.labelLarge?.copyWith(
                        color: AppColors.primaryColor,
                      ),
                    ),
                  ),
                  SizedBox(height: 30.h),

                  // Explore Without Login
                 Text.rich(
                TextSpan(
                  text: 'By continuing you agree to PayBiz\'s ',
                  children: [
                    TextSpan(
                      text: 'Terms of Service',
                      recognizer: TapGestureRecognizer()
                        ..onTap = () {
                          // Open Terms of Service
                        },
                    ),
                    const TextSpan(
                      text: ' and ',
                    ),
                    TextSpan(
                      text: 'Privacy Policy',
                      style: const TextStyle(
                        color: AppColors.lightBlue
                      ),
                      recognizer: TapGestureRecognizer()
                        ..onTap = () {
                         print("Need a policy page");
                        },
                    ),
                    const TextSpan(text: '.'),
                  ],
                ),
                textAlign: TextAlign.center,
              ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
