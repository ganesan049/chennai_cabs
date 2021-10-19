import 'dart:ui';
import 'package:date_time_picker/date_time_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:testing_referral/operations/operations.dart';
import 'package:testing_referral/screens/my_rewards_screen.dart';
import 'package:testing_referral/screens/referral_screen.dart';
import 'package:testing_referral/screens/rental_screen.dart';
import 'package:testing_referral/screens/round_trip_screen.dart';
import 'one_way_trip_screen.dart';
import 'options_screen.dart';

class NavigatorScreen extends StatefulWidget {
  static final String navigatorScreen = 'NavigatorScreen';

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

  final List<String> screenTitle = [
    'One way trip',
    'Round trip',
    'Rental',
    'Invite',
    'Options'
  ];
  int currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: WillPopScope(
        onWillPop: () => Operations.exit(context),
        child: Scaffold(
          resizeToAvoidBottomInset: false,
          appBar: AppBar(
            elevation: currentIndex == 3 ? 0 : 3,
            backgroundColor: Colors.green,
            actions: currentIndex == 3
                ? [
                    InkWell(
                      onTap: () => Navigator.pushNamed(
                          context, MyRewardsScreen.myRewardsScreen),
                      child: Row(
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(right: 7.0),
                            child: Icon(CupertinoIcons.gift_fill),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(right: 10),
                            child: Text(
                              'My Rewards',
                              style: GoogleFonts.ubuntu(),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ]
                : null,
            title: Text(
              screenTitle.elementAt(currentIndex).toUpperCase(),
            ),
            titleTextStyle:
                GoogleFonts.ubuntu(fontWeight: FontWeight.bold, fontSize: 16),
          ),
          bottomNavigationBar: BottomNavigationBar(
            onTap: (index) => setState(() => currentIndex = index),
            currentIndex: currentIndex,
            showSelectedLabels: false,
            showUnselectedLabels: false,
            type: BottomNavigationBarType.fixed,
            backgroundColor: Colors.green,
            unselectedItemColor: Colors.white54,
            selectedItemColor: Colors.white,
            items: [
              BottomNavigationBarItem(
                label: 'One way trip',
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
          ),
          backgroundColor: Colors.green,
          body: screens.elementAt(currentIndex),
        ),
      ),
    );
  }
}

class DateTimeEntry extends StatefulWidget {
  final String entryLabel;
  final String entry;
  final IconData icon;
  final DateTimePickerType entryType;
  final TextEditingController controller;

  const DateTimeEntry({
    required this.entry,
    required this.icon,
    required this.entryLabel,
    required this.entryType,
    required this.controller,
  });

  @override
  State<DateTimeEntry> createState() => _DateTimeEntryState();
}

class _DateTimeEntryState extends State<DateTimeEntry> {
  @override
  Widget build(BuildContext context) {
    return Container(
/*
      color: Colors.red,
*/
      height: 70,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 50,
            child: Icon(widget.icon),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                widget.entryLabel,
                style: GoogleFonts.ptSans(fontSize: 16, color: Colors.black),
              ),
              SizedBox(
                height: 5,
              ),
              SizedBox(
                height: 40,
                width: 90,
                child: Localizations(
                  delegates: [
                    GlobalMaterialLocalizations.delegate,
                    GlobalWidgetsLocalizations.delegate,
                    GlobalCupertinoLocalizations.delegate,
                  ],
                  locale: Locale('en', ''),
                  child: DateTimePicker(
                    controller: widget.controller,
                    type: widget.entryType,
                    dateLabelText: 'Date',
                    use24HourFormat: true,
                    locale: Locale('en', ''),
                    firstDate: DateTime.now(),
                    lastDate: DateTime.now().add(
                      Duration(days: 60),
                    ),
                    initialTime: TimeOfDay.now(),
                    style: GoogleFonts.ptSans(fontWeight: FontWeight.bold),
                    decoration: InputDecoration(
                      hintText: 'Select',
                      hintStyle:
                          GoogleFonts.ptSans(fontWeight: FontWeight.bold),
                      focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide.none,
                      ),
                      enabledBorder: UnderlineInputBorder(
                        borderSide: BorderSide.none,
                      ),
                    ),
                    onChanged: (val) {
                      setState(() {});
                      print(val);
                    },
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class LocationEntry extends StatelessWidget {
  final String entryLabel;
  final String entry;
  final VoidCallback onTap;
  final Color color;

  const LocationEntry({
    required this.entryLabel,
    required this.onTap,
    required this.entry,
    this.color = Colors.white,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      type: MaterialType.transparency,
      child: InkWell(
        onTap: onTap,
        child: Container(
          /*color: Colors.red,*/
          height: 50,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                entryLabel,
                style: GoogleFonts.ptSans(fontSize: 16, color: color),
              ),
              SizedBox(
                height: 5,
              ),
              Text(
                entry,
                style: GoogleFonts.ptSans(
                    fontSize: 16, color: color, fontWeight: FontWeight.bold),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
