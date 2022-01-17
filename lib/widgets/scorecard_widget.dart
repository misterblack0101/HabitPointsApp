import 'package:flutter/material.dart';
import 'package:flutter_application_1/models/scorecard_model.dart';
import 'package:sleek_circular_slider/sleek_circular_slider.dart';

import '../constants.dart';

class ScorecardPopUp extends StatelessWidget {
  const ScorecardPopUp({Key? key, required this.sc}) : super(key: key);
  final Scorecard sc;
  @override
  Widget build(BuildContext context) {
    return Container(
      child: SleekCircularSlider(
        appearance: CircularSliderAppearance(
          startAngle: 240,
          angleRange: sc.longestStreak.toDouble(),
          customColors: CustomSliderColors(
            hideShadow: false,
            dotColor: Colors.white,
            trackColor: Constants.drawerColor,
            progressBarColor: Colors.black,
          ),
          customWidths: CustomSliderWidths(progressBarWidth: 5),
        ),
        min: 0,
        max: sc.longestStreak.toDouble(),
        initialValue: sc.streak.toDouble(),
        innerWidget: (percentage) => Center(
            child:
                Text("${sc.streak} / ${sc.longestStreak} \n Streak \n  score")),
      ),
    );
  }
}
