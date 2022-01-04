import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/constants.dart';
import 'package:flutter_application_1/models/scorecard_model.dart';
import 'package:flutter_application_1/services/database_service.dart';

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Material(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              Constants.userId,
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
            ),
            ElevatedButton(
                onPressed: () async {
                  await FirebaseAuth.instance.signOut();
                },
                child: const Text("Sign out")),
            const SizedBox(height: 20),
            ElevatedButton(
              child: const Text("Write habit"),
              onPressed: () {
                DbService.instance.setScorecard(
                  Scorecard(
                      habitName: "Ride",
                      comment: "Joyriderrrrrrrrrrrrrrr",
                      totalDays: 51,
                      longestStreak: 345),
                );
              },
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              child: const Text("sync data"),
              onPressed: () async {
                await DbService.instance.syncScorecard();
              },
            ),
            StreamBuilder(
              stream: DbService.instance.getScorecards(),
              builder: (context, snap) {
                if (snap.hasData) {
                  List<ListTile> listTiles = <ListTile>[];
                  final cardsList = snap.data as List<Scorecard>;
                  listTiles.addAll(
                    cardsList.map(
                      (sc) {
                        return ListTile(
                          leading: const Icon(Icons.crop_square_rounded),
                          title: Text(sc.habitName),
                          subtitle: Text(sc.comment),
                        );
                      },
                    ),
                  );
                  return Expanded(
                    child: ListView(
                      children: listTiles,
                    ),
                  );
                }
                return const CircularProgressIndicator.adaptive();
              },
            )
          ],
        ),
      ),
    );
  }
}
