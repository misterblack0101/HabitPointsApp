import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/constants.dart';
import 'package:flutter_application_1/pages/habit_page.dart';
import 'package:flutter_application_1/pages/home_page.dart';
import 'package:flutter_application_1/routes/routes.dart';
import 'package:flutter_application_1/services/database_service.dart';
import 'package:flutter_application_1/services/drawercontroller.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:get/route_manager.dart';

class DrawerScreen extends GetView<MyDrawerController> {
  const DrawerScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(top: 0.05 * MediaQuery.of(context).size.height),
      color: Constants.drawerColor,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              CircleAvatar(
                backgroundImage: NetworkImage(Constants.user!.photoURL!),
                radius: 28,
              ),
              const SizedBox(width: 20),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "${Constants.user!.displayName}",
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 28,
                      color: Colors.white,
                    ),
                  ),

                  //showing total points overall
                  FutureBuilder<int>(
                    future: DbService.instance.getTotalpointsOverall(),
                    builder:
                        (BuildContext context, AsyncSnapshot<int> snapshot) {
                      switch (snapshot.connectionState) {
                        case ConnectionState.waiting:
                          return const Text(
                            'Loading....',
                            style: TextStyle(
                              fontSize: 24,
                              color: Colors.white,
                            ),
                          );
                        default:
                          if (snapshot.hasError) {
                            return Text('Error: ${snapshot.error}',
                                style: const TextStyle(
                                  fontSize: 24,
                                  color: Colors.white,
                                ));
                          } else {
                            return Text('${snapshot.data} Points',
                                style: const TextStyle(
                                  fontSize: 24,
                                  color: Colors.white,
                                ));
                          }
                      }
                    },
                  ),
                ],
              ),
            ],
          ),

          //Navigation options
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              //home button
              CustomTextIconButton(
                icon: Icons.home_rounded,
                text: "Home",
                onpressed: () {
                  // controller.toggleDrawer();
                  Get.off(const HomePage());
                  controller.toggleDrawer();
                },
              ),
              const SizedBox(height: 5),

              //Habit
              CustomTextIconButton(
                icon: Icons.edit,
                text: "Habits",
                onpressed: () {
                  Get.off(const HabitPage());
                  controller.toggleDrawer();
                },
              ),
              const SizedBox(height: 5),

              //settings button
              CustomTextIconButton(
                icon: Icons.settings,
                text: "Settings",
                onpressed: () {
                  Navigator.pushReplacementNamed(
                      context, RouteManager.homePage);
                },
              ),
              const SizedBox(height: 5),

              //Account button
              CustomTextIconButton(
                icon: Icons.person,
                text: "Account",
                onpressed: () {
                  Navigator.pushReplacementNamed(
                      context, RouteManager.homePage);
                },
              ),
              const SizedBox(height: 5),

              //signout button
              CustomTextIconButton(
                icon: Icons.logout_outlined,
                text: "Sign out",
                onpressed: () {
                  FirebaseAuth.instance.signOut();
                },
              ),
            ],
          ),
          SizedBox(height: 0.2 * MediaQuery.of(context).size.height),
        ],
      ),
    );
  }
}

class CustomTextIconButton extends StatelessWidget {
  const CustomTextIconButton({
    Key? key,
    required this.icon,
    required this.text,
    required this.onpressed,
  }) : super(key: key);
  final IconData icon;
  final String text;
  final Function() onpressed;
  @override
  Widget build(BuildContext context) {
    return TextButton.icon(
        onPressed: onpressed,
        icon: FaIcon(
          icon,
          size: 26,
          color: Colors.white,
        ),
        label: Text(
          text,
          style: const TextStyle(
              fontSize: 26, fontWeight: FontWeight.w600, color: Colors.white),
        ));
  }
}
