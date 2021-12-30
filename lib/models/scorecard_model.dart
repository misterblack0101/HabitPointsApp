/* scorecard class:
 fields: habit Name, total days, total pts., continuous streak
 toJSON and fromJSON methods
 */

import 'package:flutter_application_1/constants.dart';

class ScorecardModel {
  final String habitName;
  final int totalDays;
  final int pts;
  final int streak;

  ScorecardModel({
    required this.habitName,
    required this.totalDays,
    required this.pts,
    this.streak = 0,
  });

  Map<String, dynamic> toJSON() => {
        Constants.habitName: habitName,
        Constants.totalDays: totalDays,
        Constants.points: pts,
        Constants.streak: streak
      };

  ScorecardModel fromJSON(Map<String, dynamic> m) => ScorecardModel(
      habitName: m[Constants.habitName],
      totalDays: m[Constants.totalDays],
      pts: m[Constants.points],
      streak: m[Constants.streak]);
}
