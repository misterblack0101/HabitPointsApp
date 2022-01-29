/* scorecard class:
 fields: habit Name, total days, total pts., continuous streak
 toJSON and fromJSON methods
 */

import 'package:flutter_application_1/constants.dart';

class Scorecard {
  String habitName;
  String comment;
  int barStrength, totalDays, pointsToday, totalPoints, streak, longestStreak;

  Scorecard(
      {required this.habitName,
      this.barStrength = 0,
      this.totalDays = 0,
      this.pointsToday = 0,
      this.totalPoints = 0,
      this.streak = 0,
      this.longestStreak = 0,
      this.comment = ""});

  Map<String, dynamic> toJSON() => {
        habitName: {
          Constants.pointsToday: pointsToday,
          Constants.totalPoints: totalPoints,
          Constants.totalDays: totalDays,
          Constants.streak: streak,
          Constants.longstreak: longestStreak,
          Constants.barStrength: barStrength,
          Constants.comment: comment
        }
      };

  static Scorecard fromJSON(Map<dynamic, dynamic> m, String habitname) =>
      Scorecard(
          habitName: habitname,
          pointsToday: m[Constants.pointsToday],
          totalPoints: m[Constants.totalPoints],
          totalDays: m[Constants.totalDays],
          streak: m[Constants.streak],
          longestStreak: m[Constants.longstreak],
          barStrength: m[Constants.barStrength],
          comment: m[Constants.comment]);
}
