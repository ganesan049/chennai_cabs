import 'package:date_time_picker/date_time_picker.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:testing_referral/elements/button.dart';
import 'package:testing_referral/elements/car_modes.dart';
import 'package:testing_referral/screens/review_screen.dart';
import 'map_screen.dart';
import 'navigator_screen.dart';

class OneWayTripScreen extends StatefulWidget {
  @override
  State<OneWayTripScreen> createState() => _OneWayTripScreenState();
}

class _OneWayTripScreenState extends State<OneWayTripScreen> {
  bool sedan = false;
  bool suv = false;
  String fromLocation = 'Choose location';
  String toLocation = 'Choose location';
  final TextEditingController dateController = TextEditingController();
  final TextEditingController timeController = TextEditingController();

  List<Widget> generate(double length) {
    return List.generate(
      (length / 5).floor(),
          (index) => SizedBox(
            height: 5,
            child: VerticalDivider(
              thickness: 2,
              color: index % 2 == 0? Colors.white : Colors.transparent,
            ),
          ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(40),
                bottomRight: Radius.circular(40),
              ),
            ),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Container(
                    height: 200,
                    margin: EdgeInsets.only(top: 15),
                    padding: EdgeInsets.only(right: 20),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(15),
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [
                          Colors.green,
                          Color(0xff57C84D),
                          Color(0xff83D475),
                        ],
                      ),
                    ),
                    child: Row(
                      children: [
                        Container(
                          width: 50,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.location_on_outlined,
                                color: Colors.white,
                              ),
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 8.0),
                                child: SizedBox(
                                  height: 50,
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: generate(50),
                                  ),
                                )
                              ),
                              Icon(
                                Icons.location_city_outlined,
                                color: Colors.white,
                              ),
                            ],
                          ),
                        ),
                        Expanded(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              LocationEntry(
                                onTap: () async {
                                  final inputLocation =
                                      await Navigator.pushNamed(
                                          context, MapScreen.mapScreen);
                                  if (inputLocation.toString().isNotEmpty &&
                                      inputLocation != null) {
                                    setState(() => fromLocation =
                                        inputLocation.toString());
                                  }
                                },
                                entryLabel: 'From',
                                entry: fromLocation,
                              ),
                              SizedBox(
                                height: 40,
                                child: Divider(
                                  color: Colors.white54,
                                ),
                              ),
                              LocationEntry(
                                onTap: () async {
                                  final inputLocation =
                                      await Navigator.pushNamed(
                                          context, MapScreen.mapScreen);
                                  if (inputLocation.toString().isNotEmpty &&
                                      inputLocation != null) {
                                    setState(() =>
                                        toLocation = inputLocation.toString());
                                  }
                                },
                                entryLabel: 'To',
                                entry: toLocation,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 30),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        DateTimeEntry(
                          controller: dateController,
                          entryType: DateTimePickerType.date,
                          icon: Icons.calendar_today_outlined,
                          entryLabel: 'Pickup date',
                          entry: '06 Oct 2021',
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 10.0),
                          child: SizedBox(
                            height: 50,
                            child: VerticalDivider(
                              thickness: 1.5,
                              color: Colors.grey,
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(right: 10.0),
                          child: DateTimeEntry(
                            controller: timeController,
                            entryType: DateTimePickerType.time,
                            icon: Icons.access_time,
                            entryLabel: 'Pickup time',
                            entry: 'Now',
                          ),
                        ),
                      ],
                    ),
                  ),
                  Text(
                    'Choose mode:',
                    style: GoogleFonts.ptSans(fontSize: 16),
                  ),
                  CarModes.sedan(
                    sedan,
                    () {
                      setState(
                        () {
                          if (sedan) {
                            sedan = false;
                          } else {
                            sedan = true;
                            suv = false;
                          }
                        },
                      );
                    },
                  ),
                  CarModes.suv(
                    suv,
                    () {
                      setState(
                        () {
                          if (suv) {
                            suv = false;
                          } else {
                            suv = true;
                            sedan = false;
                          }
                        },
                      );
                    },
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      vertical: 10.0,
                    ),
                    child: Button(
                      buttonText: 'Review your ride'.toUpperCase(),
                      onPress: () {
                        ReviewScreen.show(
                          context: context,
                          distance: '324 KM',
                          to: toLocation,
                          from: fromLocation,
                          carModes: sedan
                              ? CarModes.sedan(false, () => null)
                              : CarModes.suv(false, () => null),
                          pickUpDate: dateController.text,
                          pickUptime: timeController.text,
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
