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

  static User? user;
  static late String userId;

  static final Color drawerColor = Colors.cyan.shade900;
}
