import 'package:flutter/material.dart';
import 'package:flutter_application_1/constants.dart';
import 'package:flutter_application_1/models/scorecard_model.dart';
import 'package:flutter_application_1/pages/drawerScreen.dart';
import 'package:flutter_application_1/services/database_service.dart';
import 'package:flutter_application_1/widgets/custom_tile.dart';

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Material(
      child: SafeArea(
        child: Stack(
          children: const [
            DrawerScreen(),
            HomeScreen(),
          ],
        ),
      ),
    );
  }
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  double xOffset = 0, yoffset = 0, scaleFactor = 1;
  bool isDrawerOpen = false;
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance!.addPostFrameCallback((_) async {
      if (await DbService.instance.syncScorecard()) {
        setState(() {});
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return AnimatedContainer(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(isDrawerOpen ? 40 : 0.0),
        color: Constants.homeScreenColor,
      ),
      transform: Matrix4.translationValues(xOffset, yoffset, 0)
        ..scale(scaleFactor),
      duration: const Duration(milliseconds: 250),
      child: Column(
        children: [
          //Heading Row
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              isDrawerOpen
                  ? IconButton(
                      onPressed: () {
                        setState(() {
                          xOffset = 0;
                          yoffset = 0;
                          scaleFactor = 1;
                          isDrawerOpen = false;
                        });
                      },
                      icon: const Icon(Icons.arrow_back_ios_new_rounded),
                      iconSize: 30,
                      // padding: const EdgeInsets.only(left: 10),
                    )
                  : IconButton(
                      onPressed: () {
                        setState(() {
                          xOffset = 0.6 * width;
                          yoffset = 0.2 * height;
                          scaleFactor = 0.6;
                          isDrawerOpen = true;
                        });
                      },
                      icon: const Icon(Icons.menu),
                      iconSize: 30,
                      // padding: const EdgeInsets.only(left: 10),
                    ),
              StreamBuilder(
                stream: DbService.instance.getTotalPointsToday(),
                builder: (context, snapshot) {
                  return Row(
                    children: [
                      Text(
                        snapshot.hasData ? " ${snapshot.data}" : "___",
                        style:
                            const TextStyle(fontSize: 26, color: Colors.white),
                      ),
                      const Text(
                        "  Points Today",
                        style: TextStyle(fontSize: 20, color: Colors.white),
                      )
                    ],
                  );
                },
              ),
              const SizedBox(width: 24)
            ],
          ),

          // List..
          StreamBuilder(
            stream: DbService.instance.getScorecards(),
            builder: (context, snap) {
              if (snap.hasData) {
                final cardsList = snap.data as List<Scorecard>;
                return Expanded(
                  child: ListView.builder(
                    itemCount: cardsList.length,
                    itemBuilder: (context, index) {
                      return CustomListTile(sc: cardsList[index]);
                    },
                  ),
                );
              }
              return const Center(child: CircularProgressIndicator());
            },
          )
        ],
      ),
    );
  }
}
