import 'package:firebase_database/firebase_database.dart';
import 'package:flutter_application_1/constants.dart';
import 'package:flutter_application_1/models/scorecard_model.dart';

class DbService {
  static final DbService instance = DbService._initialize();
  DbService._initialize();
  final DatabaseReference _scorecardRef = FirebaseDatabase.instance
      .ref()
      .child(Constants.userId + "/" + Constants.scoreCard);
  final DatabaseReference _userRef =
      FirebaseDatabase.instance.ref().child(Constants.userId);

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

  Stream<int> getTotalPointsToday() {
    Stream<DatabaseEvent> _pointStream =
        _userRef.child(Constants.totalPointsToday).onValue;
    final streamToPublish =
        _pointStream.map((event) => event.snapshot.value as int);
    return streamToPublish;
  }

  Stream<int> getTotalPointsOverall() {
    Stream<DatabaseEvent> _pointStream =
        _userRef.child(Constants.totalPointsOverall).onValue;
    final streamToPublish =
        _pointStream.map((event) => event.snapshot.value as int);
    return streamToPublish;
  }

  //to add one point for a habit.
  void addOnePoint(String habitname) {
    _scorecardRef
        .child(habitname)
        .update({Constants.pointsToday: ServerValue.increment(1)});
    _userRef.update({Constants.totalPointsToday: ServerValue.increment(1)});
  }

  //to reduce one point for a habit.
  void reduceOnePoint(String habitname) {
    _scorecardRef
        .child(habitname)
        .update({Constants.pointsToday: ServerValue.increment(-1)});
    _userRef.update({Constants.totalPointsToday: ServerValue.increment(-1)});
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

    DataSnapshot snapshot = await _userRef.child(Constants.lastSyncDate).get();
    // If its a new user,
    if (snapshot.value == null) {
      _userRef
          .child(Constants.lastSyncDate)
          .set(DateTime.now().toIso8601String());
      _userRef.child(Constants.totalPointsToday).set(0);
      _userRef.child(Constants.totalPointsOverall).set(0);
      return;
    }
    DateTime dateFromDb = DateTime.parse(snapshot.value as String);
    if (now.isAfter(dateFromDb) && now.day != dateFromDb.day) {
      // what to do if we need to sync
      //this can be the next day, or after any no. of days.
      int dateDiff = _getDateDifference(now, dateFromDb);
      DataSnapshot snapshot = await scorecardRef.get();
      Map<dynamic, dynamic> map = snapshot.value as Map<dynamic, dynamic>;
      map.forEach(
        (k, v) => {
          _syncHelper(k as String, dateDiff),
        },
      );
      // upfating total points overall
      _userRef.update({
        Constants.totalPointsOverall: ServerValue.increment(
            _userRef.child(Constants.totalPointsToday).get() as int)
      });
      //setting total points today to 0
      _userRef.child(Constants.totalPointsToday).set(0);
      //setting last sync date timestamp to today.
      _userRef.child(Constants.lastSyncDate).set(now.toIso8601String());
    }
  }

  void _syncHelper(String habitName, int diff) async {
    //if syncing the very next day.
    int pointsToday = (_scorecardRef
            .child(habitName)
            .child(Constants.pointsToday)
            .get() as DataSnapshot)
        .value as int;

    if (pointsToday > 0 && diff == 1) {
      //update total days
      // scorecard.totalDays += 1;
      _scorecardRef
          .child(habitName)
          .update({Constants.totalDays: ServerValue.increment(1)});

      //update total points
      // scorecard.totalPoints += scorecard.pointsToday;
      _scorecardRef
          .child(habitName)
          .update({Constants.totalPoints: ServerValue.increment(pointsToday)});

      //update streak
      // scorecard.streak += 1;
      _scorecardRef
          .child(habitName)
          .update({Constants.streak: ServerValue.increment(1)});

      //update barstrength
      // scorecard.barStrength += 1;
      _scorecardRef
          .child(habitName)
          .update({Constants.barStrength: ServerValue.increment(1)});
    } else {
      // scorecard.streak = 0;
      _scorecardRef.child(habitName).child(Constants.streak).set(0);

      //what to do  about barstrength if there's a gap in syncing.
      // scorecard.barStrength -= diff;
      _scorecardRef
          .child(habitName)
          .update({Constants.barStrength: ServerValue.increment(-1 * diff)});
    }
    int barStrength = (_scorecardRef
            .child(habitName)
            .child(Constants.barStrength)
            .get() as DataSnapshot)
        .value as int;

    if (barStrength > 3) {
      // scorecard.barStrength = 3;
      _scorecardRef.child(habitName).update({Constants.barStrength: 3});
    } else if (barStrength < 0) {
      // scorecard.barStrength = 0;
      _scorecardRef.child(habitName).update({Constants.barStrength: 0});
    }

    //update total streak
    int streak = (_scorecardRef.child(habitName).child(Constants.streak).get()
            as DataSnapshot)
        .value as int;
    int longestStreak = (_scorecardRef
            .child(habitName)
            .child(Constants.longstreak)
            .get() as DataSnapshot)
        .value as int;
    if (streak > longestStreak) {
      _scorecardRef.child(habitName).update({Constants.longstreak: streak});
    }
    //set todayPoints to 0
    _scorecardRef.child(habitName).update({Constants.pointsToday: 0});
  }

  int _getDateDifference(DateTime now, DateTime external) {
    return (now.difference(external).inHours / 24).round();
  }
}
