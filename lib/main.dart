// ignore_for_file: prefer_const_constructors

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/pages/landing_page.dart';
import 'package:flutter_application_1/services/drawercontroller.dart';
import 'package:get/get.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  FirebaseDatabase.instance.setPersistenceEnabled(true);
  Get.put<MyDrawerController>(MyDrawerController());

  runApp(MyApp());

//TODO: Add splash screen while things load. create a new page preferably.
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      home: LandingPage(),
      // onGenerateRoute: RouteManager.generateRoute,
    );
  }
}
