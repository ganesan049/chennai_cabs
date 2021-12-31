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

class OneWayTripScreen extends StatefulWidget {
  @override
  State<OneWayTripScreen> createState() => _OneWayTripScreenState();
}

class _OneWayTripScreenState extends State<OneWayTripScreen>
    with SingleTickerProviderStateMixin {
  String fromLocation = 'Choose location';
  String fromLocationID = '';
  String selected = '';
  String toLocation = 'Choose location';
  String toLocationID = '';
  String distance = '';
  double myLat = 0;
  double myLng = 0;
  int selectedBaseFare = 0;
  int selectedDriverFee = 0;
  int selectedTotalFare = 0;
  int rewardPoints = 0;
  bool fareLoading = false;
  bool reviewLoading = false;
  bool useRewardPoints = false;
  final ReviewScreen reviewScreen = ReviewScreen();
  final TextEditingController dateController = TextEditingController();
  final TextEditingController timeController = TextEditingController();
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
    dateController.dispose();
    timeController.dispose();
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
                            onChange: (input) => checkRequiredFields(true),
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
                      future: Database.getCarModes('one_way'),
                      builder: (context, cars) {
                        if (cars.hasData) {
                          return Column(
                            children: List.generate(
                              cars.data!.length,
                              (index) => Padding(
                                padding: EdgeInsets.only(
                                    bottom: index == cars.data!.length -1 ? 60.0 : 0),
                                child: CarModesCard(
                                  loading: fareLoading,
                                  carNames: cars.data!.elementAt(index)['info'],
                                  tripFare: distance.isNotEmpty
                                      ? tripFare(
                                          distance,
                                          cars.data!.elementAt(index)['fare'],
                                          cars.data!.elementAt(index)[
                                              'driver_fee'])['total_fare']!
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
                                  onTap: () {
                                    setState(
                                      () {
                                        selectedTotalFare = tripFare(
                                            distance,
                                            cars.data!.elementAt(index)['fare'],
                                            cars.data!.elementAt(index)[
                                                'driver_fee'])['total_fare']!;
                                        selectedBaseFare = tripFare(
                                            distance,
                                            cars.data!.elementAt(index)['fare'],
                                            cars.data!.elementAt(index)[
                                                'driver_fee'])['base_fare']!;
                                        selectedDriverFee = cars.data!
                                            .elementAt(index)['driver_fee'];
                                        selected ==
                                                cars.data!
                                                    .elementAt(index)['name']
                                            ? selected = ''
                                            : selected = cars.data!
                                                .elementAt(index)['name'];
                                      },
                                    );
                                    checkRequiredFields(false);
                                  },
                                  imageURL:
                                      cars.data!.elementAt(index)['image_url'],
                                ),
                              ),
                            ),
                          );
                        } else {
                          return Column(
                            children: List.generate(
                              2,
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

  Map<String, int> tripFare(String distance, int carFare, int driverFee) {
    int formattedDistance = Operations.getFormattedDistance(distance) > 130
        ? Operations.getFormattedDistance(distance)
        : 130;
    return {
      'base_fare': formattedDistance * carFare,
      'total_fare': (formattedDistance * carFare) + driverFee,
    };
  }

  void bookYourRide() async {
    reviewScreen.loadingUpdate();
    bool rideCheck =
        await Operations.rideCheck(context, timeController.text, dateController.text);
    if (rideCheck) {
      await Database.addNewTrip(
          from: fromLocation,
          to: toLocation,
          fromId: fromLocationID,
          toId: toLocationID,
          rewardPoints: rewardPoints,
          tripStartDate: dateController.text,
          distance: distance,
          driverFee: selectedDriverFee,
          carMode: selected,
          useRewardPoints: useRewardPoints,
          tripStartTime: timeController.text,
          tripType: CarModesCard.oneWay,
          bookingDate: DateTime.now().toString().split(' ')[0],
          baseFare: selectedBaseFare);
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
      rewardPointsUsage: (usage) => setState(() => useRewardPoints = usage),
      from: fromLocation,
      pickUpDate: dateController.text,
      pickUptime: timeController.text,
      onTap: bookYourRide,
    );
  }

  void checkRequiredFields(bool changeInFields) {
    if(changeInFields){
      setState(() => selected = '');
    }
    if (fromLocationID.isNotEmpty &&
        toLocationID.isNotEmpty &&
        dateController.text.isNotEmpty &&
        timeController.text.isNotEmpty &&
        selected.isNotEmpty) {
      animationController.forward();
    } else {
      animationController.reverse();
    }
  }

  void myLocation() async {
    final Map myLocationDetails = await Location.myLocation(false);
    final Map myLatLng = await Location.myLocation(true);
    if(mounted){
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
    if (fromLocationID.isNotEmpty && toLocationID.isNotEmpty) {
      setState(() => fareLoading = true);
      final String dist =
          await Location.getDistance(fromLocationID, toLocationID);
      setState(
        () {
          fareLoading = false;
          distance = dist;
        },
      );
    }
  }
}
