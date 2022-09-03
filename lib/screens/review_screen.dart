import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:chennai_cabs_dev/elements/button.dart';
import 'package:chennai_cabs_dev/elements/car_modes_card.dart';
import 'package:chennai_cabs_dev/elements/car_modes_loading_card.dart';
import 'package:chennai_cabs_dev/elements/toggle_button.dart';
import 'package:chennai_cabs_dev/network/database.dart';
import 'package:chennai_cabs_dev/operations/operations.dart';

class ReviewScreen {
  final TextStyle kDefault = GoogleFonts.ptSans();
  final TextStyle kDefaultBold =
      GoogleFonts.poppins(fontWeight: FontWeight.bold);
  late StateSetter setModalState;
  bool loading = false;
  bool useRewardPoints = false;

  List<Widget> generate(double length) {
    return List.generate(
      (length / 5).floor(),
      (index) => SizedBox(
        height: 5,
        width: 10,
        child: Align(
          alignment: Alignment.centerLeft,
          child: VerticalDivider(
            width: 3,
            thickness: 2,
            color: index % 2 == 0 ? Colors.grey : Colors.transparent,
          ),
        ),
      ),
    );
  }

  void callSetState() => setModalState(() {});

  void loadingUpdate() => setModalState(() => loading = !loading);

  Future<dynamic> show({
    required BuildContext context,
    required String from,
    required String to,
    required int baseFare,
    required int driverFee,
    required int totalFare,
    required String selectedCarMode,
    required VoidCallback onTap,
    required String pickUpDate,
    required String pickUptime,
    required int rewardPoints,
    required ValueSetter<bool> rewardPointsUsage,
    bool roundTrip = false,
    String? returnDate,
    required String distance,
  }) {
    useRewardPoints = false;
    final String distanceInfo = returnDate != null
        ? '${Operations.distanceInfo(distance, noOfDays: Operations.getNoOfDays(pickUpDate, returnDate))}'
        : '${Operations.distanceInfo(distance)}';
    return showModalBottomSheet(
      context: context,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
      ),
      builder: (context) => StatefulBuilder(
        builder: (context, modalState) {
          setModalState = modalState;
          return Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              SizedBox(
                height: 50,
                child: Row(
                  children: [
                    BackButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                    ),
                    Text(
                      'Review your ride'.toUpperCase(),
                      style: GoogleFonts.sourceSansPro(
                          fontSize: 17,
                          color: Colors.black,
                          fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: Container(
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(top: 15.0),
                          child: ListTile(
                            leading: Icon(Icons.location_on),
                            title: Text(
                              from,
                              style: GoogleFonts.ptSans(
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 27.0),
                          child: SizedBox(
                            height: 40,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: generate(40),
                            ),
                          ),
                        ),
                        ListTile(
                          leading: Icon(Icons.location_city),
                          title: Text(
                            to,
                            style:
                                GoogleFonts.ptSans(fontWeight: FontWeight.bold),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(
                              left: 15.0, top: 20, bottom: 10),
                          child: Text(
                            'Ride details',
                            style: kDefaultBold.copyWith(fontSize: 20),
                          ),
                        ),
                        SizedBox(
                          height: 5,
                          child: Divider(
                            indent: 15,
                            endIndent: 15,
                            color: Colors.grey,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 15.0),
                          child: FutureBuilder<Map>(
                            future: Database.getCarMode(
                                roundTrip ? 'round_way' : 'one_way',
                                selectedCarMode),
                            builder: (context, cars) {
                              if (cars.hasData) {
                                return CarModesCard(
                                  selected: true,
                                  carNames: cars.data!['info'],
                                  carType: cars.data!['name'],
                                  carFare: cars.data!['fare'].toString(),
                                  noOfPerson:
                                      cars.data!['no_of_persons'].toString(),
                                  onTap: () => null,
                                  imageURL: cars.data!['image_url'],
                                );
                              } else {
                                return Column(
                                  children: List.generate(
                                    1,
                                    (index) => CarModesLoadingCard(),
                                  ),
                                );
                              }
                            },
                          ),
                        ),
                        ListTile(
                          title: Text(
                            'Pickup date',
                            style: kDefault,
                          ),
                          trailing: Text(
                            Operations.getDateWithMonthName(pickUpDate),
                            style: kDefaultBold,
                          ),
                        ),
                        ListTile(
                          title: Text(
                            'Pickup time',
                            style: kDefault,
                          ),
                          trailing: Text(
                            Operations.getFormattedTime(
                                date: pickUpDate, time: pickUptime),
                            style: kDefaultBold,
                          ),
                        ),
                        if (roundTrip)
                          ListTile(
                            title: Text(
                              'Return date',
                              style: kDefault,
                            ),
                            trailing: Text(
                              Operations.getDateWithMonthName(returnDate!),
                              style: kDefaultBold,
                            ),
                          ),
                        ListTile(
                          title: Text(
                            'Distance',
                            style: kDefault,
                          ),
                          trailing: Text(
                            distance,
                            style: kDefaultBold,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(
                              left: 15.0, top: 20, bottom: 10),
                          child: Text(
                            'Fare details',
                            style: kDefaultBold.copyWith(fontSize: 20),
                          ),
                        ),
                        SizedBox(
                          height: 5,
                          child: Divider(
                            indent: 15,
                            endIndent: 15,
                            color: Colors.grey,
                          ),
                        ),
                        ListTile(
                          title: Text(
                            'Base fare',
                            style: kDefault,
                          ),
                          trailing: Text(
                            '₹ $baseFare',
                            style: kDefaultBold,
                          ),
                          subtitle: Text(
                            '(up to $distanceInfo)',
                            style: kDefaultBold.copyWith(fontSize: 10),
                          ),
                        ),
                        ListTile(
                          title: Text(
                            'Driver fee',
                            style: kDefault,
                          ),
                          subtitle: returnDate != null
                              ? Text(
                                  Operations.getNoOfDays(
                                              pickUpDate, returnDate) ==
                                          1
                                      ? '(${Operations.getNoOfDays(pickUpDate, returnDate)} day)'
                                      : '(${Operations.getNoOfDays(pickUpDate, returnDate)} days)',
                                  style: kDefaultBold.copyWith(fontSize: 10),
                                )
                              : null,
                          trailing: Text(
                            '₹ $driverFee',
                            style: kDefaultBold,
                          ),
                        ),
                        ListTile(
                          title: Text(
                            'Reward points',
                            style: kDefault,
                          ),
                          subtitle: Text(
                            '(Balance: $rewardPoints)',
                            style: kDefaultBold.copyWith(fontSize: 10),
                          ),
                          trailing: Text(
                            !useRewardPoints ? '- ₹ 0' : '- ₹ $rewardPoints',
                            style: kDefaultBold,
                          ),
                        ),
                        ToggleButton(
                          toggleStateChange: (switchState) {
                            rewardPointsUsage(switchState);
                            setModalState(() => useRewardPoints = switchState);
                          },
                        ),
                        SizedBox(
                          height: 5,
                          child: Divider(
                            indent: 15,
                            endIndent: 15,
                            color: Colors.grey,
                          ),
                        ),
                        ListTile(
                          title: Text(
                            'Subtotal',
                            style: kDefault.copyWith(fontSize: 15),
                          ),
                          trailing: Text(
                            '₹ $totalFare',
                            style: kDefaultBold,
                          ),
                        ),
                        SizedBox(
                          height: 5,
                          child: Divider(
                            indent: 15,
                            endIndent: 15,
                            color: Colors.grey,
                          ),
                        ),
                        ListTile(
                          title: SizedBox(
                            width: 70,
                            child: Row(
                              children: [
                                Text(
                                  'Total fare',
                                  style: kDefaultBold.copyWith(fontSize: 18),
                                ),
                                Tooltip(
                                  height: 50,
                                  margin: EdgeInsets.symmetric(horizontal: 20),
                                  padding: EdgeInsets.all(10),
                                  triggerMode: TooltipTriggerMode.tap,
                                  preferBelow: false,
                                  message:
                                      'Total fare may change at the end of your trip if the distance travelled exceeds the estimated distance $distanceInfo',
                                  textStyle:
                                      GoogleFonts.ptSans(color: Colors.white),
                                  child: Icon(
                                    Icons.info_outlined,
                                    size: 13,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          subtitle: Text(
                            '(Estimated)',
                            style: kDefaultBold.copyWith(fontSize: 10),
                          ),
                          trailing: Text(
                            useRewardPoints
                                ? '₹ ${totalFare - rewardPoints}'
                                : '₹ $totalFare',
                            style: kDefaultBold.copyWith(fontSize: 18),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 15.0),
                          child: Text(
                            '*Toll/Parking/Permit charges extra*',
                            textAlign: TextAlign.center,
                            style: GoogleFonts.ptSans(
                              color: Colors.red,
                              fontSize: 12,
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 30.0, vertical: 15),
                          child: Button(
                            loading: loading,
                            onPress: onTap,
                            buttonText: 'BOOK YOUR RIDE',
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Future<dynamic> showForRental({
    required BuildContext context,
    required String pickUpAddress,
    required int totalFare,
    required String carMode,
    required int rewardPoints,
    required VoidCallback onTap,
    required String pickUpDate,
    required String pickUptime,
    required String distance,
    required String duration,
    required ValueSetter<bool> rewardPointsUsage,
  }) async {
    useRewardPoints = false;
    return showModalBottomSheet(
      context: context,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
      ),
      builder: (context) => StatefulBuilder(
        builder: (context, modalState) {
          setModalState = modalState;
          return Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              SizedBox(
                height: 50,
                child: Row(
                  children: [
                    BackButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                    ),
                    Text(
                      'Review your ride'.toUpperCase(),
                      style: GoogleFonts.sourceSansPro(
                          fontSize: 17,
                          color: Colors.black,
                          fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: Container(
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(top: 15.0),
                          child: ListTile(
                            leading: Icon(Icons.location_on),
                            title: Text(
                              pickUpAddress,
                              style: GoogleFonts.ptSans(
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(
                              left: 15.0, top: 20, bottom: 10),
                          child: Text(
                            'Ride details',
                            style: kDefaultBold.copyWith(fontSize: 20),
                          ),
                        ),
                        SizedBox(
                          height: 5,
                          child: Divider(
                            indent: 15,
                            endIndent: 15,
                            color: Colors.grey,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 15.0),
                          child: FutureBuilder<Map>(
                            future: Database.getCarMode('rental', carMode),
                            builder: (context, cars) {
                              if (cars.hasData) {
                                return CarModesCard(
                                  selected: true,
                                  carNames: cars.data!['info'],
                                  carType: cars.data!['name'],
                                  carFare: cars.data!['fare_per_km'].toString(),
                                  noOfPerson:
                                      cars.data!['no_of_persons'].toString(),
                                  onTap: () => null,
                                  imageURL: cars.data!['image_url'],
                                );
                              } else {
                                return Column(
                                  children: List.generate(
                                    1,
                                    (index) => CarModesLoadingCard(),
                                  ),
                                );
                              }
                            },
                          ),
                        ),
                        ListTile(
                          title: Text(
                            'Pickup date',
                            style: kDefault,
                          ),
                          trailing: Text(
                            Operations.getDateWithMonthName(pickUpDate),
                            style: kDefaultBold,
                          ),
                        ),
                        ListTile(
                          title: Text(
                            'Pickup time',
                            style: kDefault,
                          ),
                          trailing: Text(
                            Operations.getFormattedTime(
                                date: pickUpDate, time: pickUptime),
                            style: kDefaultBold,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(
                              left: 15.0, top: 20, bottom: 10),
                          child: Text(
                            'Package details',
                            style: kDefaultBold.copyWith(fontSize: 20),
                          ),
                        ),
                        SizedBox(
                          height: 5,
                          child: Divider(
                            indent: 15,
                            endIndent: 15,
                            color: Colors.grey,
                          ),
                        ),
                        ListTile(
                          title: Text(
                            'Distance',
                            style: kDefault,
                          ),
                          trailing: Text(
                            distance,
                            style: kDefaultBold,
                          ),
                        ),
                        ListTile(
                          title: Text(
                            'Duration',
                            style: kDefault,
                          ),
                          trailing: Text(
                            duration,
                            style: kDefaultBold,
                          ),
                        ),
                        ListTile(
                          title: Text(
                            'Reward points',
                            style: kDefault,
                          ),
                          subtitle: Text(
                            '(Balance: $rewardPoints)',
                            style: kDefaultBold.copyWith(fontSize: 10),
                          ),
                          trailing: Text(
                            !useRewardPoints ? '- ₹ 0' : '- ₹ $rewardPoints',
                            style: kDefaultBold,
                          ),
                        ),
                        ToggleButton(
                          toggleStateChange: (switchState) {
                            rewardPointsUsage(switchState);
                            setModalState(() => useRewardPoints = switchState);
                          },
                        ),
                        SizedBox(
                          height: 5,
                          child: Divider(
                            indent: 15,
                            endIndent: 15,
                            color: Colors.grey,
                          ),
                        ),
                        ListTile(
                          title: Text(
                            'Subtotal',
                            style: kDefault.copyWith(fontSize: 15),
                          ),
                          trailing: Text(
                            '₹ $totalFare',
                            style: kDefaultBold,
                          ),
                        ),
                        SizedBox(
                          height: 5,
                          child: Divider(
                            indent: 15,
                            endIndent: 15,
                            color: Colors.grey,
                          ),
                        ),
                        ListTile(
                          title: SizedBox(
                            width: 70,
                            child: Row(
                              children: [
                                Text(
                                  'Total fare',
                                  style: kDefaultBold.copyWith(fontSize: 18),
                                ),
                                Tooltip(
                                  height: 50,
                                  margin: EdgeInsets.symmetric(horizontal: 20),
                                  padding: EdgeInsets.all(10),
                                  triggerMode: TooltipTriggerMode.tap,
                                  preferBelow: false,
                                  message:
                                      'Total fare may change at the end of your trip if the duration and distance travelled exceeds the selected duration $duration and distance $distance',
                                  textStyle: GoogleFonts.ptSans(
                                    color: Colors.white,
                                  ),
                                  child: Icon(
                                    Icons.info_outlined,
                                    size: 13,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          subtitle: Text(
                            '(Estimated)',
                            style: kDefaultBold.copyWith(fontSize: 10),
                          ),
                          trailing: Text(
                            useRewardPoints
                                ? '₹ ${totalFare - rewardPoints}'
                                : '₹ $totalFare',
                            style: kDefaultBold.copyWith(fontSize: 18),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 15.0),
                          child: Text(
                            '*Toll/Parking/Permit charges extra*',
                            textAlign: TextAlign.center,
                            style: GoogleFonts.ptSans(
                              color: Colors.red,
                              fontSize: 12,
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 30.0, vertical: 15),
                          child: Button(
                            loading: loading,
                            onPress: onTap,
                            buttonText: 'BOOK YOUR RIDE',
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
