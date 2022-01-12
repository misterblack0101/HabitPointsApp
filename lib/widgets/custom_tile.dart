import 'package:flutter/material.dart';
import 'package:flutter_application_1/constants.dart';
import 'package:flutter_application_1/models/scorecard_model.dart';
import 'package:flutter_application_1/services/database_service.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class CustomListTile extends StatelessWidget {
  const CustomListTile({Key? key, required this.sc}) : super(key: key);
  final Scorecard sc;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Card(
        color: Colors.white38,
        borderOnForeground: true,
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(15.0)),
        elevation: 2.0,
        shadowColor: Colors.white60,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                //habit Name
                Text(
                  "  ${sc.habitName}",
                  style: const TextStyle(fontSize: 28),
                ),

                //score change buttons.
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    //minus button
                    IconButton(
                        onPressed: () {
                          DbService.instance.reduceOnePoint(sc.habitName);
                        },
                        enableFeedback: true,
                        color: Constants.barColor,
                        splashColor: Colors.white,
                        splashRadius: 22,
                        icon: const FaIcon(
                          FontAwesomeIcons.solidMinusSquare,
                          size: 20,
                        )),

                    //points
                    Text(
                      "${sc.pointsToday}",
                      style: const TextStyle(fontSize: 22),
                    ),

                    //plus button
                    IconButton(
                        onPressed: () {
                          DbService.instance.addOnePoint(sc.habitName);
                        },
                        enableFeedback: true,
                        color: Constants.barColor,
                        splashColor: Colors.white,
                        splashRadius: 22,
                        icon: const FaIcon(
                          FontAwesomeIcons.solidPlusSquare,
                          size: 20,
                        )),
                  ],
                )
              ],
            ),
            // const SizedBox(height: 10),
            // Bars.getBar(sc.barStrength),
            const SizedBox(height: 10),
            Text(
              "Current streak : ${sc.streak} days",
              style: const TextStyle(
                fontStyle: FontStyle.italic,
              ),
            )
          ],
        ),
      ),
    );
  }
}
