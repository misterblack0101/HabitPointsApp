/* 
to save and retrieve scorecard info from db.
*/
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter_application_1/constants.dart';
import 'package:flutter_application_1/models/scorecard_model.dart';

class ScorecardService {
  ScorecardService();

  final DatabaseReference ref = FirebaseDatabase.instance.ref(Constants.userId);

  Future newScorecard(String habitname) async {
    ScorecardModel scorecardModel =
        ScorecardModel(habitName: habitname, pts: 0, totalDays: 0, streak: 0);
    return await ref.child(Constants.scoreCard).set(scorecardModel.toJSON());
  }
}
