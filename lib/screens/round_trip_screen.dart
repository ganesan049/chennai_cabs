import 'package:date_time_picker/date_time_picker.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:testing_referral/elements/button.dart';
import 'package:testing_referral/elements/car_modes.dart';
import 'package:testing_referral/network/database.dart';
import 'package:testing_referral/network/location.dart';
import 'package:testing_referral/operations/operations.dart';
import 'package:testing_referral/screens/review_screen.dart';
import 'map_screen.dart';
import 'navigator_screen.dart';

class RoundTripScreen extends StatefulWidget {
  @override
  State<RoundTripScreen> createState() => _RoundTripScreenState();
}

class _RoundTripScreenState extends State<RoundTripScreen>
    with SingleTickerProviderStateMixin {
  bool sedanSelected = false;
  bool suvSelected = false;
  bool tempoSelected = false;
  bool executiveSelected = false;
  bool suvPlusSelected = false;
  String fromLocation = 'Choose location';
  String toLocation = 'Choose location';
  String fromLocationID = '';
  String toLocationID = '';
  bool fareLoading = false;
  String distance = '';
  int sedanBaseFare = 0;
  int suvBaseFare = 0;
  int suvPlusBaseFare = 0;
  int executiveBaseFare = 0;
  int tempoBaseFare = 0;
  int sedanTotalFare = 0;
  int suvTotalFare = 0;
  int suvPlusTotalFare = 0;
  int executiveTotalFare = 0;
  int tempoTotalFare = 0;
  int suvPlusDriverFee = 0;
  int executiveDriverFee = 0;
  int tempoDriverFee = 0;
  double myLat = 0;
  double myLng = 0;
  final ReviewScreen reviewScreen = ReviewScreen();
  final TextEditingController pickUpDateController = TextEditingController();
  final TextEditingController pickUpTimeController = TextEditingController();
  final TextEditingController returnDateController = TextEditingController();
  late AnimationController slideAnimationController;

  @override
  void initState() {
    myLocation();

    slideAnimationController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 300),
    );

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
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
                                  onTap: () => openMap(true),
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
                                  loadFare();
                                  checkRequiredFields();
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
                                onChange: (input) {
                                  loadFare();
                                  checkRequiredFields();
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
                              onChange: (input) => checkRequiredFields(),
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
                      tripFare: sedanTotalFare,
                      selected: sedanSelected,
                      loading: fareLoading,
                      tripType: CarModes.roundWay,
                      onTap: () => setState(
                        () {
                          if (sedanSelected) {
                            sedanSelected = false;
                          } else {
                            sedanSelected = true;
                            suvSelected = false;
                            tempoSelected = false;
                            executiveSelected = false;
                            suvPlusSelected = false;
                          }
                          checkRequiredFields();
                        },
                      ),
                    ),
                    CarModes.suv(
                      tripFare: suvTotalFare,
                      selected: suvSelected,
                      loading: fareLoading,
                      tripType: CarModes.roundWay,
                      onTap: () => setState(
                        () {
                          if (suvSelected) {
                            suvSelected = false;
                          } else {
                            suvSelected = true;
                            sedanSelected = false;
                            tempoSelected = false;
                            executiveSelected = false;
                            suvPlusSelected = false;
                          }
                          checkRequiredFields();
                        },
                      ),
                    ),
                    CarModes.suvPlus(
                      tripFare: suvPlusTotalFare,
                      selected: suvPlusSelected,
                      loading: fareLoading,
                      tripType: CarModes.roundWay,
                      onTap: () => setState(
                        () {
                          if (suvPlusSelected) {
                            suvPlusSelected = false;
                          } else {
                            suvPlusSelected = true;
                            suvSelected = false;
                            sedanSelected = false;
                            tempoSelected = false;
                            executiveSelected = false;
                          }
                          checkRequiredFields();
                        },
                      ),
                    ),
                    CarModes.executive(
                      selected: executiveSelected,
                      loading: fareLoading,
                      tripFare: executiveTotalFare,
                      tripType: CarModes.roundWay,
                      onTap: () => setState(
                        () {
                          if (executiveSelected) {
                            executiveSelected = false;
                          } else {
                            executiveSelected = true;
                            sedanSelected = false;
                            suvSelected = false;
                            tempoSelected = false;
                            suvPlusSelected = false;
                          }
                          checkRequiredFields();
                        },
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(bottom: 60.0),
                      child: CarModes.tempo(
                        selected: tempoSelected,
                        loading: fareLoading,
                        tripFare: tempoTotalFare,
                        tripType: CarModes.roundWay,
                        onTap: () => setState(
                          () {
                            if (tempoSelected) {
                              tempoSelected = false;
                            } else {
                              tempoSelected = true;
                              sedanSelected = false;
                              suvSelected = false;
                              executiveSelected = false;
                              suvPlusSelected = false;
                            }
                            checkRequiredFields();
                          },
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
        SlideTransition(
          position: Tween<Offset>(
            begin: Offset(0, MediaQuery.of(context).size.height / 57.1),
            end: Offset(0, MediaQuery.of(context).size.height / 67.5),
          ).animate(
            CurvedAnimation(
                parent: slideAnimationController, curve: Curves.easeInOutBack),
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 20.0,
            ),
            child: Button(
              buttonText: 'Review your ride'.toUpperCase(),
              onPress: review,
            ),
          ),
        ),
      ],
    );
  }

  void checkRequiredFields() {
    if (fromLocationID.isNotEmpty &&
        toLocationID.isNotEmpty &&
        pickUpDateController.text.isNotEmpty &&
        pickUpTimeController.text.isNotEmpty &&
        returnDateController.text.isNotEmpty &&
        (suvSelected ||
            sedanSelected ||
            suvPlusSelected ||
            executiveSelected ||
            tempoSelected)) {
      slideAnimationController.forward();
    } else {
      slideAnimationController.reverse();
    }
  }

  void myLocation() async {
    final Map myLocationDetails = await Location.myLocation(false);
    final Map myLatLng = await Location.myLocation(true);
    setState(
      () {
        myLat = myLatLng[Location.lat];
        myLng = myLatLng[Location.lng];
        fromLocation = myLocationDetails[Location.location];
        fromLocationID = myLocationDetails[Location.locationID];
      },
    );
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
      checkRequiredFields();
    }
    loadFare();
  }

  void loadFare() async {
    if (fromLocationID.isNotEmpty &&
        toLocationID.isNotEmpty &&
        pickUpDateController.text.isNotEmpty &&
        returnDateController.text.isNotEmpty) {
      final Map<String, dynamic> tripDetails =
          await Operations.retrieveTripDetails(
        fromLocationID: fromLocationID,
        toLocationID: toLocationID,
        tripType: CarModes.roundWay,
        noOfDays: DateTime.parse(returnDateController.text)
                    .difference(
                      DateTime.parse(pickUpDateController.text),
                    )
                    .inHours ==
                0
            ? 1
            : ((DateTime.parse(returnDateController.text)
                            .difference(
                              DateTime.parse(pickUpDateController.text),
                            )
                            .inHours +
                        24) /
                    24)
                .floor(),
        loading: (status) => setState(() => fareLoading = status),
      );
      setState(
        () {
          distance = tripDetails['distance'];
          sedanBaseFare = tripDetails['sedan']['base_fare'];
          suvBaseFare = tripDetails['suv']['base_fare'];
          suvPlusBaseFare = tripDetails['suv+']['base_fare'];
          executiveBaseFare = tripDetails['executive']['base_fare'];
          tempoBaseFare = tripDetails['tempo']['base_fare'];

          sedanTotalFare = tripDetails['sedan']['total_fare'];
          suvTotalFare = tripDetails['suv']['total_fare'];
          suvPlusTotalFare = tripDetails['suv+']['total_fare'];
          executiveTotalFare = tripDetails['executive']['total_fare'];
          tempoTotalFare = tripDetails['tempo']['total_fare'];

          suvPlusDriverFee = tripDetails['suv+']['driver_fee'];
          executiveDriverFee = tripDetails['executive']['driver_fee'];
          tempoDriverFee = tripDetails['tempo']['driver_fee'];
        },
      );
    }
  }

  void review() {
    if (fromLocationID.isNotEmpty &&
        toLocationID.isNotEmpty &&
        pickUpDateController.text.isNotEmpty &&
        pickUpTimeController.text.isNotEmpty &&
        returnDateController.text.isNotEmpty &&
        (suvSelected ||
            sedanSelected ||
            suvPlusSelected ||
            executiveSelected ||
            tempoSelected)) {
      reviewScreen.show(
        context: context,
        baseFare: sedanSelected
            ? sedanBaseFare
            : suvSelected
                ? suvBaseFare
                : suvPlusSelected
                    ? suvPlusBaseFare
                    : executiveSelected
                        ? executiveBaseFare
                        : tempoBaseFare,
        driverFee: sedanSelected || suvPlusSelected || suvSelected
            ? suvPlusDriverFee
            : executiveSelected
                ? executiveDriverFee
                : tempoDriverFee,
        totalFare: sedanSelected
            ? sedanTotalFare
            : suvSelected
                ? suvTotalFare
                : suvPlusSelected
                    ? suvPlusTotalFare
                    : executiveSelected
                        ? executiveTotalFare
                        : tempoTotalFare,
        distance: distance,
        to: toLocation,
        from: fromLocation,
        roundTrip: true,
        pickUpDate: pickUpDateController.text,
        pickUptime: pickUpTimeController.text,
        returnDate: returnDateController.text,
        onTap: () async {
          if (Operations.rideTimeCheck(context, pickUpTimeController.text)) {
            reviewScreen.loadingUpdate();
            await Database.addNewTrip(
                from: fromLocation,
                to: toLocation,
                fromId: fromLocationID,
                toId: toLocationID,
                tripStartDate: pickUpDateController.text,
                distance: distance,
                driverFee: sedanSelected || suvPlusSelected || suvSelected
                    ? suvPlusDriverFee
                    : executiveSelected
                        ? executiveDriverFee
                        : tempoDriverFee,
                carMode: sedanSelected ? 'sedan' : 'suv',
                tripStartTime: pickUpTimeController.text,
                tripType: CarModes.roundWay,
                bookingDate: DateTime.now().toString().split(' ')[0],
                baseFare:
                    sedanSelected ? sedanBaseFare - 300 : suvBaseFare - 300);
            reviewScreen.loadingUpdate();
          }
        },
        carModes: sedanSelected
            ? CarModes.sedan(
                tripFare: 0,
                selected: false,
                loading: false,
                onTap: () => null,
                tripType: CarModes.roundWay,
              )
            : suvSelected
                ? CarModes.suv(
                    tripFare: 0,
                    selected: false,
                    loading: false,
                    onTap: () => null,
                    tripType: CarModes.roundWay,
                  )
                : suvPlusSelected
                    ? CarModes.suvPlus(
                        tripFare: 0,
                        selected: false,
                        loading: false,
                        onTap: () => null,
                        tripType: CarModes.roundWay,
                      )
                    : executiveSelected
                        ? CarModes.executive(
                            tripFare: 0,
                            selected: false,
                            loading: false,
                            onTap: () => null,
                            tripType: CarModes.roundWay,
                          )
                        : CarModes.tempo(
                            tripFare: 0,
                            selected: false,
                            loading: false,
                            onTap: () => null,
                            tripType: CarModes.roundWay,
                          ),
      );
    }
  }
}
