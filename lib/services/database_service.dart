import 'package:firebase_database/firebase_database.dart';
import 'package:flutter_application_1/constants.dart';
import 'package:flutter_application_1/models/scorecard_model.dart';

class DbService {
  static final DbService instance = DbService._initialize();
  DbService._initialize(
    
  );
  final DatabaseReference _scorecardRef = FirebaseDatabase.instance
      .ref()
      .child(Constants.userId + "/" + Constants.scoreCard);

  DatabaseReference get scorecardRef => _scorecardRef;

//read habit --> streambuilder returning.
  Stream<List<Scorecard>> getScorecards() {
    Stream<DatabaseEvent> _scorecardStream = _scorecardRef.onValue;
    final streamToPublish = _scorecardStream.map(
      (event) {
        var map = event.snapshot.value as Map<dynamic, dynamic>;
        List<Scorecard> scorecardList = map.entries
            .map(
              (element) => Scorecard.fromJSON(element.value, element.key),
            )
            .toList();
        return scorecardList;
      },
    );
    return streamToPublish;
  }

  //to set points, with habitname and points.
  void setPoints(String habitname, int points) {
    _scorecardRef.child(habitname).update({Constants.pointsToday: points});
  }

  //create or update scorecard
  void setScorecard(Scorecard scorecard) async {
    await _scorecardRef.update(scorecard.toJSON());
  }

  //delete habit
  void deleteScorecard(String habitname) async {
    _scorecardRef.child(habitname).remove();
  }

  Future syncScorecard() async {
    DateTime now = DateTime.now();
    final DatabaseReference _userRef =
        FirebaseDatabase.instance.ref().child(Constants.userId);
    DataSnapshot snapshot = await _userRef.child(Constants.lastSyncDate).get();
    // If its a new user,
    if (snapshot.value == null) {
      _userRef
          .child(Constants.lastSyncDate)
          .set(DateTime.now().toIso8601String());
      return;
    }
    DateTime dateFromDb = DateTime.parse(snapshot.value as String);
    if (now.isAfter(dateFromDb) && now.day != dateFromDb.day) {
      // what to do if we need to sync
      //this can be the next day, or after any no. of days.
      int dateDiff = _getDateDifference(now, dateFromDb);

      DatabaseEvent event = await _userRef.child(Constants.scoreCard).once();
      Map<dynamic, dynamic> map = event.snapshot.value as Map<dynamic, dynamic>;
      map.forEach(
        (k, v) => {
          _syncHelper((Scorecard.fromJSON(v, k)), dateDiff),
        },
      );
    }
  }

  void _syncHelper(Scorecard scorecard, int diff) async {
    //if syncing the very next day.
    if (scorecard.pointsToday > 0 && diff == 1) {
      //update total days
      scorecard.totalDays += 1;
      //update total points
      scorecard.totalPoints += scorecard.pointsToday;
      //check streak
      scorecard.streak += 1;
      //update barstrength
      scorecard.barStrength += 1;
    } else {
      scorecard.streak = 0;
      //what to do  about barstrength if there's a gap in syncing.
      scorecard.barStrength -= diff;
    }

    if (scorecard.barStrength > 3) {
      scorecard.barStrength = 3;
    } else if (scorecard.barStrength < 0) {
      scorecard.barStrength = 0;
    }
    //update total streak
    if (scorecard.streak > scorecard.longestStreak) {
      scorecard.longestStreak = scorecard.streak;
    }
    //set todayPoints to 0
    scorecard.pointsToday = 0;
    //update scorecard
    //////////////
    await _scorecardRef.update(scorecard.toJSON());
  }

  int _getDateDifference(DateTime now, DateTime external) {
    return (now.difference(external).inHours / 24).round();
  }
}
