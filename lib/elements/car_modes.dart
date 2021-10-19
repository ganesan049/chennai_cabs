import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:testing_referral/network/database.dart';

class CarModes extends StatelessWidget {
  final String imagePath;
  final String noOfPerson;
  final String carType;
  final String carFare;
  final bool selected;
  final String tripType;
  final VoidCallback onTap;
  final bool loading;
  final int tripFare;

  const CarModes({
    this.carFare = '',
    required this.carType,
    required this.noOfPerson,
    this.selected = false,
    required this.onTap,
    this.tripType = '',
    this.tripFare = 0,
    required this.imagePath,
    this.loading = false,
  });

  static final String oneWay = 'one_way';
  static final String roundWay = 'round_way';

  static CarModes sedan(
      {required bool selected,
      required VoidCallback onTap,
      required bool loading,
      required int tripFare,
      required String tripType}) {
    return CarModes(
        selected: selected,
        loading: loading,
        carType: 'Sedan',
        noOfPerson: '4',
        tripFare: tripFare,
        tripType: tripType,
        onTap: onTap,
        imagePath: 'images/sedan.png');
  }

  static CarModes suv(
      {required bool selected,
      required VoidCallback onTap,
      required bool loading,
      required int tripFare,
      required String tripType}) {
    return CarModes(
        selected: selected,
        loading: loading,
        carType: 'SUV',
        noOfPerson: '7',
        tripFare: tripFare,
        tripType: tripType,
        onTap: onTap,
        imagePath: 'images/suv.png');
  }

  static CarModes suvPlus(
      {required bool selected,
        required VoidCallback onTap,
        required bool loading,
        required int tripFare,
        required String tripType}) {
    return CarModes(
        selected: selected,
        loading: loading,
        carType: 'SUV+',
        noOfPerson: '8',
        tripFare: tripFare,
        tripType: tripType,
        onTap: onTap,
        imagePath: 'images/suv_plus.png');
  }

  static CarModes executive(
      {required bool selected,
      required VoidCallback onTap,
      required bool loading,
      required int tripFare,
      required String tripType}) {
    return CarModes(
        selected: selected,
        loading: loading,
        carType: 'Executive',
        noOfPerson: '8',
        tripFare: tripFare,
        tripType: tripType,
        onTap: onTap,
        imagePath: 'images/executive.png');
  }

  static CarModes tempo(
      {required bool selected,
      required VoidCallback onTap,
      required bool loading,
      required String tripType,
      required int tripFare}) {
    return CarModes(
        selected: selected,
        loading: loading,
        carType: 'Tempo',
        tripFare: tripFare,
        tripType: tripType,
        noOfPerson: '12',
        onTap: onTap,
        imagePath: 'images/van.png');
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 20),
      child: Material(
        elevation: 3,
        color: Colors.grey.shade100,
        borderRadius: BorderRadius.circular(20),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(20),
          child: Container(
            decoration: BoxDecoration(
              color: selected ? Colors.green : Colors.transparent,
              borderRadius: BorderRadius.circular(20),
            ),
            padding: EdgeInsets.all(3),
            child: Material(
              color: Colors.grey.shade100,
              borderRadius: BorderRadius.circular(20),
              child: SizedBox(
                height: 110,
                child: Column(
                  children: [
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 15.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Image.asset(
                              imagePath,
                              height: 250,
                              width: 100,
                            ),
                            loading
                                ? SizedBox(
                                    height: 10,
                                    width: 10,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2,
                                      valueColor:
                                          AlwaysStoppedAnimation(Colors.black),
                                    ),
                                  )
                                : tripFare != 0
                                    ? Text(
                                        '₹$tripFare',
                                        style: GoogleFonts.ubuntu(
                                            fontSize: 15,
                                            fontWeight: FontWeight.bold),
                                      )
                                    : carFare.isEmpty? FutureBuilder(
                                        future: Database.getCarFare(
                                            tripType, carType.toLowerCase()),
                                        builder: (context, fare) {
                                          if (fare.hasData) {
                                            return SizedBox(
                                              width: 100,
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.end,
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.baseline,
                                                textBaseline:
                                                    TextBaseline.alphabetic,
                                                children: [
                                                  Text(
                                                    '₹${fare.data}',
                                                    style: GoogleFonts.ubuntu(
                                                        fontSize: 17,
                                                        fontWeight:
                                                            FontWeight.bold),
                                                  ),
                                                  Text(
                                                    '/km',
                                                    style: GoogleFonts.ubuntu(
                                                        fontSize: 12,
                                                        fontWeight:
                                                            FontWeight.bold),
                                                  ),
                                                ],
                                              ),
                                            );
                                          } else {
                                            return SizedBox(
                                              height: 10,
                                              width: 10,
                                              child: CircularProgressIndicator(
                                                strokeWidth: 2,
                                                valueColor:
                                                    AlwaysStoppedAnimation(
                                                        Colors.black),
                                              ),
                                            );
                                          }
                                        },
                                      ): Container(),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 30,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Expanded(
                            flex: 2,
                            child: Tooltip(
                              message: carInfo(carType),
                              triggerMode: TooltipTriggerMode.tap,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    Icons.info_outline,
                                    size: 18,
                                  ),
                                  Text(
                                    ' info',
                                    style: GoogleFonts.sourceSansPro(
                                        fontWeight: FontWeight.bold),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          Expanded(
                            flex: 3,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.directions_car,
                                  size: 18,
                                ),
                                Text(
                                  ' $carType',
                                  style: GoogleFonts.sourceSansPro(
                                      fontWeight: FontWeight.bold),
                                ),
                              ],
                            ),
                          ),
                          Expanded(
                            flex: 3,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.people,
                                  size: 18,
                                ),
                                Text(
                                  ' $noOfPerson person',
                                  style: GoogleFonts.sourceSansPro(
                                      fontWeight: FontWeight.bold),
                                ),
                              ],
                            ),
                          ),
                          Expanded(
                            flex: 2,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.ac_unit,
                                  size: 18,
                                ),
                                Text(
                                  ' AC',
                                  style: GoogleFonts.sourceSansPro(
                                      fontWeight: FontWeight.bold),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  String carInfo(String carType){
    if (carType.toLowerCase() == 'sedan'){
      return 'Swift Dzire';
    }
   else if (carType.toLowerCase() == 'suv'){
      return 'Mahindra Xylo';
    }
    else if (carType.toLowerCase() == 'suv+'){
      return 'Toyota Innova';
    }
    else if (carType.toLowerCase() == 'executive'){
      return 'Toyota Innova Crysta';
    }
    else{
      return 'Force';
    }
  }

}
