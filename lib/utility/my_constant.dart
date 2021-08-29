import 'package:flutter/material.dart';

class MyConstant {
  // General information
  static String appName = 'Forest Park';
  //static String domain = 'http://127.0.0.1:5500';
  // static String domain = 'http://192.168.1.107';
  //static String domain = 'http://192.168.43.88';
  //static String domain = 'https://7efab5487b92.ngrok.io';
  // New ngrok
  static String domain = 'https://8d82-2405-9800-b820-171c-64c3-3747-7cb-c586.ngrok.io';

  // Route screen
  static String routeAuthen = '/authen';
  static String routeCreateAccount = '/createAccount';
  static String routeOfficialAdmin = '/officialAdmin';
  static String routeForestPlanter = '/forestPlanter';
  static String routeAddPlant = '/addPlant';
  // static String routeDelPlant = '/delPlant';
  static String routeMyHomePage = '/myHomePage';

  // Images
  static String image1 = 'images/image1.png';
  static String image2 = 'images/image2.png';
  static String image3 = 'images/image3.png';
  static String image4 = 'images/image4.png';
  static String image5 = 'images/image5.png';
  static String image6 = 'images/image6.png';
  static String image7 = 'images/image7.png';
  static String image8 = 'images/image8.png';
  static String image9 = 'images/image9.png';

  // Color
  // Set #1
  // static Color primary = Color(0xff87861d); // For Background, Bar
  // static Color dark = Color(0xff575900); // For font color
  // static Color light = Color(0xffb9b64e); // For focus color

  // Set#2
  static Color primary = Color(0xff00c853); // For Background, Bar
  static Color dark = Color(0xff009624); // For font color
  static Color light = Color(0xff5efc82); // For focus color

  static Color redcolor1 = Color(0xffd50000); // For RedEye
  static Color blackcolor1 = Color(0xff140000); // For RedEye

  // Style

  // Big Font for header
  TextStyle h1Style() => TextStyle(
        fontSize: 24,
        color: dark,
        fontWeight: FontWeight.bold,
      );

  TextStyle h2Style() => TextStyle(
        fontSize: 18,
        color: dark,
        fontWeight: FontWeight.w700,
      );

  TextStyle h3Style() => TextStyle(
        fontSize: 14,
        color: dark,
        fontWeight: FontWeight.normal,
      );

  TextStyle h4Style() => TextStyle(
        fontSize: 14,
        color: Color.fromARGB(100, 255, 0, 0),
        fontWeight: FontWeight.w900,
      );

  // Button Style

  ButtonStyle myButtonStyle() => ElevatedButton.styleFrom(
        primary: MyConstant.primary,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30),
        ),
      );

  ButtonStyle myButtonStyleRed() => ElevatedButton.styleFrom(
        primary: MyConstant.redcolor1,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30),
        ),
      );
}
