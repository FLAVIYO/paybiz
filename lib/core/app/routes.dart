
import 'package:flutter/material.dart';
import 'package:paybiz/ui/shared/splash_screen.dart';
import 'package:paybiz/ui/views/auth/login/login.dart';
import 'package:paybiz/ui/views/auth/signup/sign_up_form.dart';
import 'package:paybiz/ui/views/auth/unauthenticated.dart';
import 'package:paybiz/ui/views/home/home.dart';
import 'package:paybiz/ui/views/onboarding/OnboardingPage1.dart';
import 'package:paybiz/ui/views/onboarding/OnboardingPage2.dart';
import 'package:paybiz/ui/views/profile/profile.dart';
import 'package:paybiz/ui/views/transfer/transfer.dart';

class Routes {
  static const String home = '/';
  static const String login = '/login';
  static const String signUp = '/signUp';
  static const String transfer = '/transfer';
  static const String splash = '/splash';
  static const String unAuthenticated = '/unAuthenticated';
  static const String profile = '/profile';
  static const String onboarding1 = '/onboarding1';
  static const String onboarding2 = '/onboarding2';
}

class RouteGenerator {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case Routes.splash:
        return MaterialPageRoute(builder: (_) => const SplashScreen());
      case Routes.unAuthenticated:
        return MaterialPageRoute(builder: (_) => const UnAuthenticatedScreen());
      case Routes.home:
        return MaterialPageRoute(builder: (_) => HomeScreen());
      case Routes.login:
        return MaterialPageRoute(builder: (_) => const Login());
      case Routes.signUp:
        return MaterialPageRoute(builder: (_) => const Signup());
      case Routes.transfer:
        return MaterialPageRoute(builder: (_) => const TransferScreen());
      case Routes.profile: 
        return MaterialPageRoute(builder: (_) => const ProfilePage());
      case Routes.onboarding1:
        return MaterialPageRoute(builder: (_) => const OnboardingPage1());
      case Routes.onboarding2:
        return MaterialPageRoute(builder: (_) => const OnboardingPage2());
      default:
        return MaterialPageRoute(
          builder: (_) => Scaffold(
            body: Center(
              child: Text('No route defined for ${settings.name}'),
            ),
          ),
        );
    }
  }
}
