import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class CarModes extends StatelessWidget {
  final String imagePath;
  final String noOfPerson;
  final String carType;
  final String fare;
  final bool selected;
  final VoidCallback onTap;

  const CarModes({
    required this.fare,
    required this.carType,
    required this.noOfPerson,
    this.selected = false,
    required this.onTap,
    required this.imagePath,
  });

  static CarModes sedan(bool selected, VoidCallback onTap){
    return CarModes(
        fare: 'fare',
        selected: selected,
        carType: 'Sedan',
        noOfPerson: '5',
        onTap: onTap,
        imagePath: 'images/sedan.png');
  }

  static CarModes suv(bool selected, VoidCallback onTap){
    return CarModes(
        fare: 'fare',
        selected: selected,
        carType: 'SUV',
        noOfPerson: '8',
        onTap: onTap,
        imagePath: 'images/suv.png');
  }

  static CarModes van(bool selected, VoidCallback onTap){
    return CarModes(
        fare: 'fare',
        selected: selected,
        carType: 'Van',
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
                            SizedBox(
                              height: 10,
                              width: 10,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                valueColor: AlwaysStoppedAnimation(Colors.black),
                              ),
                            ),
                            /*Text(
                              '₹$fare/km',
                              style: GoogleFonts.ubuntu(
                                  fontSize: 15, fontWeight: FontWeight.bold),
                            ),*/
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
}
