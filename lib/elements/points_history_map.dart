import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:testing_referral/operations/operations.dart';

class PointsHistoryMap extends StatelessWidget {
  const PointsHistoryMap(
      {required this.date,
      required this.contextForPoints,
      required this.points,
      required this.pointsReduced});

  final String date;
  final String contextForPoints;
  final String points;
  final bool pointsReduced;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 100,
      padding: EdgeInsets.only(left: 20, right: 20),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          SizedBox(
            width: 70,
            child: Text(
              Operations.getDateMonthNameYear(date),
              style: GoogleFonts.sourceSansPro(fontWeight: FontWeight.bold),
            ),
          ),
          SizedBox(
            width: 30,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(
                  height: 86,
                  width: 2,
                  child: Column(
                    children:
                        Operations.generateDottedLines(86, Colors.grey, 1.5),
                  ),
                ),
                CircleAvatar(
                  radius: 7,
                  backgroundColor: pointsReduced ? Colors.red : Colors.green,
                ),
              ],
            ),
          ),
          Expanded(
            child: Text(
              contextForPoints.substring(0, 2) == 'CC'
                  ? pointsReduced
                      ? '$points points used against #$contextForPoints'
                      : '$points points credited against #$contextForPoints'
                  : '$points points credited for a successful referral',
              style: GoogleFonts.sourceSansPro(fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    );
  }
}
