import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:testing_referral/network/auth.dart';
import 'package:testing_referral/screens/auth_input_screen.dart';
import 'package:testing_referral/screens/name_input_screen.dart';
import 'package:testing_referral/screens/navigator_screen.dart';

class SplashScreen extends StatefulWidget {
  static final String splashScreen = 'SplashScreen';

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    initialize();
    super.initState();
  }

  void initialize() async {
    await Firebase.initializeApp();
    Auth.userSignedIn()
        ? FirebaseAuth.instance.currentUser!.displayName == null
            ? Navigator.pushReplacementNamed(
                context, NameInputScreen.nameInputScreen)
            : Navigator.pushReplacementNamed(
                context, NavigatorScreen.navigatorScreen)
        : Navigator.pushReplacementNamed(
            context, AuthInputScreen.authInputScreen);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Container(
          height: 30,
          width: 30,
          child: CircularProgressIndicator(
            strokeWidth: 3,
          ),
        ),
      ),
    );
  }
}
