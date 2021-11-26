import 'package:date_time_picker/date_time_picker.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:testing_referral/elements/button.dart';
import 'package:testing_referral/elements/car_modes_card.dart';
import 'package:testing_referral/elements/car_modes_loading_card.dart';
import 'package:testing_referral/elements/date_time_entry.dart';
import 'package:testing_referral/elements/location_entry.dart';
import 'package:testing_referral/network/database.dart';
import 'package:testing_referral/network/location.dart';
import 'package:testing_referral/operations/operations.dart';
import 'package:testing_referral/screens/review_screen.dart';
import 'booking_confirmation_screen.dart';
import 'map_screen.dart';

class RoundTripScreen extends StatefulWidget {
  @override
  State<RoundTripScreen> createState() => _RoundTripScreenState();
}

class _RoundTripScreenState extends State<RoundTripScreen>
    with SingleTickerProviderStateMixin {
  String selected = '';
  String fromLocation = 'Choose location';
  String toLocation = 'Choose location';
  String fromLocationID = '';
  String toLocationID = '';
  bool fareLoading = false;
  bool reviewLoading = false;
  bool useRewardPoints = false;
  String distance = '';
  int selectedBaseFare = 0;
  int selectedDriverFee = 0;
  int selectedTotalFare = 0;
  int rewardPoints = 0;
  double myLat = 0;
  double myLng = 0;
  final ReviewScreen reviewScreen = ReviewScreen();
  final TextEditingController pickUpDateController = TextEditingController();
  final TextEditingController pickUpTimeController = TextEditingController();
  final TextEditingController returnDateController = TextEditingController();
  late AnimationController animationController;

  @override
  void initState() {
    myLocation();

    animationController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 300),
    );

    super.initState();
  }

  @override
  void dispose() {
    animationController.dispose();
    pickUpDateController.dispose();
    pickUpTimeController.dispose();
    returnDateController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.bottomCenter,
      children: [
        Column(
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
                child: ListView(
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
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: Operations.generateDottedLines(
                                          50, Colors.white, 2),
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
                                  onTap: () => openMap(true),
                                  entryLabel: 'From',
                                  entry: fromLocation,
                                  loadingIndicator: true,
                                ),
                                SizedBox(
                                  height: 40,
                                  child: Divider(
                                    color: Colors.white54,
                                  ),
                                ),
                                LocationEntry(
                                  onTap: () => openMap(false),
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
                      padding: const EdgeInsets.only(top: 40, bottom: 20),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            children: [
                              DateTimeEntry(
                                controller: pickUpDateController,
                                entryType: DateTimePickerType.date,
                                icon: Icons.calendar_today_outlined,
                                entryLabel: 'Pickup date',
                                entry: '06 Oct 2021',
                                onChange: (input) {
                                  getDistance();
                                  returnDateController.clear();
                                  checkRequiredFields(true);
                                },
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              DateTimeEntry(
                                controller: returnDateController,
                                entryType: DateTimePickerType.date,
                                icon: Icons.calendar_today_outlined,
                                entryLabel: 'Return date',
                                entry: '06 Oct 2021',
                                tripStartDate:
                                    pickUpDateController.text.isNotEmpty
                                        ? pickUpDateController.text
                                        : null,
                                onChange: (input) {
                                  getDistance();
                                  checkRequiredFields(true);
                                },
                              ),
                            ],
                          ),
                          Padding(
                            padding: const EdgeInsets.only(left: 10.0),
                            child: SizedBox(
                              height: 130,
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
                              onChange: (input) => checkRequiredFields(true),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Text(
                      'Choose mode:',
                      style: GoogleFonts.ptSans(fontSize: 16),
                    ),
                    FutureBuilder<List<Map>>(
                      future: Database.getCarModes('round_way'),
                      builder: (context, cars) {
                        if (cars.hasData) {
                          return Column(
                            children: List.generate(
                              cars.data!.length,
                              (index) => Padding(
                                padding: EdgeInsets.only(
                                    bottom: index == cars.data!.length - 1
                                        ? 60.0
                                        : 0),
                                child: CarModesCard(
                                  loading: fareLoading,
                                  carNames: cars.data!.elementAt(index)['info'],
                                  tripFare: distance.isNotEmpty &&
                                          pickUpDateController
                                              .text.isNotEmpty &&
                                          returnDateController.text.isNotEmpty
                                      ? tripFare(
                                          distance: distance,
                                          noOfDays: Operations.getNoOfDays(
                                              pickUpDateController.text,
                                              returnDateController.text),
                                          driverFee: cars.data!
                                              .elementAt(index)['driver_fee'],
                                          carFare: cars.data!
                                              .elementAt(index)['fare'],
                                        )['total_fare']!
                                      : 0,
                                  selected: selected ==
                                          cars.data!.elementAt(index)['name']
                                      ? true
                                      : false,
                                  carType: cars.data!.elementAt(index)['name'],
                                  carFare: cars.data!
                                      .elementAt(index)['fare']
                                      .toString(),
                                  noOfPerson: cars.data!
                                      .elementAt(index)['no_of_persons']
                                      .toString(),
                                  onTap: () => setState(
                                    () {
                                      selectedBaseFare = tripFare(
                                        distance: distance,
                                        noOfDays: pickUpDateController
                                                    .text.isNotEmpty &&
                                                returnDateController
                                                    .text.isNotEmpty
                                            ? Operations.getNoOfDays(
                                                pickUpDateController.text,
                                                returnDateController.text)
                                            : 0,
                                        driverFee: cars.data!
                                            .elementAt(index)['driver_fee'],
                                        carFare:
                                            cars.data!.elementAt(index)['fare'],
                                      )['base_fare']!;
                                      selectedDriverFee = pickUpDateController
                                                  .text.isNotEmpty &&
                                              returnDateController
                                                  .text.isNotEmpty
                                          ? cars.data!.elementAt(
                                                  index)['driver_fee'] *
                                              Operations.getNoOfDays(
                                                  pickUpDateController.text,
                                                  returnDateController.text)
                                          : 0;
                                      selectedTotalFare = tripFare(
                                        distance: distance,
                                        noOfDays: pickUpDateController
                                                    .text.isNotEmpty &&
                                                returnDateController
                                                    .text.isNotEmpty
                                            ? Operations.getNoOfDays(
                                                pickUpDateController.text,
                                                returnDateController.text)
                                            : 0,
                                        driverFee: cars.data!
                                            .elementAt(index)['driver_fee'],
                                        carFare:
                                            cars.data!.elementAt(index)['fare'],
                                      )['total_fare']!;
                                      selected ==
                                              cars.data!
                                                  .elementAt(index)['name']
                                          ? selected = ''
                                          : selected = cars.data!
                                              .elementAt(index)['name'];
                                      checkRequiredFields(false);
                                    },
                                  ),
                                  imageURL:
                                      cars.data!.elementAt(index)['image_url'],
                                ),
                              ),
                            ),
                          );
                        } else {
                          return Column(
                            children: List.generate(
                              5,
                              (index) => CarModesLoadingCard(),
                            ),
                          );
                        }
                      },
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: SlideTransition(
            position: Tween<Offset>(
              begin: Offset(0, 2),
              end: Offset(0, -0.35),
            ).animate(
              CurvedAnimation(
                  parent: animationController, curve: Curves.easeInOutBack),
            ),
            child: Button(
              loading: reviewLoading,
              buttonText: 'Review your ride'.toUpperCase(),
              onPress: review,
            ),
          ),
        ),
      ],
    );
  }

  Map<String, int> tripFare(
      {required String distance,
      required int carFare,
      required int driverFee,
      required int noOfDays}) {
    int formattedDistance =
        Operations.getFormattedDistance(distance) / noOfDays > 250
            ? Operations.getFormattedDistance(distance)
            : 250 * noOfDays;
    return {
      'base_fare': (formattedDistance * carFare),
      'total_fare': (formattedDistance * carFare) + driverFee,
    };
  }

  void checkRequiredFields(bool changeInFields) {
    if (changeInFields) {
      setState(() => selected = '');
    }
    if (fromLocationID.isNotEmpty &&
        toLocationID.isNotEmpty &&
        pickUpDateController.text.isNotEmpty &&
        pickUpTimeController.text.isNotEmpty &&
        returnDateController.text.isNotEmpty &&
        selected.isNotEmpty) {
      animationController.forward();
    } else {
      animationController.reverse();
    }
  }

  void myLocation() async {
    final Map myLocationDetails = await Location.myLocation(false);
    final Map myLatLng = await Location.myLocation(true);
    if (mounted) {
      setState(
        () {
          myLat = myLatLng[Location.lat];
          myLng = myLatLng[Location.lng];
          fromLocation = myLocationDetails[Location.location];
          fromLocationID = myLocationDetails[Location.locationID];
        },
      );
    }
  }

  void openMap(bool forFromLocation) async {
    final locationDetails = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => MapScreen(
          lat: myLat,
          lng: myLng,
        ),
      ),
    ) as Map<String, String>;
    if (locationDetails.isNotEmpty) {
      setState(
        () {
          if (forFromLocation) {
            fromLocation = locationDetails[Location.location]!;
            fromLocationID = locationDetails[Location.locationID]!;
          } else {
            toLocation = locationDetails[Location.location]!;
            toLocationID = locationDetails[Location.locationID]!;
          }
        },
      );
      checkRequiredFields(true);
    }
    getDistance();
  }

  void getDistance() async {
    if (fromLocationID.isNotEmpty &&
        toLocationID.isNotEmpty &&
        pickUpDateController.text.isNotEmpty &&
        returnDateController.text.isNotEmpty) {
      setState(() => fareLoading = true);
      final String dist =
          await Location.getDistance(fromLocationID, toLocationID);
      setState(
        () {
          fareLoading = false;
          distance = Operations.multiplyDistance(dist);
        },
      );
    }
  }

  void bookYourRide() async {
    reviewScreen.loadingUpdate();
    bool rideCheck = await Operations.rideTimeCheck(
        context, pickUpTimeController.text, pickUpDateController.text);
    if (rideCheck) {
      await Database.addNewTrip(
        from: fromLocation,
        to: toLocation,
        fromId: fromLocationID,
        toId: toLocationID,
        tripStartDate: pickUpDateController.text,
        distance: distance,
        rewardPoints: rewardPoints,
        driverFee: selectedDriverFee,
        carMode: selected,
        useRewardPoints: useRewardPoints,
        tripStartTime: pickUpTimeController.text,
        tripType: CarModesCard.roundWay,
        tripReturnDate: returnDateController.text,
        bookingDate: DateTime.now().toString().split(' ')[0],
        baseFare: selectedBaseFare,
      );
      Navigator.pushReplacementNamed(
          context, BookingConfirmationScreen.bookingConfirmationScreen);
    } else {
      reviewScreen.loadingUpdate();
    }
  }

  void review() async {
    setState(() => reviewLoading = true);
    final int points = await Database.getRefPoints();
    rewardPoints = points;
    setState(() => reviewLoading = false);
    reviewScreen.show(
        context: context,
        rewardPoints: rewardPoints,
        selectedCarMode: selected,
        baseFare: selectedBaseFare,
        driverFee: selectedDriverFee,
        totalFare: selectedTotalFare,
        distance: distance,
        to: toLocation,
        from: fromLocation,
        roundTrip: true,
        pickUpDate: pickUpDateController.text,
        pickUptime: pickUpTimeController.text,
        returnDate: returnDateController.text,
        rewardPointsUsage: (usage) => setState(() => useRewardPoints = usage),
        onTap: bookYourRide);
  }
}
