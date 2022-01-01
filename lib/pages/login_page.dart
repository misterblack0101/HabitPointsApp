import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/services/alert_dialog.dart';
import 'package:flutter_signin_button/button_builder.dart';
import 'package:flutter_signin_button/button_list.dart';
import 'package:flutter_signin_button/button_view.dart';
import 'package:google_sign_in/google_sign_in.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final GoogleSignIn googleSignin = GoogleSignIn();
  final FirebaseAuth firebaseAuth = FirebaseAuth.instance;
  late TextEditingController passwordController, emailIdController;

  @override
  void initState() {
    super.initState();
    passwordController = TextEditingController();
    emailIdController = TextEditingController();
  }

  @override
  void dispose() {
    super.dispose();
    emailIdController.dispose();
    passwordController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Material(
        child: SingleChildScrollView(
          child: Column(
            children: [
              const SizedBox(height: 100),
              Image.asset(
                'assets/images/login.png',
                fit: BoxFit.contain,
                alignment: Alignment.center,
              ),
              const SizedBox(height: 2),
              const Text("Welcome!",
                  style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold)),
              //
              //Username and password section starts
              //
              const SizedBox(height: 20),
              //emailId field
              TextFormField(
                controller: emailIdController,
                decoration: const InputDecoration(
                    hintText: "Enter your Email Id here",
                    labelText: "Email-id"),
                validator: (value) {
                  if (value!.isEmpty) {
                    return "Email cannot be empty!";
                  }
                  return null;
                },
              ),
              const SizedBox(height: 10),
              //password field
              TextFormField(
                controller: passwordController,
                obscureText: true,
                decoration: const InputDecoration(
                  hintText: "Enter your password here",
                  labelText: "Password",
                ),
                validator: (value) {
                  if (value!.isEmpty) {
                    return "Password cannot be empty!";
                  } else if (value.length <= 6) {
                    return "Password length should be more than 6 characters.";
                  }
                  return null;
                },
              ),
              const SizedBox(height: 30),
              //
              // Login buttons start here.
              //
              //Sign Up button
              SignInButtonBuilder(
                text: "Create account",
                icon: Icons.person_add_alt_1,
                backgroundColor: Colors.blueGrey,
                onPressed: () async {
                  bool status = false;
                  try {
                    await firebaseAuth.createUserWithEmailAndPassword(
                        email: emailIdController.text,
                        password: passwordController.text);
                    status = true;
                  } catch (e) {
                    status = false;
                    alertDialogShower(
                        context, "Signup Unsuccessful!", e.toString());
                  }
                  if (status) {
                    alertDialogShower(context, "Signup Successful!",
                        "Your account has been created successfully!\nPlease login again with email id and password.");
                    // TODO: scorecardservice.newscorecard, because account is created.
                  }
                },
              ),
              const SizedBox(height: 20),

              //login with email button
              SignInButton(
                Buttons.Email,
                onPressed: () async {
                  UserCredential? firebaseUser;
                  try {
                    await firebaseAuth.signInWithEmailAndPassword(
                        email: emailIdController.text,
                        password: passwordController.text);
                  } catch (e) {
                    alertDialogShower(context, "Login Failed!", e.toString());
                  }
                },
              ),
              const SizedBox(height: 20),

              //Sign in with google button.
              SignInButton(
                Buttons.GoogleDark,
                onPressed: () async {
                  try {
                    final GoogleSignInAccount? googleUser =
                        await googleSignin.signIn();
                    final GoogleSignInAuthentication googleAuth =
                        await googleUser!.authentication;
                    final AuthCredential credential =
                        GoogleAuthProvider.credential(
                            idToken: googleAuth.idToken,
                            accessToken: googleAuth.accessToken);
                    await firebaseAuth.signInWithCredential(credential);
                  } catch (e) {
                    alertDialogShower(
                        context, "An error occured!", e.toString());
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
