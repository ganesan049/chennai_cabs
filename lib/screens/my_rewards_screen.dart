import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:testing_referral/network/database.dart';
import 'package:testing_referral/operations/operations.dart';

class MyRewardsScreen extends StatelessWidget {
  static final String myRewardsScreen = 'MyRewardsScreen';

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.green,
        appBar: AppBar(
          elevation: 0,
          backgroundColor: Colors.green,
          title: Text(
            'My Rewards'.toUpperCase(),
          ),
          titleTextStyle:
              GoogleFonts.ubuntu(fontWeight: FontWeight.bold, fontSize: 16),
        ),
        body: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Your balance'.toUpperCase(),
                    style: GoogleFonts.workSans(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.bold),
                  ),
                  SizedBox(
                    height: 50,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        FutureBuilder<String>(
                          future: Database.getRefPoints(),
                          builder: (context, points) {
                            if (points.hasData) {
                              return Text(
                                points.data!,
                                style: GoogleFonts.workSans(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 45),
                              );
                            } else {
                              return SizedBox(
                                height: 30,
                                width: 30,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  valueColor:
                                      AlwaysStoppedAnimation(Colors.white),
                                ),
                              );
                            }
                          },
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        Text(
                          'points',
                          style: GoogleFonts.workSans(
                              color: Colors.white, fontSize: 16),
                        ),
                        SizedBox(
                          width: 3,
                        ),
                        Tooltip(
                          message: '1 point = ₹ 1',
                          triggerMode: TooltipTriggerMode.tap,
                          child: Icon(
                            Icons.info_outline,
                            size: 15,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Container(
              height: MediaQuery.of(context).size.height / 1.5,
              width: MediaQuery.of(context).size.width,
              padding: EdgeInsets.only(top: 20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(40),
                  topRight: Radius.circular(40),
                ),
              ),
              child: FutureBuilder<List<Map>>(
                future: Database.getRefPointsHistory(),
                builder: (context, pointsHistory) {
                  if (pointsHistory.hasData) {
                    if (pointsHistory.data!.isNotEmpty){
                      return ListView.builder(
                        itemCount: pointsHistory.data!.length,
                        itemBuilder: (context, index) => PointsHistoryCard(
                          points: pointsHistory.data!.elementAt(index)[Database.referralPoints],
                          contextForPoints:
                              pointsHistory.data!.elementAt(index)[Database.refContext],
                          date: pointsHistory.data!.elementAt(index)[Database.refDate],
                          pointsReduced:
                              pointsHistory.data!.elementAt(index)[Database.refPointsReduced],
                        ),
                      );
                    }
                    else{
                      return Center(
                        child: Text(
                          'No transactions yet'
                        ),
                      );
                    }
                  } else {
                    return Center(
                      child: CircularProgressIndicator(),
                    );
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class PointsHistoryCard extends StatelessWidget {
  const PointsHistoryCard({
    required this.points,
    required this.contextForPoints,
    required this.date,
    required this.pointsReduced,
  });

  final String date;
  final String contextForPoints;
  final String points;
  final bool pointsReduced;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(
        'Points have been credited against the Ride ID $context',
        maxLines: 2,
        overflow: TextOverflow.ellipsis,
        style: GoogleFonts.ptSans(),
      ),
      leading: Text(
        Operations.getDateMonthNameYear(date),
        maxLines: 2,
        overflow: TextOverflow.ellipsis,
        style: GoogleFonts.ptSans(fontWeight: FontWeight.bold),
      ),
      trailing: Text(
        pointsReduced ? '- $points points' : '+ $points points',
        style: GoogleFonts.ptSans(
            fontWeight: FontWeight.bold,
            color: pointsReduced ? Colors.red : Colors.green),
      ),
    );
  }
}
