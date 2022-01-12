import 'package:flutter/material.dart';
import 'package:flutter_application_1/pages/habit_page.dart';
import 'package:flutter_application_1/pages/home_page.dart';
import 'package:flutter_application_1/pages/landing_page.dart';
import 'package:flutter_application_1/pages/login_page.dart';

class RouteManager {
  static const String landingPage = '/';
  static const String loginPage = '/loginPage';
  static const String habitPage = '/habitPage';
  static const String homePage = '/homePage';
  static const String scorecardPage = '/scorecardPage';

  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case landingPage:
        return MaterialPageRoute(
          builder: (context) => LandingPage(),
        );
      case loginPage:
        return MaterialPageRoute(
          builder: (context) => LoginPage(),
        );
      case habitPage:
        return MaterialPageRoute(
          builder: (context) => HabitPage(),
        );
      case homePage:
        return MaterialPageRoute(
          builder: (context) => HomePage(),
        );

      default:
        throw const FormatException('Route not found! Check routes again!');
    }
  }
}
