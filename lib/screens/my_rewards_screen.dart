import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:google_fonts/google_fonts.dart';

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
                        Text(
                          '1000'.toUpperCase(),
                          style: GoogleFonts.workSans(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 45),
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
              child: ListView(
                children: [
                  PointsHistoryCard(),
                  Divider(
                    indent: 50,
                    endIndent: 50,
                  ),
                  PointsHistoryCard(),
                  Divider(
                    indent: 50,
                    endIndent: 50,
                  ),
                  PointsHistoryCard(),
                  Divider(
                    indent: 50,
                    endIndent: 50,
                  ),
                  PointsHistoryCard(),
                  Divider(
                    indent: 50,
                    endIndent: 50,
                  ),
                ],
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
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(
        'Your friend has taken a ride',
        maxLines: 2,
        overflow: TextOverflow.ellipsis,
        style: GoogleFonts.ptSans(),
      ),
      leading: Text(
        '27 Oct 21',
        maxLines: 2,
        overflow: TextOverflow.ellipsis,
        style: GoogleFonts.ptSans(fontWeight: FontWeight.bold),
      ),
      trailing: Text(
        '+ 150 points',
        style: GoogleFonts.ptSans(
            fontWeight: FontWeight.bold, color: Colors.green),
      ),
    );
  }
}
