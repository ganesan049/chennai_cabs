import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:testing_referral/network/auth.dart';
import 'package:testing_referral/network/notification.dart';
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
    await FirebaseMessaging.instance.subscribeToTopic('test');
    Auth.userSignedIn()
        ? FirebaseAuth.instance.currentUser!.displayName == null
            ? Navigator.pushReplacementNamed(
                context, NameInputScreen.nameInputScreen)
            : checkNotifications()
        : Navigator.pushReplacementNamed(
            context, AuthInputScreen.authInputScreen);
  }

  void checkNotifications() async {
    final String notification = await PushNotification.getNotificationDetails();
    notification.isNotEmpty
        ? Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => NavigatorScreen(
                route: 4,
                bookingID: notification,
              ),
            ),
          )
        : Navigator.pushReplacementNamed(
            context, NavigatorScreen.navigatorScreen);
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
