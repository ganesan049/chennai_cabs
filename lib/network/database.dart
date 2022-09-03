import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:chennai_cabs_dev/elements/car_modes_card.dart';
import 'package:chennai_cabs_dev/elements/ride_history_card.dart';
import 'package:chennai_cabs_dev/network/auth.dart';
import 'package:chennai_cabs_dev/network/notification.dart';
import 'package:chennai_cabs_dev/operations/operations.dart';
import 'package:chennai_cabs_dev/screens/booking_details_screen.dart';

class Database {
  static final FirebaseFirestore firestore = FirebaseFirestore.instance;
  static final String name = 'name';
  static final String phoneNumber = 'phone_number';
  static final String refPoints = 'referral_points';
  static final String referredBy = 'referred_by';
  static final String referralLink = 'referral_link';
  static final String totalPoints = 'total_points';
  static final String refContext = 'context';
  static final String refDate = 'date';
  static final String refPointsReduced = 'points_reduced';
  static final String notificationToken = 'notification_token';

  static Future<void> createUser(
      String userID, String userName, String referralCode) async {
    final Uri refLink = await Operations.generateRefLink();
    final String token = await PushNotification.getNotificationToken();
    await firestore.collection('profile').doc(userID).set(
      {
        name: userName,
        phoneNumber: Auth.getPhoneNumber(),
        refPoints: 0,
        notificationToken: token,
        totalPoints: 0,
        'disabled': false,
        referredBy: referralCode,
        referralLink: refLink.toString(),
      },
    );
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
    required int rewardPoints,
    required bool useRewardPoints,
    required String carMode,
    required String tripType,
    required String tripStartTime,
    String? tripReturnDate,
  }) async {
    String refId = await getReferralID();
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
      'reward_points': useRewardPoints? rewardPoints : 0,
      'booking_date': bookingDate,
      'trip_start_date': tripStartDate,
      'distance': distance,
      'timestamp': FieldValue.serverTimestamp(),
      'car_mode': carMode,
      'ratings': -1,
      'trip_return_date': tripReturnDate ?? '',
      'driver_fee': driverFee,
      'phone_number': Auth.getPhoneNumber(),
      'base_fare': baseFare,
      'user_name': Auth.getUserName(),
      'driver_name': '',
      'driver_number': '',
      'car_name': '',
      'car_number': '',
      'booking_time': DateTime.now().toString(),
      'time':
          Operations.getFormattedTime(date: tripStartDate, time: tripStartTime),
      'driver_accepted': 0,
      'otp': Operations.generateOtp(),
      'from_location': Operations.trimLocation(from),
      'to_location': Operations.trimLocation(to),
      'day': Operations.getDayName(tripStartDate),
      'trip_type': tripType == CarModesCard.oneWay ? 'one_way' : 'round_way',
      'subtotal': driverFee + baseFare,
      'total_fare': useRewardPoints? driverFee + baseFare - rewardPoints : driverFee + baseFare,
    };
    firestore
        .collection('new_booking')
        .doc(tripDetails['booking_id'])
        .set(tripDetails);
    await addNewTripToProfile(tripDetails);
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
    required int rewardPoints,
    required String duration,
    required bool useRewardPoints,
    required String tripStartTime,
  }) async {
    String refId = await getReferralID();
    final String bookingID = await Operations.getBookingId();
    final Map<String, dynamic> tripDetails = {
      'booking_id': bookingID,
      'from_address': pickUpAddress,
      'from_id': pickUpAddressID,
      'user_id': Auth.getUserId(),
      'trip_status': 'ongoing',
      'referred_by': refId,
      'phone_number': Auth.getPhoneNumber(),
      'booking_date': bookingDate,
      'trip_start_date': tripStartDate,
      'distance': distance,
      'duration': duration,
      'driver_name': '',
      'ratings': -1,
      'user_name': Auth.getUserName(),
      'driver_number': '',
      'reward_points': useRewardPoints? rewardPoints : 0,
      'timestamp': FieldValue.serverTimestamp(),
      'car_mode': carMode,
      'trip_return_date': '',
      'time':
          Operations.getFormattedTime(date: tripStartDate, time: tripStartTime),
      'driver_accepted': 0,
      'otp': Operations.generateOtp(),
      'booking_time': DateTime.now().toString(),
      'from_location': Operations.trimLocation(pickUpAddress),
      'day': Operations.getDayName(tripStartDate),
      'trip_type': 'rental',
      'subtotal': totalFare,
      'car_name': '',
      'car_number': '',
      'total_fare': useRewardPoints? totalFare - rewardPoints : totalFare,
    };
    firestore
        .collection('new_booking')
        .doc(tripDetails['booking_id'])
        .set(tripDetails);
    await addNewTripToProfile(tripDetails);
  }

  static Future<void> addNewTripToProfile(
      Map<String, dynamic> tripDetails) async {
    await firestore
        .collection('profile')
        .doc(Auth.getUserId())
        .collection('trips')
        .doc(tripDetails['booking_id'])
        .set(tripDetails);
  }

  static Future<bool> checkActiveBooking() async {
    bool check = false;
    await firestore
        .collection('profile')
        .doc(Auth.getUserId())
        .collection('trips')
        .orderBy('timestamp', descending: true)
        .limit(1)
        .get()
        .then(
          (value) => value.docs.forEach(
            (element) =>
                check = element['trip_status'] == 'ongoing' ? true : false,
          ),
        );
    return check;
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

  static Future<List<Widget>> getMyRides(BuildContext context) async {
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
                  tripType: trip['trip_type'],
                  tripStatus: trip['trip_status'],
                  tripID: trip['booking_id'],
                  tripFare: trip['total_fare'].toString(),
                  bookingDateTime: trip['booking_time'],
                  to: trip['trip_type'] == 'rental' ? '' : trip['to_location'],
                  carMode: trip['car_mode'],
                  from: trip['from_location'],
                  ratings: trip['ratings'],
                  driverName: trip['driver_name'],
                  driverNumber: trip['driver_number'],
                  otp: trip['otp'],
                  carName: trip['car_name'],
                  carNumber: trip['car_number'],
                  review: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                          BookingDetailScreen(bookingID: trip.id),
                    ),
                  ),
                ),
              );
            },
          ),
        );
    return myRides;
  }

  static Future<Map<String, dynamic>> getBookingDetails(
      String bookingID) async {
    Map<String, dynamic> bookingDetails = {};
    await firestore
        .collection('profile')
        .doc(Auth.getUserId())
        .collection('trips')
        .doc(bookingID)
        .get()
        .then((value) => bookingDetails = value.data()!);
    return bookingDetails;
  }

  static Future<String> getRefLink() async {
    String refLink = '';
    await firestore.collection('profile').doc(Auth.getUserId()).get().then(
          (value) => refLink = value[referralLink],
        );
    return refLink;
  }

  static Future<int> getRefPoints() async {
    int points = 0;
    await firestore.collection('profile').doc(Auth.getUserId()).get().then(
          (value) => points = value[refPoints].floor(),
        );
    return points;
  }

  static Future<List<Map>> getRefPointsHistory() async {
    List<Map> pointsHistory = [];
    await firestore
        .collection('profile')
        .doc(Auth.getUserId())
        .collection('referral_points')
        .orderBy('timestamp', descending: true)
        .get()
        .then(
          (value) => value.docs.forEach(
            (element) {
              pointsHistory.add(
                {
                  refDate: element[refDate],
                  refPoints: element[refPoints].floor().toString(),
                  refContext: element[refContext],
                  refPointsReduced: element[refPointsReduced],
                },
              );
            },
          ),
        );
    return pointsHistory;
  }

  static Future<List<Map>> getCarModes(String tripType) async {
    List<Map> carModes = [];
    await firestore.collection('car_modes').doc(tripType).get().then(
          (value) => value.data()!.forEach((key, value) => carModes.add(value)),
        );
    return Operations.sortByFare(carModes, tripType);
  }

  static Future<Map> getCarMode(String tripType, String carMode) async {
    Map details = {};
    await firestore.collection('car_modes').doc(tripType).get().then(
          (value) => details = value[carMode],
        );
    return details;
  }

  static Future<void> addRatings(String bookingID, int ratings,
      {String? comments}) async {
    await firestore
        .collection('profile')
        .doc(Auth.getUserId())
        .collection('trips')
        .doc(bookingID)
        .update(
      {'ratings': ratings, 'comments': comments ?? ''},
    );
  }

  static Future<void> sendReport(String report) async =>
      await firestore.collection('reports').add(
        {'report': report},
      );

  static Future<int> getTotalPoints() async {
    int points = 0;
    await firestore.collection('profile').doc(Auth.getUserId()).get().then(
          (value) => points = value.data()![totalPoints],
        );
    return points;
  }

  static Future<bool> checkAccountStatus() async {
    bool status = await firestore
        .collection('profile')
        .doc(Auth.getUserId())
        .get()
        .then((value) => value.data()!['disabled']);
    return status;
  }

  static Future<String> getAppVersion() async {
    final String version = await firestore
        .collection('version')
        .doc('customer_app')
        .get()
        .then((value) => value['version']);
    return version;
  }
}
