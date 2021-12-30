import 'package:flutter/material.dart';
import 'package:flutter_application_1/pages/habit_page.dart';
import 'package:flutter_application_1/pages/home_page.dart';
import 'package:flutter_application_1/pages/login_page.dart';
import 'package:flutter_application_1/pages/scatterplot_page.dart';
import 'package:flutter_application_1/pages/scorecard_page.dart';

class RouteManager {
  static const String loginPage = '/';
  static const String habitPage = '/habitPage';
  static const String homePage = '/homePage';
  static const String scatterPage = '/scatterPage';
  static const String scorecardPage = '/scorecardPage';

  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
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
      case scatterPage:
        return MaterialPageRoute(
          builder: (context) => ScatterplotPage(),
        );
      case scorecardPage:
        return MaterialPageRoute(
          builder: (context) => ScorecardPage(),
        );

      default:
        throw FormatException('Route not found! Check routes again!');
    }
  }
}
