import 'dart:async';
import 'dart:ui';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:testing_referral/network/database.dart';
import 'package:testing_referral/operations/operations.dart';
import 'package:testing_referral/screens/my_rewards_screen.dart';
import 'package:testing_referral/screens/referral_screen.dart';
import 'package:testing_referral/screens/rental_screen.dart';
import 'package:testing_referral/screens/round_trip_screen.dart';
import 'my_rides_screen.dart';
import 'one_way_trip_screen.dart';
import 'options_screen.dart';

class NavigatorScreen extends StatefulWidget {
  static final String navigatorScreen = 'NavigatorScreen';

  final int? route;
  final String? bookingID;

  const NavigatorScreen({this.route, this.bookingID});

  @override
  State<NavigatorScreen> createState() => _NavigatorScreenState();
}

class _NavigatorScreenState extends State<NavigatorScreen> {
  final List<Widget> screens = [
    OneWayTripScreen(),
    RoundTripScreen(),
    RentalScreen(),
    ReferralScreen(),
    OptionScreen()
  ];
  final PageController pageController = PageController();
  final List<String> screenTitle = [
    'One way trip',
    'Round trip',
    'Rental Package',
    'Invite',
    'Options'
  ];
  final StreamController<List> indexStream = StreamController.broadcast();

  @override
  void initState() {
    if (widget.route != null) {
      WidgetsBinding.instance!.addPostFrameCallback(
        (timeStamp) => Future.delayed(
          timeStamp,
          () {
            indexStream.add(
              [widget.route!, true],
            );
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => MyRidesScreen(
                  routedFromNotification: true,
                  bookingID: widget.bookingID,
                ),
              ),
            );
          },
        ),
      );
    }
    indexStream.stream.listen(
      (index) {
        if(!index[1]){
          pageController.jumpToPage(index[0]);
        }
      },
    );
    super.initState();
  }

  @override
  void dispose() {
    indexStream.close();
    pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () => Operations.exit(context),
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: PreferredSize(
          preferredSize: const Size(double.infinity, kToolbarHeight),
          child: StreamBuilder<List>(
              initialData: [0, true],
              stream: indexStream.stream,
              builder: (context, snapshot) {
                return AppBar(
                  elevation: snapshot.data![0] == 3 ? 0 : 3,
                  backgroundColor: Colors.green,
                  actions: snapshot.data![0] == 3
                      ? [
                          FutureBuilder<int>(
                            future: Database.getTotalPoints(),
                            builder: (context, future) {
                              return InkWell(
                                onTap: () => Navigator.pushNamed(
                                    context, MyRewardsScreen.myRewardsScreen),
                                child: SizedBox(
                                  height: 5,
                                  child: Row(
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.only(right: 4.0, top: 2),
                                        child: Icon(Icons.paid_outlined, size: 17,),
                                      ),
                                      Text(
                                        'Total Points: ',
                                        style: GoogleFonts.ubuntu(),
                                      ),
                                      future.hasData? Padding(
                                        padding: const EdgeInsets.only(right: 10),
                                        child:  Text(
                                          '${future.data}',
                                          style: GoogleFonts.ubuntu(),
                                        ),
                                      ) : Padding(
                                        padding: const EdgeInsets.only(right: 10, left: 3),
                                        child:  SizedBox(
                                          height: 10,
                                          width: 10,
                                          child: CircularProgressIndicator(
                                            strokeWidth: 2,
                                            valueColor: AlwaysStoppedAnimation(Colors.white),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            }
                          ),
                        ]
                      : null,
                  title: snapshot.data![0] == 2
                      ? Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              screenTitle
                                  .elementAt(snapshot.data![0])
                                  .toUpperCase(),
                            ),
                            Text(
                              '(Chennai & Bangalore) Only',
                              style: GoogleFonts.ptSans(
                                  color: Colors.white60, fontSize: 13),
                            ),
                          ],
                        )
                      : Text(
                          screenTitle.elementAt(snapshot.data![0]).toUpperCase(),
                        ),
                  titleTextStyle: GoogleFonts.ubuntu(
                      fontWeight: FontWeight.bold, fontSize: 16),
                );
              },),
        ),
        bottomNavigationBar: StreamBuilder<List>(
            stream: indexStream.stream,
            initialData: [0, true],
            builder: (context, snapshot) {
              return BottomNavigationBar(
                onTap: (index) {
                  indexStream.add([index, false]);
                },
                iconSize: 30,
                currentIndex: snapshot.data![0],
                showSelectedLabels: false,
                showUnselectedLabels: false,
                type: BottomNavigationBarType.fixed,
                backgroundColor: Colors.green,
                unselectedItemColor: Colors.white54,
                selectedItemColor: Colors.white,
                items: [
                  BottomNavigationBarItem(
                    label: 'One way',
                    icon: Icon(Icons.arrow_right_alt_outlined),
                  ),
                  BottomNavigationBarItem(
                    label: 'Round trip',
                    icon: Icon(Icons.compare_arrows_outlined),
                  ),
                  BottomNavigationBarItem(
                    label: 'Rental',
                    icon: Icon(Icons.car_rental),
                  ),
                  BottomNavigationBarItem(
                    label: 'Invite',
                    icon: Icon(Icons.person_add),
                  ),
                  BottomNavigationBarItem(
                    label: 'Options',
                    icon: Icon(Icons.menu),
                  ),
                ],
              );
            }),
        backgroundColor: Colors.green,
        body: PageView.builder(
          controller: pageController,
          itemCount: screens.length,
          onPageChanged: (index) => indexStream.add([index, true]),
          itemBuilder: (context, index) => screens.elementAt(index),
        ),
      ),
    );
  }
}
