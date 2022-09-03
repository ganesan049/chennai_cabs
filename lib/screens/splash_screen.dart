import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:chennai_cabs_dev/network/auth.dart';
import 'package:chennai_cabs_dev/network/notification.dart';
import 'package:chennai_cabs_dev/screens/auth_input_screen.dart';
import 'package:chennai_cabs_dev/screens/name_input_screen.dart';
import 'package:chennai_cabs_dev/screens/navigator_screen.dart';

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
    await FirebaseMessaging.instance.subscribeToTopic('users');

      Auth.userSignedIn()
          ? FirebaseAuth.instance.currentUser!.displayName == null
              ? Navigator.pushReplacementNamed(
                  context, NameInputScreen.nameInputScreen)
              : checkNotifications()
          : Navigator.pushReplacementNamed(
              context, AuthInputScreen.authInputScreen);
  }

  void checkNotifications() async {
    PushNotification.foreground();
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
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Image.asset('images/logo.png', height: 200, width: 200,),
          SizedBox(
            height: 30,
            width: 30,
            child: Center(
              child: SizedBox(
                height: 20,
                width: 20,
                child: CircularProgressIndicator(
                  strokeWidth: 3,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
