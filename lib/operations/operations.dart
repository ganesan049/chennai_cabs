import 'dart:math';
import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:testing_referral/elements/dialog_box.dart';
import 'package:testing_referral/network/auth.dart';
import 'package:testing_referral/network/database.dart';
import 'package:uuid/uuid.dart';

class Operations {
  static int pressCount = 0;

  static List<Widget> generateDottedLines(
      double length, Color color, double thickness) {
    return List.generate(
      (length / 5).floor(),
      (index) => SizedBox(
        height: 5,
        child: VerticalDivider(
          thickness: thickness,
          color: index % 2 == 0 ? color : Colors.transparent,
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

  static String getDateWithMonthName(String date) =>
      DateFormat("MMMM dd, yyyy").format(
        DateTime.parse(date),
      );

  static String getDateMonthNameYear(String date) {
    final String day = date.split('-')[2].length == 1
        ? '0' + date.split('-')[2]
        : date.split('-')[2];
    final String month = date.split('-')[1].length == 1
        ? '0' + date.split('-')[1]
        : date.split('-')[1];
    return DateFormat('d MMM ' 'yy').format(
      DateTime.parse(date.split('-')[0] + '-' + month + '-' + day),
    );
  }

  static String getDayName(String date) => DateFormat('EEEE').format(
        DateTime.parse(date),
      );

  static String trimLocation(String location) =>
      location.split(',')[location.split(',').length - 3].trim();

  static Future<Uri> generateRefLink() async {
    final DynamicLinkParameters parameters = DynamicLinkParameters(
      uriPrefix: 'https://chennaicabs.page.link',
      link: Uri.parse('https://chennaicabs.com/code?c=${Auth.getUserId()}'),
      androidParameters: AndroidParameters(
        packageName: 'com.cabs.chennaicabs',
        minimumVersion: 125,
      ),
    );

    final ShortDynamicLink shortDynamicUrl = await parameters.buildShortLink();
    return shortDynamicUrl.shortUrl;
  }

  static String getCurrentDate() {
    return DateFormat('yyyy-MM-dd').format(DateTime.now());
  }

  static Future<bool> rideCheck(
      BuildContext context, String time, String date) async {
    final bool anyOngoingBooking = await Database.checkActiveBooking();
    final bool disabled = await Database.checkAccountStatus();
    if (disabled) {
      DialogBox.show(context, 'Your account has been disabled');
      return false;
    } else if (anyOngoingBooking) {
      DialogBox.show(context, 'You already have an active booking');
      return false;
    }
    if (0 <= int.parse(time.split(':')[0]) &&
        int.parse(time.split(':')[0]) < 5) {
      DialogBox.show(context,
          'Booking is not available from 12 AM to 5 AM. Sorry for the inconvenience');
      return false;
    } else if (DateTime.now().isAfter(DateTime.parse(date + 'T' + time))) {
      DialogBox.show(context, 'Select a valid time');
      return false;
    } else {
      return true;
    }
  }

  static String getFormattedTime({
    String? date,
    String? time,
    String? dateTime,
  }) =>
      dateTime == null
          ? DateFormat.jm().format(
              DateTime.parse(date! + 'T' + time!),
            )
          : DateFormat.jm().format(
              DateTime.parse(dateTime),
            );

  static int getNoOfDays(String startDate, String endDate) {
    return DateTime.parse(endDate)
                .difference(
                  DateTime.parse(startDate),
                )
                .inHours ==
            0
        ? 1
        : ((DateTime.parse(endDate)
                        .difference(
                          DateTime.parse(startDate),
                        )
                        .inHours +
                    24) /
                24)
            .floor();
  }

  static int getFormattedDistance(String distance) {
    String result = '';
    if (distance.isNotEmpty) {
      List commaRemoved = distance.split(' ')[0].split(',');
      commaRemoved.forEach((eachDigit) => result += eachDigit);
      return double.parse(result).floor();
    } else {
      return 0;
    }
  }

  static String multiplyDistance(String distance) {
    String result = '';
    List commaRemoved = distance.split(' ')[0].split(',');
    commaRemoved.forEach((eachDigit) => result += eachDigit);
    return (double.parse(result) * 2).toString() + ' km';
  }

  static List<Map> sortByFare(List<Map> carModes, String tripType) {
    Map temp = {};
    for (int i = 0; i < carModes.length; i++) {
      for (int j = i + 1; j < carModes.length; j++) {
        if (tripType != 'rental') {
          if (carModes[i]['fare'] > carModes[j]['fare']) {
            temp = carModes[i];
            carModes[i] = carModes[j];
            carModes[j] = temp;
          }
        } else {
          if (carModes[i]['fare_per_km'] > carModes[j]['fare_per_km']) {
            temp = carModes[i];
            carModes[i] = carModes[j];
            carModes[j] = temp;
          }
        }
      }
    }
    return carModes;
  }

  static String distanceInfo(String distance, {int? noOfDays}) {
    String finalDistance = '';
    if (noOfDays == null) {
      finalDistance =
          getFormattedDistance(distance) > 130 ? distance : '130 km';
    } else {
      finalDistance = getFormattedDistance(distance) > 250 * noOfDays
          ? distance
          : '${250 * noOfDays} km';
    }
    return finalDistance;
  }
}
