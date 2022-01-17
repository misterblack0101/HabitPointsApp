import 'package:flutter/material.dart';
import 'package:flutter_application_1/constants.dart';
import 'package:flutter_application_1/services/base_drawer_controller.dart';
import 'package:flutter_application_1/services/drawercontroller.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get_state_manager/src/simple/get_view.dart';

class HabitPage extends StatelessWidget {
  const HabitPage({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return const BaseDrawerController(mainScreen: HabitScreen());
  }
}

class HabitScreen extends GetView<MyDrawerController> {
  const HabitScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      // color: Constants.homeScreenColor,
      color: Colors.red,
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
              TextButton.icon(
                onPressed: () {},
                icon: const FaIcon(
                  FontAwesomeIcons.plusCircle,
                  color: Colors.white,
                  size: 20,
                ),
                label: const Text(
                  "Add new habit",
                  style: TextStyle(color: Colors.white, fontSize: 18),
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),

          //DailyGoal Points:
        ],
      ),
    );
  }
}
