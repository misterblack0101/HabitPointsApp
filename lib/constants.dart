import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class Constants {
  static const String scoreCard = "scorecard";
  static const String habitName = "habitName";
  static const String totalDays = "totalActiveDays";
  static const String pointsToday = "pointsToday";
  static const String totalPointsToday = "totalPointsToday";
  static const String totalPointsOverall = "totalPointsOverall";
  static const String totalPoints = "totalPoints";
  static const String streak = "streak";
  static const String longstreak = "longestStreak";
  static const String barStrength = "barStrength";
  static const String lastSyncDate = "lastSyncDate";
  static const String comment = "comments";
  static const String defaultComment =
      "Comments: \nEx:\n 10 Pushups = 1 point,\n 10 mins of work= 1 point";

  static User? user;
  static late String userId;

  static final Color drawerColor = Colors.teal.shade800;
  static final Color barColor = Colors.teal.shade500;
  static final Color homeScreenColor = Colors.teal.shade600;
  static final Color buttonColor = Colors.teal.shade400;

  // static final Color drawerColor = Colors.blueGrey;
}
