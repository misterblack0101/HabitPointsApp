import 'package:flutter/material.dart';
import 'package:flutter_application_1/pages/drawerScreen.dart';
import 'package:flutter_zoom_drawer/flutter_zoom_drawer.dart';
import 'package:get/get_state_manager/src/simple/get_state.dart';
import 'package:get/get_state_manager/src/simple/get_view.dart';

import 'drawercontroller.dart';

class BaseDrawerController extends GetView<MyDrawerController> {
  const BaseDrawerController({
    Key? key,
    required this.mainScreen,
  }) : super(key: key);
  final Widget mainScreen;
  Widget wrappedWithGestureDetector(Widget wid) {
    return GestureDetector(
      onHorizontalDragEnd: (DragEndDetails details) {
        if (details.primaryVelocity! > 0.0) {
          // User swiped Left to right
          controller.toggleDrawer();
        } else if (details.primaryVelocity! < 0) {
          // User swiped Right to left
          controller.toggleDrawer();
        }
      },
      child: wid,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      child: SafeArea(
        child: GetBuilder<MyDrawerController>(
          builder: (_) => ZoomDrawer(
            controller: _.zoomDrawerController,
            menuScreen: const DrawerScreen(),
            mainScreen: wrappedWithGestureDetector(mainScreen),
            borderRadius: 24.0,
            showShadow: true,
            style: DrawerStyle.Style1,
            // duration: const Duration(milliseconds: 250),
            angle: 0.0,
            openCurve: Curves.fastOutSlowIn,
            closeCurve: Curves.fastOutSlowIn,
            // slideWidth: MediaQuery.of(context).size.width * 0.50,
          ),
        ),
      ),
    );
  }
}
