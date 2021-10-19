import 'package:date_time_picker/date_time_picker.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:testing_referral/elements/button.dart';
import 'package:testing_referral/elements/car_modes.dart';
import 'package:testing_referral/network/database.dart';
import 'package:testing_referral/network/location.dart';
import 'package:testing_referral/operations/operations.dart';
import 'package:testing_referral/screens/review_screen.dart';
import 'booking_confirmation_screen.dart';
import 'map_screen.dart';
import 'navigator_screen.dart';

class OneWayTripScreen extends StatefulWidget {
  @override
  State<OneWayTripScreen> createState() => _OneWayTripScreenState();
}

class _OneWayTripScreenState extends State<OneWayTripScreen>
    with SingleTickerProviderStateMixin {
  bool sedanSelected = false;
  bool suvSelected = false;
  String fromLocation = 'Choose location';
  String fromLocationID = '';
  String toLocation = 'Choose location';
  String toLocationID = '';
  String distance = '';
  int sedanBaseFare = 0;
  int suvBaseFare = 0;
  int driverFee = 0;
  int sedanTotalFare = 0;
  int suvTotalFare = 0;
  double myLat = 0;
  double myLng = 0;
  bool fareLoading = false;
  final ReviewScreen reviewScreen = ReviewScreen();
  final TextEditingController dateController = TextEditingController();
  final TextEditingController timeController = TextEditingController();
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
                padding: EdgeInsets.only(right: 20, left: 20, bottom: 10),
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
                      margin: EdgeInsets.only(top: 25),
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
                                      children:
                                          Operations.generateDottedLines(50),
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
                            onChange: (input) => checkRequiredFields(),
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
                      tripType: CarModes.oneWay,
                      onTap: () => setState(
                        () {
                          if (sedanSelected) {
                            sedanSelected = false;
                          } else {
                            sedanSelected = true;
                            suvSelected = false;
                          }
                          checkRequiredFields();
                        },
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(bottom: 60.0),
                      child: CarModes.suv(
                        tripFare: suvTotalFare,
                        selected: suvSelected,
                        loading: fareLoading,
                        tripType: CarModes.oneWay,
                        onTap: () => setState(
                          () {
                            if (suvSelected) {
                              suvSelected = false;
                            } else {
                              suvSelected = true;
                              sedanSelected = false;
                            }
                            checkRequiredFields();
                          },
                        ),
                      ),
                    ),
                    /*if (error)
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8.0),
                        child: Text(
                          '*Fill the required fields*',
                          textAlign: TextAlign.center,
                          style: GoogleFonts.ptSans(color: Colors.red),
                        ),
                      ),*/
                  ],
                ),
              ),
            ),
          ],
        ),
        SlideTransition(
          position: Tween<Offset>(
            begin: Offset(0, MediaQuery.of(context).size.height / 57.1),
            end: Offset(0, MediaQuery.of(context).size.height / 76.5),
          ).animate(
            CurvedAnimation(
                parent: slideAnimationController, curve: Curves.easeInOutBack),
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: Button(
              buttonText: 'Review your ride'.toUpperCase(),
              onPress: () async {
                reviewScreen.show(
                  context: context,
                  baseFare: sedanSelected ? sedanBaseFare : suvBaseFare,
                  driverFee: driverFee,
                  totalFare: sedanSelected ? sedanTotalFare : suvTotalFare,
                  distance: distance,
                  to: toLocation,
                  from: fromLocation,
                  pickUpDate: dateController.text,
                  pickUptime: timeController.text,
                  onTap: () async {
                    if (Operations.rideTimeCheck(
                        context, timeController.text)) {
                      reviewScreen.loadingUpdate();
                      await Database.addNewTrip(
                          from: fromLocation,
                          to: toLocation,
                          fromId: fromLocationID,
                          toId: toLocationID,
                          tripStartDate: dateController.text,
                          distance: distance,
                          driverFee: driverFee,
                          carMode: sedanSelected ? 'sedan' : 'suv',
                          tripStartTime: timeController.text,
                          tripType: CarModes.oneWay,
                          bookingDate: DateTime.now().toString().split(' ')[0],
                          baseFare: sedanSelected
                              ? sedanBaseFare - 300
                              : suvBaseFare - 300);
                      reviewScreen.loadingUpdate();
                      Navigator.pushReplacementNamed(context,
                          BookingConfirmationScreen.bookingConfirmationScreen);
                    }
                  },
                  carModes: sedanSelected
                      ? CarModes.sedan(
                          tripFare: 0,
                          selected: false,
                          loading: false,
                          onTap: () => null,
                          tripType: CarModes.oneWay,
                        )
                      : CarModes.suv(
                          tripFare: 0,
                          selected: false,
                          loading: false,
                          onTap: () => null,
                          tripType: CarModes.oneWay,
                        ),
                );
              },
            ),
          ),
        ),
      ],
    );
  }

  void checkRequiredFields() {
    if (fromLocationID.isNotEmpty &&
        toLocationID.isNotEmpty &&
        dateController.text.isNotEmpty &&
        timeController.text.isNotEmpty &&
        (suvSelected || sedanSelected)) {
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
    if (fromLocationID.isNotEmpty && toLocationID.isNotEmpty) {
      final Map<String, dynamic> tripDetails =
          await Operations.retrieveTripDetails(
        fromLocationID: fromLocationID,
        toLocationID: toLocationID,
        tripType: CarModes.oneWay,
        loading: (status) => setState(() => fareLoading = status),
      );
      setState(
        () {
          distance = tripDetails['distance'];
          sedanBaseFare = tripDetails['sedan']['base_fare'];
          suvBaseFare = tripDetails['suv']['base_fare'];
          sedanTotalFare = tripDetails['sedan']['total_fare'];
          suvTotalFare = tripDetails['suv']['total_fare'];
          driverFee = tripDetails['sedan']['driver_fee'];
        },
      );
    }
  }
}

/*
class TripScreenTemplate extends StatelessWidget {
  const TripScreenTemplate({
    required this.fromEntryButton,
    required this.toEntryButton,
    required this.from,
    required this.to,
    this.returnDate = false,
    required this.pickUpTimeController,
    required this.pickUpDateController,
    this.returnUpDateController,
  }) : assert(returnDate && returnUpDateController == null);

  final VoidCallback fromEntryButton;
  final VoidCallback toEntryButton;
  final String from;
  final String to;
  final bool returnDate;
  final TextEditingController pickUpDateController;
  final TextEditingController pickUpTimeController;
  final TextEditingController? returnUpDateController;

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
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [],
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
                                onTap: fromEntryButton,
                                entryLabel: 'From',
                                entry: from,
                              ),
                              SizedBox(
                                height: 40,
                                child: Divider(
                                  color: Colors.white54,
                                ),
                              ),
                              LocationEntry(
                                onTap: toEntryButton,
                                entryLabel: 'To',
                                entry: to,
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
                  if (returnDate) Padding(
                    padding: const EdgeInsets.symmetric(vertical: 30),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        DateTimeEntry(
                          controller: returnUpDateController!,
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
                            controller: TextEditingController(),
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
                  if (true)
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8.0),
                      child: Text(
                        '*Fill the required fields*',
                        textAlign: TextAlign.center,
                        style: GoogleFonts.ptSans(color: Colors.red),
                      ),
                    ),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      vertical: 10.0,
                    ),
                    child: Button(
                      loading: false,
                      buttonText: 'Review your ride'.toUpperCase(),
                      onPress: () {},
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
*/
