import 'package:flutter/material.dart';

class AppColors {

  static const List<Color> primaryGradientColors = [
    primaryColor,
    secondaryColor,
  ];

  static const List<Color> successGradientColors = [
    green,
    blue,
  ];

  static const LinearGradient primaryGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: primaryGradientColors,
  );

  static const LinearGradient successGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: successGradientColors,
  );

  const AppColors._();

  static const Color white = Color(0xFFFFFFFF);
  static const purple = Color(0xFF6941C6);

  static const Color primaryColor = Color(0xff6067FA);

  static const Color secondaryColor = Color(0xff7730F1);

  static const Color dimGrey = Color(0xFF585757);

  static const Color unselectedColorLight = Color(0xFF8E9497);
  static const Color unselectedColorDark = Color(0xFF768992);

  static const Color blue = Color(0xff00BCFF);
  static const Color darkBlue = Color(0xff007AFF);

  static const Color lightBlue = Color(0xff8CE1FF);

  static const Color lightGreen = Color(0xFFDFFEBF);
  static const Color black = Color(0xFF000000);
  static const Color grey =  Color(0xffEEEEEE);
  static const Color lightGrey = Color(0xFFF8F7F7);

  static const Color cardDark = Color(0xFF1F2326);
  static const Color cardDark2 = Color(0xFF16191B);

  static const Color iconDark = Color(0xffEFF0F5);
  static const Color iconLight = Color(0xFF535353);

  static const Color cardLight = Color(0xFFF6F7F8);
  static const Color cardLight2 = Color(0xffEFF0F5);

  static const Color dividerDark = Color(0xFF3A454E);
  static const Color dividerLight = Color(0xFFB7B7B7);

  static const Color lightBackground = Color(0xFFFFFFFF);
  static const Color darkBackground = Color(0xFF1B1E21);

  //social media colors
  static const Color facebook = Color(0xff39579B);
  static const Color whatsapp = Color(0xff42B244);
  static const Color twitter = Color(0xff00A7F7);
  static const Color linkedIn = Color(0xff0077B7);
  static const Color telegram = Color(0xff039BE5);


  static const offBlack = Color(0xff444444);
  static const green = Color(0xffE2EDE1);
  static const lightPurple = Color(0xffECE3FA);
  static const darkPurple = Color(0xff7730F1);
  static const pink = Color(0xffFAF5F5);
  static const pink2 = Color(0xffF5F0FA);
  static const darkPink = Color(0xffE8CBD9);
  static const grey2 = Color(0xffE5E5E5);
  static const grey3 = Color(0xff878787);
  static const grey4 = Color(0xffA9A9A9);
  static const grey5 = Color(0xff333333);
  static const darkGrey = Color(0xff656565);
  static const orange = Color(0xffEED1CA);
  static const red = Color(0xffEB5757);
  static const lightBlue2 = Color(0xffE6F9FF);
  static const yellow = Color(0xffF8DB73);
  static const lightyellow = Color(0xffFFF4D1);
  static const borderForActivityContainerColor = Color(0xffE3D6EF);
}
