import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:testing_referral/elements/car_modes.dart';
import 'package:testing_referral/elements/ride_history_card.dart';
import 'package:testing_referral/network/auth.dart';
import 'package:testing_referral/operations/operations.dart';

class Database {
  static final FirebaseFirestore firestore = FirebaseFirestore.instance;
  static final String name = 'name';
  static final String phoneNumber = 'phone_number';
  static final String referralPoints = 'referral_points';
  static final String referredBy = 'referred_by';
  static final String referralLink = 'referral_link';
  static final String refContext = 'context';
  static final String refDate = 'date';
  static final String refPointsReduced = 'points_reduced';

  static Future<void> createUser(
      String userID, String userName, String referralCode) async {
    final Uri refLink = await Operations.generateRefLink();
    if (referralCode.isNotEmpty) {
      await firestore.collection('profile').doc(referralCode).update(
        {referralPoints: 10},
      );
    }
    await firestore.collection('profile').doc(userID).set(
      {
        name: userName,
        phoneNumber: Auth.getPhoneNumber(),
        referralPoints: 0,
        referredBy: referralCode,
        referralLink: refLink.toString(),
      },
    );
  }

  static Future<Map<String, int>> getTripFare(
      {required String tripType,
      required String carMode,
      required String distance,
      int? noOfDays,
      String? driverFeeFieldPath}) async {
    Map<String, int> fareDetails = {};
    if (tripType == CarModes.oneWay) {
      late int formattedDistance;
      String dist = '';
      List formattedDistanceList = distance.split(' ')[0].toString().split(',');
      formattedDistanceList.forEach(
        (eachDigit) {
          dist += eachDigit;
        },
      );
      formattedDistance =
          double.parse(dist).floor() > 130 ? double.parse(dist).floor() : 130;
      await firestore.collection('fare').doc(tripType).get().then(
        (field) {
          fareDetails['base_fare'] = field[carMode] * formattedDistance;
          fareDetails['driver_fee'] = field['driver_fee'];
          fareDetails['total_fare'] =
              (field[carMode] * formattedDistance) + field['driver_fee'];
        },
      );
    } else if (tripType == CarModes.roundWay) {
      int dist = double.parse(distance.split(' ')[0]).floor() / noOfDays! > 250
          ? double.parse(distance.split(' ')[0]).floor()
          : 250 * noOfDays;
      await firestore.collection('fare').doc(tripType).get().then(
        (field) {
          fareDetails['base_fare'] = field[carMode] * dist;
          fareDetails['driver_fee'] = field[driverFeeFieldPath == null
                  ? 'driver_fee'
                  : driverFeeFieldPath] *
              noOfDays;
          fareDetails['total_fare'] =
              fareDetails['base_fare']! + fareDetails['driver_fee']!;
        },
      );
    }
    return fareDetails;
  }

  static Future<Map<String, dynamic>> getTripFareRental({
    required int distance,
    required int duration,
  }) async {
    Map<String, dynamic> fareDetails = {};
    final remainingDist =
        duration * 10 > distance ? 0 : distance - (duration * 10);
    await firestore.collection('fare').doc('rental').get().then(
      (fare) {
        fareDetails['sedan'] = (fare['sedan_per_hour'] * duration) +
            (fare['sedan_per_km'] * remainingDist);
        fareDetails['suv'] = (fare['suv_per_hour'] * duration) +
            (fare['suv_per_km'] * remainingDist);
      },
    );
    return fareDetails;
  }

  static Future<int> getCarFare(String tripType, String carMode) async {
    int fare = 0;
    await firestore.collection('fare').doc(tripType).get().then(
          (field) => fare = field[carMode],
        );
    return fare;
  }

  static Future<void> addNewTrip({
    required String from,
    required String to,
    required String bookingDate,
    required String tripStartDate,
    required String distance,
    required int driverFee,
    required int baseFare,
    required String fromId,
    required String toId,
    required String carMode,
    required String tripType,
    required String tripStartTime,
    String? tripReturnDate,
  }) async {
    final int total = await getTotalTrips();
    String refId = '';
    await firestore.collection('total_trips').doc('total').update(
      {'total': total + 1},
    );
    await firestore.collection('profile').doc(Auth.getUserId()).get().then(
          (value) => refId = value[referredBy],
        );
    final String bookingID = await Operations.getBookingId();
    final Map<String, dynamic> tripDetails = {
      'booking_id': bookingID,
      'from_address': from,
      'to_address': to,
      'from_id': fromId,
      'to_id': toId,
      'user_id': Auth.getUserId(),
      'trip_status': 'ongoing',
      'referred_by': refId,
      'booking_date': bookingDate,
      'trip_start_date': tripStartDate,
      'distance': distance,
      'timestamp': FieldValue.serverTimestamp(),
      'car_mode': carMode,
      'trip_return_date': tripReturnDate ?? '',
      'driver_fee': driverFee,
      'base_fare': baseFare,
      'time': tripStartTime,
      'driver_accepted': 0,
      'otp': Operations.generateOtp(),
      'from_location': from.split(',')[from.split(',').length - 3].trim(),
      'to_location': to.split(',')[to.split(',').length - 3].trim(),
      'day': DateFormat('EEEE').format(
        DateTime.parse(tripStartDate),
      ),
      'trip_type': tripType == CarModes.oneWay ? 'One Way' : 'Round Trip',
      'total_fare': driverFee + baseFare,
    };
    firestore
        .collection('new_booking')
        .doc(tripDetails['booking_id'])
        .set(tripDetails);
    await firestore
        .collection('profile')
        .doc(Auth.getUserId())
        .collection('trips')
        .doc(tripDetails['booking_id'])
        .set(tripDetails);
  }

  static Future<void> addNewTripRental({
    required String pickUpAddress,
    required String bookingDate,
    required String tripStartDate,
    required String distance,
    required String pickUpAddressID,
    required String carMode,
    required String tripType,
    required int totalFare,
    required String duration,
    required String tripStartTime,
  }) async {
    String refId = await getReferralID();
    await updateTotalTripsCount();
    final String bookingID = await Operations.getBookingId();
    final Map<String, dynamic> tripDetails = {
      'booking_id': bookingID,
      'from_address': pickUpAddress,
      'from_id': pickUpAddressID,
      'user_id': Auth.getUserId(),
      'trip_status': 'ongoing',
      'referred_by': refId,
      'booking_date': bookingDate,
      'trip_start_date': tripStartDate,
      'distance': distance,
      'duration': duration,
      'timestamp': FieldValue.serverTimestamp(),
      'car_mode': carMode,
      'time': tripStartTime,
      'driver_accepted': 0,
      'otp': Operations.generateOtp(),
      'from_location': Operations.trimLocation(pickUpAddress),
      'day': Operations.getMonthName(tripStartDate),
      'trip_type': 'rental',
      'total_fare': totalFare,
    };
    firestore
        .collection('new_booking')
        .doc(tripDetails['booking_id'])
        .set(tripDetails);
    await firestore
        .collection('profile')
        .doc(Auth.getUserId())
        .collection('trips')
        .doc(tripDetails['booking_id'])
        .set(tripDetails);
  }

  static Future<void> updateTotalTripsCount() async {
    int oldTotal = await getTotalTrips();
    await firestore.collection('total_trips').doc('total').update(
      {'total': oldTotal + 1},
    );
  }

  static Future<int> getTotalTrips() async {
    int total = 0;
    await firestore.collection('total_trips').doc('total').get().then(
          (value) => total = value['total'],
        );
    return total;
  }

  static Future<String> getReferralID() async {
    String referralID = '';
    await firestore.collection('profile').doc(Auth.getUserId()).get().then(
          (value) => referralID = value[referredBy],
        );
    return referralID;
  }

  static Future<List<Widget>> getMyRides() async {
    List<Widget> myRides = [];
    await firestore
        .collection('profile')
        .doc(Auth.getUserId())
        .collection('trips')
        .orderBy('timestamp', descending: true)
        .get()
        .then(
          (trips) => trips.docs.forEach(
            (trip) {
              myRides.add(
                RideHistoryCard(
                  tripStatus: trip['trip_status'],
                  tripID: trip['booking_id'],
                  tripFare: trip['total_fare'].toString(),
                  tripDate: trip['trip_start_date'],
                ),
              );
            },
          ),
        );
    return myRides;
  }

  static Future<String> getRefLink() async {
    String refLink = '';
    await firestore.collection('profile').doc(Auth.getUserId()).get().then(
          (value) => refLink = value[referralLink],
        );
    return refLink;
  }

  static Future<String> getRefPoints() async {
    String points = '';
    await firestore.collection('profile').doc(Auth.getUserId()).get().then(
          (value) => points = value[referralPoints].floor().toString(),
        );
    return points;
  }

  static Future<List<Map>> getRefPointsHistory() async {
    List<Map> pointsHistory = [];
    await firestore
        .collection('profile')
        .doc(Auth.getUserId())
        .collection('referral_points')
        .get()
        .then(
          (value) => value.docs.forEach(
            (element) {
              pointsHistory.add(
                {
                  refDate: element[refDate],
                  referralPoints: element[referralPoints].floor().toString(),
                  refContext: element[refContext],
                  refPointsReduced: element[refPointsReduced],
                },
              );
            },
          ),
        );
    return pointsHistory;
  }
}
