// ignore_for_file: prefer_const_constructors_in_immutables

import 'package:flutter/material.dart';
import 'package:flutter_application_1/constants.dart';

class Bars {
  static Widget getBar(int barHealth) {
    if (barHealth == 0) {
      return Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [BarLeft(), BarMiddle(), BarRight()],
      );
    } else if (barHealth == 1) {
      return Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          BarLeft(
            color: Constants.barColor,
          ),
          BarMiddle(),
          BarRight()
        ],
      );
    } else if (barHealth == 2) {
      return Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          BarLeft(
            color: Constants.barColor,
          ),
          BarMiddle(
            color: Constants.barColor,
          ),
          BarRight()
        ],
      );
    } else if (barHealth == 3) {
      return Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          BarLeft(
            // color: Colors.blueAccent.shade400,
            color: Constants.barColor,
          ),
          BarMiddle(
            color: Constants.barColor,
          ),
          BarRight(
            color: Constants.barColor,
          )
        ],
      );
    }
    return Container();
  }
}

class BarLeft extends StatelessWidget {
  BarLeft({
    Key? key,
    this.color = Colors.white,
  }) : super(key: key);
  final Color color;
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 0.02 * MediaQuery.of(context).size.height,
      width: 0.3 * MediaQuery.of(context).size.width,
      decoration: BoxDecoration(
        color: color,
        border: Border.all(
          color: Constants.drawerColor,
          // width: 3,
        ),
        borderRadius: const BorderRadius.horizontal(left: Radius.circular(30)),
      ),
    );
  }
}

class BarMiddle extends StatelessWidget {
  BarMiddle({Key? key, this.color = Colors.white}) : super(key: key);
  final Color color;
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 0.02 * MediaQuery.of(context).size.height,
      width: 0.3 * MediaQuery.of(context).size.width,
      decoration: BoxDecoration(
        color: color,
        border: Border.all(
          color: Constants.drawerColor,
          // width: 3,
        ),
      ),
    );
  }
}

class BarRight extends StatelessWidget {
  BarRight({Key? key, this.color = Colors.white}) : super(key: key);
  final Color color;
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 0.02 * MediaQuery.of(context).size.height,
      width: 0.3 * MediaQuery.of(context).size.width,
      decoration: BoxDecoration(
        color: color,
        border: Border.all(
          color: Constants.drawerColor,
          // width: 3,
        ),
        borderRadius: const BorderRadius.horizontal(right: Radius.circular(30)),
      ),
    );
  }
}
