import 'package:date_time_picker/date_time_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:testing_referral/elements/button.dart';
import 'package:testing_referral/elements/car_modes.dart';
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
  bool sedan = false;
  bool suv = false;
  String dropdownValue = 'One';

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
                      'Pickup address:',
                      style: GoogleFonts.ptSans(fontSize: 16),
                    ),
                  ),
                  TextField(
                    decoration: InputDecoration(
                      hintText: 'Enter your address here',
                      suffixIcon: IconButton(
                        onPressed: () {},
                        icon: Icon(
                          Icons.location_searching,
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
                      'Rental package:',
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
                        value: dropdownValue,
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
                          setState(() => dropdownValue = newValue!);
                        },
                        items: <String>['One', 'Two', 'Free', 'Four']
                            .map<DropdownMenuItem<String>>(
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
                      fare: '7',
                      selected: sedan,
                      noOfPerson: '5',
                      carType: 'Sedan',
                      imagePath: 'images/sedan.png'),
                  CarModes(
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
                    fare: '9',
                    selected: suv,
                    noOfPerson: '8',
                    carType: 'SUV',
                    imagePath: 'images/suv.png',
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      vertical: 10.0,
                    ),
                    child: Button(
                      buttonText: 'Review your ride'.toUpperCase(),
                      onPress: () {
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
