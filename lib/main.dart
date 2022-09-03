import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:chennai_cabs_dev/screens/auth_input_screen.dart';
import 'package:chennai_cabs_dev/screens/auth_verify_screen.dart';
import 'package:chennai_cabs_dev/screens/booking_confirmation_screen.dart';
import 'package:chennai_cabs_dev/screens/contact_us_screen.dart';
import 'package:chennai_cabs_dev/screens/feedback_screen.dart';
import 'package:chennai_cabs_dev/screens/location_search_screen.dart';
import 'package:chennai_cabs_dev/screens/my_rewards_screen.dart';
import 'package:chennai_cabs_dev/screens/my_rides_screen.dart';
import 'package:chennai_cabs_dev/screens/navigator_screen.dart';
import 'package:chennai_cabs_dev/screens/map_screen.dart';
import 'package:chennai_cabs_dev/screens/name_input_screen.dart';
import 'package:chennai_cabs_dev/screens/referral_screen.dart';
import 'package:chennai_cabs_dev/screens/report_screen.dart';
import 'package:chennai_cabs_dev/screens/splash_screen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations(
      [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);
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
        colorScheme: ThemeData().colorScheme.copyWith(
          primary: Colors.green,
        ),
        pageTransitionsTheme: zoomPageTransition,
      ),
      routes: {
        '/': (context) => SplashScreen(),
        AuthInputScreen.authInputScreen: (context) => AuthInputScreen(),
        AuthVerifyScreen.authVerifyScreen: (context) => AuthVerifyScreen(),
        NameInputScreen.nameInputScreen: (context) => NameInputScreen(),
        NavigatorScreen.navigatorScreen: (context) => NavigatorScreen(),
        ReferralScreen.referralScreen: (context) => ReferralScreen(),
        MapScreen.mapScreen: (context) => MapScreen(),
        ReportScreen.reportScreen: (context) => ReportScreen(),
        ContactUsScreen.contactUsScreen: (context) => ContactUsScreen(),
        MyRidesScreen.myRidesScreen: (context) => MyRidesScreen(),
        MyRewardsScreen.myRewardsScreen: (context) => MyRewardsScreen(),
        LocationSearchScreen.locationSearchScreen: (context) =>
            LocationSearchScreen(),
        BookingConfirmationScreen.bookingConfirmationScreen: (context) =>
            BookingConfirmationScreen(),
        FeedbackScreen.feedbackScreen: (context) => FeedbackScreen(),
      },
    );
  }
}
