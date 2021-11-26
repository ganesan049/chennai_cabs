import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:cached_network_image/cached_network_image.dart';

class CarModesCard extends StatelessWidget {
  final String imageURL;
  final String noOfPerson;
  final String carType;
  final String carFare;
  final bool selected;
  final String tripType;
  final VoidCallback onTap;
  final bool loading;
  final List carNames;
  final int tripFare;

  const CarModesCard({
    this.carFare = '',
    required this.carType,
    required this.noOfPerson,
    this.selected = false,
    required this.onTap,
    this.tripType = '',
    this.tripFare = 0,
    required this.imageURL,
    this.loading = false,
    required this.carNames,
  });

  static final String oneWay = 'one_way';
  static final String roundWay = 'round_way';

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 20),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(20),
        child: Container(
          decoration: BoxDecoration(
            color: selected ? Colors.green : Colors.transparent,
            borderRadius: BorderRadius.circular(20),
          ),
          padding: EdgeInsets.all(2.5),
          child: Material(
            elevation: 3,
            borderRadius: BorderRadius.circular(20),
            child: Container(
              height: 130,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
              ),
              child: Material(
                elevation: 3,
                color: Colors.grey.shade100,
                borderRadius: BorderRadius.circular(20),
                child: SizedBox(
                  height: 130,
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(top: 8.0, left: 10),
                        child: Text(
                          carNames.join(),
                          style:
                              GoogleFonts.ptSans(fontWeight: FontWeight.bold),
                        ),
                      ),
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 15.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              CachedNetworkImage(
                                height: 250,
                                width: 100,
                                imageUrl: imageURL,
                                placeholder: (context, none) => SizedBox(
                                  height: 10,
                                  width: 10,
                                  child: Center(
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2,
                                      valueColor: AlwaysStoppedAnimation(Colors.black),
                                    ),
                                  ),
                                ),
                                errorWidget: (context, object, stacktrace) =>
                                    SizedBox(
                                  height: 40,
                                  width: 50,
                                  child: Center(
                                    child: Icon(Icons.broken_image),
                                  ),
                                ),
                              ),
                              loading
                                  ? SizedBox(
                                      height: 10,
                                      width: 10,
                                      child: CircularProgressIndicator(
                                        strokeWidth: 2,
                                        valueColor: AlwaysStoppedAnimation(
                                            Colors.black),
                                      ),
                                    )
                                  : tripFare != 0
                                      ? Text(
                                          '₹$tripFare',
                                          style: GoogleFonts.ubuntu(
                                              fontSize: 15,
                                              fontWeight: FontWeight.bold),
                                        )
                                      : SizedBox(
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
                                                '₹$carFare',
                                                style: GoogleFonts.ubuntu(
                                                    fontSize: 18,
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
                                        ),
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
      ),
    );
  }
}
