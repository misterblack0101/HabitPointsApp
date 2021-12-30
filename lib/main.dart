// ignore_for_file: prefer_const_constructors

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/constants.dart';
import 'package:flutter_application_1/routes/routes.dart';

Future<void> main() async {

  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
//TODO: Add splash screen while things load. create a new page preferably.
  FirebaseAuth.instance.authStateChanges().listen((User? user) {
    if (user != null) {
      Constants.user = user;
      Constants.userId = user.uid;
      runApp(MyApp(
        showLoginPage: false,
      ));
    } else {
      runApp(MyApp(showLoginPage: true));
    }
  });
}

class MyApp extends StatelessWidget {                  // Navigator.of(context).pushNamed(RouteManager.homePage);

  bool showLoginPage = true;
  MyApp({Key? key, required this.showLoginPage}) : super(key: key);

  // This widget is the root of your application.

  @override
  Widget build(BuildContext context) {
    return (showLoginPage)
        ? MaterialApp(
            debugShowCheckedModeBanner: false,
            initialRoute: RouteManager.loginPage,
            onGenerateRoute: RouteManager.generateRoute,
          )
        : MaterialApp(
            debugShowCheckedModeBanner: false,
            initialRoute: RouteManager.homePage,
            onGenerateRoute: RouteManager.generateRoute,
          );
  }
}
