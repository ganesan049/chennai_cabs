import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:testing_referral/network/database.dart';

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
      body: FutureBuilder<List<Widget>>(
        future: Database.getMyRides(),
        builder: (context, tripHistoryData) {
          if (tripHistoryData.hasData) {
            if (tripHistoryData.data!.isNotEmpty){
              return ListView(
                children: List.generate(
                  tripHistoryData.data!.length,
                  (index) => tripHistoryData.data!.elementAt(index),
                ),
              );
            }
            else{
              return Center(child: Text('No rides yet'),);
            }
          } else {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
        },
      ),
    );
  }
}
