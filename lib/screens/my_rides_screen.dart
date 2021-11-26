import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:testing_referral/elements/my_rides_screen_loading.dart';
import 'package:testing_referral/elements/ride_history_card.dart';
import 'package:testing_referral/network/database.dart';

class MyRidesScreen extends StatefulWidget {
  static final String myRidesScreen = 'MyRidesScreen';

  final bool? routedFromNotification;
  final String? bookingID;

  MyRidesScreen({this.routedFromNotification, this.bookingID});

  @override
  State<MyRidesScreen> createState() => _MyRidesScreenState();
}

class _MyRidesScreenState extends State<MyRidesScreen> {
  final RideHistoryScreenDialogs dialogs = RideHistoryScreenDialogs();
  final TextEditingController controller = TextEditingController();
  bool screenLoading = true;

  @override
  void initState() {
    if (widget.routedFromNotification != null) {
      WidgetsBinding.instance!.addPostFrameCallback(
        (timeStamp) => Future.delayed(
          timeStamp,
          () {
            setState(() => screenLoading = false);
            dialogs.showRatingDialog(context, widget.bookingID!, controller);
          },
        ),
      );
    } else {
      setState(() => screenLoading = false);
    }

    super.initState();
  }

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
      body: Stack(
        children: [
          FutureBuilder<List<Widget>>(
            future: Database.getMyRides(context),
            builder: (context, tripHistoryData) {
              if (tripHistoryData.hasData) {
                if (tripHistoryData.data!.isNotEmpty) {
                  return RefreshIndicator(
                    onRefresh: () {
                      return Database.getMyRides(context).whenComplete(() => setState((){},),);
                    },
                    child: ListView(
                      children: List.generate(
                        tripHistoryData.data!.length,
                        (index) => tripHistoryData.data!.elementAt(index),
                      ),
                    ),
                  );
                } else {
                  return Center(
                    child: Text('No rides yet'),
                  );
                }
              } else {
                return ListView.builder(
                  physics: NeverScrollableScrollPhysics(),
                  itemCount: (MediaQuery.of(context).size.height / 180).floor(),
                  itemBuilder: (context, count) => MyRidesScreenLoading(),
                );
              }
            },
          ),
          if (screenLoading)
            SizedBox(
              height: MediaQuery.of(context).size.height,
              width: MediaQuery.of(context).size.width,
              child: Center(
                child: SizedBox(
                  height: 30,
                  width: 30,
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
