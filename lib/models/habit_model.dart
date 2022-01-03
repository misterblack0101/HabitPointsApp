/* Habit class model.
  fields: habit name, pts. today = 0, date.
  toJSON and  fromJSON methods
*/

class Habit {
  final String habitName;
  int points;
  Habit({required this.habitName, this.points = 0});

  Map<String, dynamic> toJson() => {
        // Constants.habitName: habitName,
        // Constants.points: points,
        habitName: points,
      };

  Habit fromJSON(Map<String, dynamic> map) => Habit(
        habitName: map.keys.first,
        points: map[habitName],
      );
}
