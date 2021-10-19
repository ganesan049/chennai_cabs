import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:testing_referral/elements/ride_history_card.dart';

class MyRidesScreen extends StatelessWidget {
  static final String myRidesScreen = 'MyRidesScreen';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.green,
        title: Text(
          'MY RIDES',
        ),
        titleTextStyle:
            GoogleFonts.ubuntu(fontWeight: FontWeight.bold, fontSize: 16),
      ),
      body:ListView(
        children: List.generate(
          8,
              (index) => RideHistoryCard(),
        ),
      ),
    );
  }
}
