import 'package:date_time_picker/date_time_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:testing_referral/elements/button.dart';
import 'package:testing_referral/elements/car_modes_card.dart';
import 'package:testing_referral/elements/car_modes_loading_card.dart';
import 'package:testing_referral/elements/date_time_entry.dart';
import 'package:testing_referral/network/database.dart';
import 'package:testing_referral/network/location.dart';
import 'package:testing_referral/operations/operations.dart';
import 'package:testing_referral/screens/review_screen.dart';
import 'booking_confirmation_screen.dart';
import 'map_screen.dart';

class RentalScreen extends StatefulWidget {
  const RentalScreen({Key? key}) : super(key: key);

  @override
  State<RentalScreen> createState() => _RentalScreenState();
}

class _RentalScreenState extends State<RentalScreen>
    with SingleTickerProviderStateMixin {
  final TextEditingController dateController = TextEditingController();
  final TextEditingController timeController = TextEditingController();
  final ReviewScreen reviewScreen = ReviewScreen();
  int selectedTotalFare = 0;
  int rewardPoints = 0;
  String selectedCarMode = '';
  double myLat = 0;
  double myLng = 0;
  bool reviewLoading = false;
  bool useRewardPoints = false;
  String pickUpLocationID = '';
  final TextEditingController pickUpLocationController =
      TextEditingController();
  String dropdownValueDuration = '---Select hours---';
  String dropdownValueDistance = '---Select distance---';
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
    pickUpLocationController.dispose();
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
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(
                            top: 10.0, bottom: 10, right: 3),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Pickup location:',
                              style: GoogleFonts.ptSans(fontSize: 16),
                            ),
                            pickUpLocationController.text.isEmpty
                                ? SizedBox(
                                    height: 12,
                                    width: 12,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2,
                                      valueColor:
                                          AlwaysStoppedAnimation(Colors.black),
                                    ),
                                  )
                                : SizedBox(),
                          ],
                        ),
                      ),
                      TextField(
                        controller: pickUpLocationController,
                        style: GoogleFonts.ptSans(fontWeight: FontWeight.bold),
                        onTap: () => pickUpLocationController.selection =
                            TextSelection(
                                baseOffset: 0,
                                extentOffset:
                                    pickUpLocationController.value.text.length),
                        decoration: InputDecoration(
                          hintText: 'Enter your address here',
                          suffixIcon: IconButton(
                            onPressed: openMap,
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
                              checkRequiredFields(true);
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
                                  child: Container(
                                    child: Text(value),
                                  ),
                                );
                              },
                            ).toList(),
                          ),
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
                              checkRequiredFields(true);
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
                              '110 km',
                              '120 km',
                              '130 km',
                              '140 km',
                              '150 km',
                              '200 km'
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
                      FutureBuilder<List<Map>>(
                        future: Database.getCarModes('rental'),
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
                                    loading: false,
                                    carNames:
                                        cars.data!.elementAt(index)['info'],
                                    tripFare: tripFare(
                                      distanceFare: cars.data!
                                          .elementAt(index)['fare_per_km'],
                                      durationFare: cars.data!
                                          .elementAt(index)['fare_per_hour'],
                                    ),
                                    selected: selectedCarMode ==
                                            cars.data!.elementAt(index)['name']
                                        ? true
                                        : false,
                                    carType:
                                        cars.data!.elementAt(index)['name'],
                                    carFare: cars.data!
                                        .elementAt(index)['fare_per_km']
                                        .toString(),
                                    noOfPerson: cars.data!
                                        .elementAt(index)['no_of_persons']
                                        .toString(),
                                    imageURL: cars.data!
                                        .elementAt(index)['image_url'],
                                    onTap: () {
                                      setState(
                                        () {
                                          selectedTotalFare = tripFare(
                                            distanceFare: cars.data!.elementAt(
                                                index)['fare_per_km'],
                                            durationFare: cars.data!.elementAt(
                                                index)['fare_per_hour'],
                                          );
                                          selectedCarMode ==
                                                  cars.data!
                                                      .elementAt(index)['name']
                                              ? selectedCarMode = ''
                                              : selectedCarMode = cars.data!
                                                  .elementAt(index)['name'];
                                          checkRequiredFields(false);
                                        },
                                      );
                                    },
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

  int tripFare({
    required int durationFare,
    required int distanceFare,
  }) {
    if (dropdownValueDistance != '---Select distance---' &&
        dropdownValueDuration != '---Select hours---') {
      final int formattedDistance =
          Operations.getFormattedDistance(dropdownValueDistance);
      final int formattedDuration =
          Operations.getFormattedDistance(dropdownValueDuration);
      return formattedDistance > formattedDuration * 10
          ? (formattedDuration * durationFare) +
              ((formattedDistance - (formattedDuration * 10)) * distanceFare)
          : formattedDuration * durationFare;
    } else {
      return 0;
    }
  }

  void checkRequiredFields(changeInFields) {
    if (changeInFields) {
      setState(() => selectedCarMode = '');
    }
    if (pickUpLocationID.isNotEmpty &&
        dateController.text.isNotEmpty &&
        timeController.text.isNotEmpty &&
        selectedCarMode.isNotEmpty &&
        dropdownValueDistance != '---Select distance---' &&
        dropdownValueDuration != '---Select hours---') {
      animationController.forward();
    } else {
      animationController.reverse();
    }
  }

  void review() async {
    setState(() => reviewLoading = true);
    final int points = await Database.getRefPoints();
    rewardPoints = points;
    setState(() => reviewLoading = false);

    reviewScreen.showForRental(
      context: context,
      pickUpAddress: pickUpLocationController.text,
      totalFare: selectedTotalFare,
      carMode: selectedCarMode,
      onTap: bookYourRide,
      rewardPoints: rewardPoints,
      pickUpDate: dateController.text,
      pickUptime: timeController.text,
      distance: dropdownValueDistance,
      duration: dropdownValueDuration,
      rewardPointsUsage: (usage) => setState(() => useRewardPoints = usage),
    );
  }

  void bookYourRide() async {
    reviewScreen.loadingUpdate();
    bool rideCheck =
        await Operations.rideTimeCheck(context, timeController.text, dateController.text);
    if (rideCheck) {
      await Database.addNewTripRental(
          pickUpAddress: pickUpLocationController.text,
          bookingDate: dateController.text,
          tripStartDate: dateController.text,
          distance: dropdownValueDistance,
          pickUpAddressID: pickUpLocationID,
          carMode: selectedCarMode,
          tripType: 'rental',
          rewardPoints: rewardPoints,
          totalFare: selectedTotalFare,
          duration: dropdownValueDuration,
          useRewardPoints: useRewardPoints,
          tripStartTime: timeController.text);
      Navigator.pushReplacementNamed(
          context, BookingConfirmationScreen.bookingConfirmationScreen);
    } else {
      reviewScreen.loadingUpdate();
    }
  }

  void openMap() async {
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
          pickUpLocationController.text = locationDetails[Location.location]!;
          pickUpLocationID = locationDetails[Location.locationID]!;
        },
      );
      checkRequiredFields(true);
    }
  }

  void myLocation() async {
    final Map locationDetails = await Location.myLocation(false);
    final Map latLng = await Location.myLocation(true);
    pickUpLocationID = locationDetails[Location.locationID];
    if (mounted) {
      myLat = latLng[Location.lat];
      myLng = latLng[Location.lng];
      setState(() =>
          pickUpLocationController.text = locationDetails[Location.location]);
    }
  }
}
