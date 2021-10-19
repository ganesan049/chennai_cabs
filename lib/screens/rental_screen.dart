import 'package:date_time_picker/date_time_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:testing_referral/elements/button.dart';
import 'package:testing_referral/elements/car_modes.dart';
import 'package:testing_referral/network/database.dart';
import 'package:testing_referral/network/location.dart';
import 'package:testing_referral/screens/review_screen.dart';
import 'navigator_screen.dart';

class RentalScreen extends StatefulWidget {
  const RentalScreen({Key? key}) : super(key: key);

  @override
  State<RentalScreen> createState() => _RentalScreenState();
}

class _RentalScreenState extends State<RentalScreen> {
  final TextEditingController dateController = TextEditingController();
  final TextEditingController timeController = TextEditingController();
  final ReviewScreen reviewScreen = ReviewScreen();
  bool sedan = false;
  bool suv = false;
  bool tripFareLoading = false;
  int sedanTripFare = 0;
  int suvTripFare = 0;
  final TextEditingController pickUpLocationController =
      TextEditingController();
  String dropdownValueDuration = '---Select hours---';
  String dropdownValueDistance = '---Select distance---';

  @override
  void initState() {
    myLocation();
    super.initState();
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
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 10.0),
                    child: Text(
                      'Pickup location:',
                      style: GoogleFonts.ptSans(fontSize: 16),
                    ),
                  ),
                  Container(),
                  TextField(
                    controller: pickUpLocationController,
                    style: GoogleFonts.ptSans(fontWeight: FontWeight.bold),
                    decoration: InputDecoration(
                      hintText: 'Enter your address here',
                      suffixIcon: IconButton(
                        onPressed: () {},
                        icon: Icon(
                          Icons.pin_drop_outlined,
                          color: Colors.grey,
                        ),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.zero,
                        borderSide: BorderSide(color: Colors.grey),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.zero,
                        borderSide: BorderSide(color: Colors.grey),
                      ),
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
                  Padding(
                    padding: const EdgeInsets.only(bottom: 10.0),
                    child: Text(
                      'Distance:',
                      style: GoogleFonts.ptSans(fontSize: 16),
                    ),
                  ),
                  Container(
                    height: 60,
                    margin: const EdgeInsets.only(bottom: 20.0),
                    padding: EdgeInsets.symmetric(horizontal: 10),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey),
                    ),
                    child: Center(
                      child: DropdownButton<String>(
                        value: dropdownValueDistance,
                        iconSize: 24,
                        elevation: 16,
                        isExpanded: true,
                        style: GoogleFonts.ptSans(
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                            fontSize: 15),
                        underline: Container(
                          height: 0,
                        ),
                        onChanged: (String? newValue) {
                          setState(() => dropdownValueDistance = newValue!);
                          getTripFare();
                        },
                        items: <String>[
                          '---Select distance---',
                          '30 km',
                          '40 km',
                          '50 km',
                          '60 km',
                          '70 km',
                          '80 km',
                          '90 km',
                          '100 km',
                          '150 km'
                        ].map<DropdownMenuItem<String>>(
                          (String value) {
                            return DropdownMenuItem<String>(
                              value: value,
                              child: Text(value),
                            );
                          },
                        ).toList(),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 10.0),
                    child: Text(
                      'Duration:',
                      style: GoogleFonts.ptSans(fontSize: 16),
                    ),
                  ),
                  Container(
                    height: 60,
                    margin: const EdgeInsets.only(bottom: 20.0),
                    padding: EdgeInsets.symmetric(horizontal: 10),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey),
                    ),
                    child: Center(
                      child: DropdownButton<String>(
                        value: dropdownValueDuration,
                        iconSize: 24,
                        elevation: 16,
                        isExpanded: true,
                        style: GoogleFonts.ptSans(
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                            fontSize: 15),
                        underline: Container(
                          height: 0,
                        ),
                        onChanged: (String? newValue) {
                          setState(() => dropdownValueDuration = newValue!);
                          getTripFare();
                        },
                        items: <String>[
                          '---Select hours---',
                          '5 hrs',
                          '6 hrs',
                          '7 hrs',
                          '8 hrs',
                          '9 hrs',
                          '10 hrs',
                          '11 hrs',
                          '12 hrs',
                          '13 hrs',
                          '14 hrs',
                          '15 hrs',
                          '24 hrs'
                        ].map<DropdownMenuItem<String>>(
                          (String value) {
                            return DropdownMenuItem<String>(
                              value: value,
                              child: Text(value),
                            );
                          },
                        ).toList(),
                      ),
                    ),
                  ),
                  Text(
                    'Choose mode',
                    style: GoogleFonts.ptSans(fontSize: 16),
                  ),
                  CarModes(
                    carFare: '7',
                    selected: sedan,
                    loading: tripFareLoading,
                    noOfPerson: '5',
                    carType: 'Sedan',
                    tripFare: sedanTripFare,
                    imagePath: 'images/sedan.png',
                    onTap: () {
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
                  CarModes(
                    carFare: '9',
                    selected: suv,
                    noOfPerson: '8',
                    loading: tripFareLoading,
                    carType: 'SUV',
                    tripFare: suvTripFare,
                    imagePath: 'images/suv.png',
                    onTap: () {
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
                      onPress: review,
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

  void review() {
    if (pickUpLocationController.text.isNotEmpty &&
        dateController.text.isNotEmpty &&
        timeController.text.isNotEmpty &&
        dropdownValueDistance != '---Select distance---' &&
        dropdownValueDuration != '---Select hours---' &&
        (suv || sedan)) {
      reviewScreen.showForRental(
          context: context,
          pickUpAddress: pickUpLocationController.text,
          totalFare: suv ? suvTripFare : sedanTripFare,
          carModes: sedan
              ? CarModes(
            carFare: '7',
            selected: sedan,
            loading: false,
            noOfPerson: '5',
            carType: 'Sedan',
            tripFare: 0,
            imagePath: 'images/sedan.png',
            onTap: () => null)
              : CarModes(
            carFare: '9',
            selected: suv,
            noOfPerson: '8',
            loading: false,
            carType: 'SUV',
            tripFare: 0,
            imagePath: 'images/suv.png',
            onTap: () => null,
          ),
          onTap: () {},
          pickUpDate: dateController.text,
          pickUptime: timeController.text,
          distance: dropdownValueDistance,
          duration: dropdownValueDuration);
    }
  }

  void bookYourRide(){

  }

  void myLocation() async {
    final Map locationDetails = await Location.myLocation(false);
    setState(() =>
        pickUpLocationController.text = locationDetails[Location.location]);
  }

  void getTripFare() async {
    if (dropdownValueDistance != '---Select distance---' &&
        dropdownValueDuration != '---Select hours---') {
      setState(() => tripFareLoading = true);
      final Map fareDetails = await Database.getTripFareRental(
        distance: int.parse(dropdownValueDistance.split(' ')[0]),
        duration: int.parse(dropdownValueDuration.split(' ')[0]),
      );
      tripFareLoading = false;
      setState(
        () {
          sedanTripFare = fareDetails['sedan'];
          suvTripFare = fareDetails['suv'];
        },
      );
    }
  }
}
