import 'package:flutter/material.dart';
import 'package:flutter_application_1/constants.dart';
import 'package:flutter_application_1/models/scorecard_model.dart';
import 'package:flutter_application_1/services/base_drawer_controller.dart';
import 'package:flutter_application_1/services/database_service.dart';
import 'package:flutter_application_1/services/drawercontroller.dart';
import 'package:flutter_application_1/widgets/custom_tile.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/src/extension_navigation.dart';
import 'package:get/get_navigation/src/snackbar/snackbar.dart';
import 'package:get/get_state_manager/get_state_manager.dart';

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return const BaseDrawerController(mainScreen: HomeScreen());
  }
}

class HomeScreen extends GetView<MyDrawerController> {
  // bool isDrawerOpen = false;

  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    //the function is async, but we're not waiting for it, 
    //because we want the syncing to happen in background.
    DbService.instance.syncScorecard();
    return Container(
      color: Constants.homeScreenColor,
      child: Column(
        children: [
          //Heading Row
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              IconButton(
                onPressed: controller.toggleDrawer,
                icon: const Icon(Icons.menu),
                iconSize: 30,
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
                  child: RefreshIndicator(
                    onRefresh: () async {
                      await DbService.instance.syncScorecard();
                      Get.snackbar(
                        "Sync Successful!",
                        "",
                        snackPosition: SnackPosition.BOTTOM,
                        duration: const Duration(seconds: 1),
                        overlayBlur: 0,
                        barBlur: 0,
                        backgroundColor: Constants.barColor,
                        animationDuration: const Duration(milliseconds: 500),
                      );
                    },
                    child: ListView.builder(
                      itemCount: cardsList.length,
                      itemBuilder: (context, index) {
                        return CustomListTile(sc: cardsList[index]);
                      },
                    ),
                  ),
                );
              }
              return const Center(child: CircularProgressIndicator());
            },
          )
        ],
        // ),
      ),
    );
  }
}
