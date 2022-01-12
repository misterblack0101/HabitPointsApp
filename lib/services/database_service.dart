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

  Future<int> getTotalpointsOverall() async {
    DatabaseEvent _event =
        await _userRef.child(Constants.totalPointsOverall).once();
    return _event.snapshot.value as int;
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

  Future<bool> syncScorecard() async {
    DateTime now = DateTime.now();

    DataSnapshot snapshot = await _userRef
        .child(Constants.lastSyncDate)
        .get(); // If its a new user,

    if (snapshot.value == null) {
      _userRef
          .child(Constants.lastSyncDate)
          .set(DateTime.now().toIso8601String());
      _userRef.child(Constants.totalPointsToday).set(0);
      _userRef.child(Constants.totalPointsOverall).set(0);
      return false;
    }
    DateTime dateFromDb = DateTime.parse(snapshot.value as String);
    if (now.isAfter(dateFromDb) && now.day != dateFromDb.day) {
      // what to do if we need to sync
      //this can be the next day, or after any no. of days.
      int dateDiff = _getDateDifference(now, dateFromDb);
      DatabaseEvent event = await scorecardRef.once();
      Map<dynamic, dynamic> map = event.snapshot.value as Map<dynamic, dynamic>;
      map.forEach(
        (k, v) => {
          _syncHelper(k as String, dateDiff),
        },
      );

      // updating total points overall.
      //getting the total points today
      DatabaseEvent _temp =
          await _userRef.child(Constants.totalPointsToday).once();
      //updating the total points overall
      _userRef.update({
        Constants.totalPointsOverall:
            ServerValue.increment(_temp.snapshot.value as int)
      });
      //setting total points today to 0
      _userRef.child(Constants.totalPointsToday).set(0);
      //setting last sync date timestamp to today.
      _userRef.child(Constants.lastSyncDate).set(now.toIso8601String());
      return true;
    } else {
      return false;
    }
  }

  void _syncHelper(String habitName, int diff) async {
    //if syncing the very next day.

    DatabaseEvent _pointsTodayEvent = await _scorecardRef
        .child(habitName)
        .child(Constants.pointsToday)
        .once();
    int pointsToday = _pointsTodayEvent.snapshot.value as int;

//for streak and barstrength
    if (pointsToday > 0 && diff == 1) {
      _scorecardRef.child(habitName).update({
        Constants.barStrength: ServerValue.increment(1),
        Constants.streak: ServerValue.increment(1)
      });
    } else {
      _scorecardRef.child(habitName).update({
        Constants.barStrength: ServerValue.increment(-1 * diff),
        Constants.streak: 0
      });
    }
    _correctBarStrength(habitName);

    //update total days and total points
    _scorecardRef.child(habitName).update({
      Constants.totalDays: ServerValue.increment(diff),
      Constants.totalPoints: ServerValue.increment(pointsToday),
    });

    //update longest streak
    _updateLongestStreak(habitName);

    //set pointsToday to 0
    _scorecardRef.child(habitName).update({Constants.pointsToday: 0});
  }

  Future<void> _updateLongestStreak(String habitName) async {
    DatabaseEvent _streakEvent =
        await _scorecardRef.child(habitName).child(Constants.streak).once();
    int streak = _streakEvent.snapshot.value as int;
    DatabaseEvent _longestStreakEvent =
        await _scorecardRef.child(habitName).child(Constants.longstreak).once();
    int longestStreak = _longestStreakEvent.snapshot.value as int;
    if (streak > longestStreak) {
      _scorecardRef.child(habitName).update({Constants.longstreak: streak});
    }
  }

  int _getDateDifference(DateTime now, DateTime external) {
    return (now.difference(external).inHours / 24).round();
  }

  Future<void> _correctBarStrength(String habitName) async {
    DatabaseEvent _barEvent = await _scorecardRef
        .child(habitName)
        .child(Constants.barStrength)
        .once();
    int barStrength = _barEvent.snapshot.value as int;

    if (barStrength > 3) {
      // scorecard.barStrength = 3;
      _scorecardRef.child(habitName).update({Constants.barStrength: 3});
    } else if (barStrength < 0) {
      // scorecard.barStrength = 0;
      _scorecardRef.child(habitName).update({Constants.barStrength: 0});
    }
  }
}
