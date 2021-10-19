import 'dart:math';
import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:testing_referral/elements/car_modes.dart';
import 'package:testing_referral/elements/dialog_box.dart';
import 'package:testing_referral/network/auth.dart';
import 'package:testing_referral/network/database.dart';
import 'package:testing_referral/network/location.dart';
import 'package:uuid/uuid.dart';

class Operations {
  static int pressCount = 0;

  static List<Widget> generateDottedLines(double length) {
    return List.generate(
      (length / 5).floor(),
      (index) => SizedBox(
        height: 5,
        child: VerticalDivider(
          thickness: 2,
          color: index % 2 == 0 ? Colors.white : Colors.transparent,
        ),
      ),
    );
  }

  static Future<bool> exit(BuildContext context) {
    pressCount++;
    Future.delayed(Duration(seconds: 2), () => pressCount = 0);
    if (pressCount > 1) {
      return Future.value(true);
    } else {
      final SnackBar snackBar = SnackBar(
        elevation: 3,
        behavior: SnackBarBehavior.floating,
        duration: Duration(seconds: 2),
        content: Text(
          'Press again to exit',
          style: GoogleFonts.ptSans(),
        ),
      );
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
      return Future.value(false);
    }
  }

  static String getSessionToken() {
    return Uuid().v4();
  }

  static Future<String> getBookingId() async {
    String bookingID = 'CC';
    int total = await Database.getTotalTrips();
    for (int i = 0; i < 8 - total.toString().length; i++) {
      bookingID += '0';
    }
    return bookingID + total.toString();
  }

  static String generateOtp() {
    String otp = '';
    for (int i = 0; i < 4; i++) {
      otp += Random().nextInt(9).toString();
    }
    return otp;
  }

  static String getMonthName(String date) => DateFormat("MMMM dd, yyyy").format(
        DateTime.parse(date),
      );

  static String getDateMonthNameYear(String date) =>
      DateFormat('d MMM ' 'yy').format(
        DateTime.parse(date),
      );

  static String getDayName(String date) => DateFormat('EEEE').format(
        DateTime.parse(date),
      );

  static String trimLocation(String location) =>
      location.split(',')[location.split(',').length - 3].trim();

  static Future<Map<String, dynamic>> retrieveTripDetails(
      {required String fromLocationID,
      required String toLocationID,
      required String tripType,
      required ValueSetter<bool> loading,
      int? noOfDays}) async {
    late Map<String, dynamic> tripDetails;
    loading(true);
    final String distance =
        await Location.getDistance(fromLocationID, toLocationID);
    if (tripType == CarModes.oneWay) {
      final Map<String, int> sedan = await Database.getTripFare(
          distance: distance, carMode: 'sedan', tripType: tripType);
      final Map<String, int> suv = await Database.getTripFare(
          distance: distance, carMode: 'suv', tripType: tripType);
      tripDetails = {
        'distance': distance,
        'sedan': sedan,
        'suv': suv,
      };
    } else if (tripType == CarModes.roundWay) {
      final Map<String, int> sedan = await Database.getTripFare(
          distance: distance,
          carMode: 'sedan',
          tripType: tripType,
          noOfDays: noOfDays!);
      final Map<String, int> suv = await Database.getTripFare(
          distance: distance,
          carMode: 'suv',
          tripType: tripType,
          noOfDays: noOfDays);
      final Map<String, int> suvPlus = await Database.getTripFare(
          distance: distance,
          carMode: 'suv+',
          tripType: tripType,
          noOfDays: noOfDays);
      final Map<String, int> executive = await Database.getTripFare(
          distance: distance,
          carMode: 'executive',
          tripType: tripType,
          driverFeeFieldPath: 'driver_fee_executive',
          noOfDays: noOfDays);
      final Map<String, int> tempo = await Database.getTripFare(
          distance: distance,
          carMode: 'tempo',
          tripType: tripType,
          driverFeeFieldPath: 'driver_fee_tempo',
          noOfDays: noOfDays);
      tripDetails = {
        'distance': distance,
        'sedan': sedan,
        'suv': suv,
        'suv+': suvPlus,
        'executive': executive,
        'tempo': tempo
      };
    } else {
      tripDetails = {};
    }
    loading(false);
    return tripDetails;
  }

  static Future<Uri> generateRefLink() async {
    final DynamicLinkParameters parameters = DynamicLinkParameters(
      uriPrefix: 'https://chennaicabs.page.link',
      link: Uri.parse('https://chennaicabs.com/code?c=${Auth.getUserId()}'),
      androidParameters: AndroidParameters(
        packageName: 'com.example.testing_referral',
        minimumVersion: 125,
      ),
    );

    final ShortDynamicLink shortDynamicUrl = await parameters.buildShortLink();
    return shortDynamicUrl.shortUrl;
  }

  static bool rideTimeCheck(BuildContext context, String time) {
    if (0 <= int.parse(time.split(':')[0]) &&
        int.parse(time.split(':')[0]) < 5) {
      DialogBox.show(context,
          'Rides are not available from 12 AM to 5 AM. Sorry for the inconvenience');
      return false;
    } else {
      return true;
    }
  }
}
