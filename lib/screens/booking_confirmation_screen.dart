import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:testing_referral/network/auth.dart';
import 'package:testing_referral/screens/navigator_screen.dart';

class BookingConfirmationScreen extends StatelessWidget {
  static final String bookingConfirmationScreen = 'BookingConfirmationScreen';

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () {
        Navigator.pushReplacementNamed(
            context, NavigatorScreen.navigatorScreen);
        return Future.value(false);
      },
      child: SafeArea(
        child: Scaffold(
          appBar: AppBar(
            elevation: 0,
            backgroundColor: Colors.white,
            title: Text('Booking confirmation'.toUpperCase()),
            titleTextStyle:
            GoogleFonts.ubuntu(fontWeight: FontWeight.bold, fontSize: 16, color: Colors.black),
            leading: BackButton(
              color: Colors.black,
              onPressed: () => Navigator.pushReplacementNamed(
                  context, NavigatorScreen.navigatorScreen),
            ),
          ),
          body: Padding(
            padding: const EdgeInsets.all(15.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Image.network(
                  'https://media.giphy.com/media/CaS9NNso512WJ4po0t/giphy.gif',
                  height: 200,
                  width: 200,
                ),
                Text(
                  'Thank You, ${Auth.getName()}!',
                  textAlign: TextAlign.center,
                  style: GoogleFonts.ptSans(
                    fontSize: 25,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 10.0, bottom: 10),
                  child: Text(
                    'We have successfully received your booking request.',
                    textAlign: TextAlign.center,
                    style: GoogleFonts.ptSans(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                Text(
                  'The ride details have been sent to your registered mobile number. '
                  'You will receive the cab details within 2 hours prior to your pick up time',
                  textAlign: TextAlign.center,
                  style: GoogleFonts.ptSans(
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
