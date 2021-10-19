import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:testing_referral/screens/auth_input_screen.dart';
import 'package:testing_referral/screens/auth_verify_screen.dart';
import 'package:testing_referral/screens/contact_us_screen.dart';
import 'package:testing_referral/screens/my_rewards_screen.dart';
import 'package:testing_referral/screens/my_rides_screen.dart';
import 'package:testing_referral/screens/navigator_screen.dart';
import 'package:testing_referral/screens/map_screen.dart';
import 'package:testing_referral/screens/name_input_screen.dart';
import 'package:testing_referral/screens/referral_screen.dart';
import 'package:testing_referral/screens/report_screen.dart';
import 'package:testing_referral/screens/testing_screen.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  Firebase.initializeApp();
  runApp(
    MyApp(),
  );
}

class MyApp extends StatelessWidget {
  final PageTransitionsTheme zoomPageTransition = PageTransitionsTheme(
    builders: {
      TargetPlatform.android: ZoomPageTransitionsBuilder(),
      TargetPlatform.iOS: ZoomPageTransitionsBuilder()
    },
  );

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      initialRoute: '/',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        pageTransitionsTheme: zoomPageTransition,
      ),
      routes: {
        '/': (context) => AuthInputScreen(),
        AuthVerifyScreen.authVerifyScreen: (context) => AuthVerifyScreen(),
        NameInputScreen.nameInputScreen: (context) => NameInputScreen(),
        NavigatorScreen.navigatorScreen: (context) => NavigatorScreen(),
        ReferralScreen.referralScreen: (context) => ReferralScreen(),
        MapScreen.mapScreen: (context) => MapScreen(),
        ReportScreen.reportScreen: (context) => ReportScreen(),
        ContactUsScreen.contactUsScreen: (context) => ContactUsScreen(),
        MyRidesScreen.myRidesScreen: (context) => MyRidesScreen(),
        MyRewardsScreen.myRewardsScreen: (context) => MyRewardsScreen(),
        TestingScreen.testingScreen: (context) => TestingScreen(),
      },
    );
  }
}
