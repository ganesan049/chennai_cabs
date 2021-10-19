import 'package:date_time_picker/date_time_picker.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:testing_referral/elements/button.dart';
import 'package:testing_referral/elements/car_modes.dart';
import 'package:testing_referral/screens/review_screen.dart';
import 'map_screen.dart';
import 'navigator_screen.dart';

class RoundTripScreen extends StatefulWidget {
  @override
  State<RoundTripScreen> createState() => _RoundTripScreenState();
}

class _RoundTripScreenState extends State<RoundTripScreen> {
  bool sedan = false;
  bool suv = false;
  bool van = false;
  String fromLocation = 'Choose location';
  String toLocation = 'Choose location';
  final TextEditingController pickUpDateController = TextEditingController();
  final TextEditingController pickUpTimeController = TextEditingController();
  final TextEditingController returnDateController = TextEditingController();
  final TextEditingController returnTimeController = TextEditingController();

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
                                  child: VerticalDivider(
                                    color: Colors.white,
                                  ),
                                ),
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
                                    setState(
                                      () =>
                                          toLocation = inputLocation.toString(),
                                    );
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
                    padding: const EdgeInsets.only(top: 30, bottom: 10),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        DateTimeEntry(
                          controller: pickUpDateController,
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
                            controller: pickUpTimeController,
                            entryType: DateTimePickerType.time,
                            icon: Icons.access_time,
                            entryLabel: 'Pickup time',
                            entry: 'Now',
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 5,
                    child: Divider(
                      thickness: 1.5,
                      indent: 50,
                      endIndent: 50,
                      color: Colors.grey,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 30, top: 10),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        DateTimeEntry(
                          controller: returnDateController,
                          entryType: DateTimePickerType.date,
                          icon: Icons.calendar_today_outlined,
                          entryLabel: 'Return date',
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
                            controller: returnTimeController,
                            entryType: DateTimePickerType.time,
                            icon: Icons.access_time,
                            entryLabel: 'Return time',
                            entry: 'Now',
                          ),
                        ),
                      ],
                    ),
                  ),
                  Text(
                    'Choose mode',
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
                            van = false;
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
                            van = false;
                          }
                        },
                      );
                    },
                  ),
                  CarModes.van(
                    van,
                    () {
                      setState(
                        () {
                          if (van) {
                            van = false;
                          } else {
                            van = true;
                            sedan = false;
                            suv = false;
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
                      buttonText: 'Generate fare'.toUpperCase(),
                      onPress: () {
                        ReviewScreen.show(
                          context: context,
                          distance: '324 KM',
                          to: toLocation,
                          from: fromLocation,
                          carModes: sedan
                              ? CarModes.sedan(false, () => null)
                              : suv
                                  ? CarModes.suv(false, () => null)
                                  : CarModes.van(false, () => null),
                          roundTrip: true,
                          pickUpDate: pickUpDateController.text,
                          pickUptime: pickUpTimeController.text,
                          returnDate: returnDateController.text,
                          returnTime: returnTimeController.text,
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
