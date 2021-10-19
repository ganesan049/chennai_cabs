import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:testing_referral/operations/operations.dart';

class RideHistoryCard extends StatelessWidget {
  final TextStyle kDefault = GoogleFonts.sourceSansPro(color: Colors.black);
  final TextStyle kDefault1 = GoogleFonts.ptSans(
      fontWeight: FontWeight.bold, color: Colors.black, fontSize: 16);
  final String tripStatusOnGoing = 'ongoing';
  final String tripStatusCompleted = 'completed';
  final String tripStatusCancelled = 'cancelled';
  final String tripFare;
  final String tripDate;
  final String tripID;
  final String tripStatus;

  RideHistoryCard(
      {required this.tripFare,
      required this.tripDate,
      required this.tripID,
      required this.tripStatus});

  List<Widget> generate(double length) {
    return List.generate(
      (length / 5).floor(),
      (index) => SizedBox(
        height: 5,
        width: 5,
        child: Divider(
          color: index % 2 == 0 ? Colors.black : Colors.transparent,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
      child: Material(
        elevation: 3,
        borderRadius: BorderRadius.circular(10),
        child: InkWell(
          onTap: () {},
          child: Container(
            height: 125,
            padding: EdgeInsets.all(2),
            decoration: BoxDecoration(
              color: tripStatus == tripStatusCancelled
                  ? Colors.red
                  : tripStatus == tripStatusCompleted
                      ? Colors.green
                      : Colors.orange,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Column(
              children: [
                Container(
                  height: 90,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Expanded(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Text(
                              'Chennai, Tamilnadu',
                              style: kDefault1,
                            ),
                            Icon(
                              Icons.arrow_right_alt_outlined,
                              color: Colors.black,
                            ),
                            Text(
                              'Trichy, Tamilnadu',
                              style: kDefault1,
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 10,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children:
                              generate(MediaQuery.of(context).size.width - 80),
                        ),
                      ),
                      SizedBox(
                        height: 30,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Text(
                              tripID,
                              style: kDefault,
                            ),
                            Text(
                              '·',
                              style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 21,
                                  fontWeight: FontWeight.bold),
                            ),
                            Text(
                              Operations.getMonthName(tripDate)
                              /*.split(' ')[0]
                                      .substring(0, 3) +
                                  Operations.getMonthName(tripDate).split(' ')[1]*/
                              ,
                              style: kDefault,
                            ),
                            Text(
                              '·',
                              style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 21,
                                  fontWeight: FontWeight.bold),
                            ),
                            Text(
                              'Rs. $tripFare',
                              style: kDefault,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: Container(
                    padding: EdgeInsets.only(right: 10),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.vertical(
                        bottom: Radius.circular(10),
                      ),
                    ),
                    child: Align(
                      alignment: Alignment.centerRight,
                      child: Text(
                        tripStatus == tripStatusCancelled
                            ? '· Cancelled ·'
                            : tripStatus == tripStatusCompleted
                            ? '· Completed ·'
                            : '· Ongoing ·',
                        style: GoogleFonts.ptSans(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
