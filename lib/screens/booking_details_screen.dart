import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:testing_referral/elements/booking_details_loading.dart';
import 'package:testing_referral/network/database.dart';
import 'package:testing_referral/operations/operations.dart';
import 'package:url_launcher/url_launcher.dart';

class BookingDetailScreen extends StatelessWidget {
  static final String bookingDetailScreen = 'BookingDetailScreen';
  final TextStyle kDefault = GoogleFonts.ptSans();
  final TextStyle kDefaultBold =
      GoogleFonts.poppins(fontWeight: FontWeight.bold);

  final String bookingID;

  BookingDetailScreen({required this.bookingID});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
        body: FutureBuilder<Map<String, dynamic>>(
          future: Database.getBookingDetails(bookingID),
          builder: (context, bookingDetails) {
            if (bookingDetails.hasData) {
              return ListView(
                children: [
                  Container(
                    height: 300,
                    decoration: BoxDecoration(
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
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        Align(
                          alignment: Alignment.topLeft,
                          child: BackButton(
                            color: Colors.white,
                          ),
                        ),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Container(
                              color: Colors.white,
                              height: 150,
                            )
                          ],
                        ),
                        Container(
                          height: 170,
                          padding: EdgeInsets.only(
                              top: 25, bottom: 15, left: 15, right: 15),
                          margin: EdgeInsets.symmetric(horizontal: 20),
                          decoration: BoxDecoration(
                            color: Color(0xffFBFBFB),
                            borderRadius: BorderRadius.circular(10),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey.withOpacity(0.5),
                                spreadRadius: 5,
                                blurRadius: 7,
                                offset:
                                    Offset(0, 3), // changes position of shadow
                              ),
                            ],
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(right: 5.0),
                                child: SizedBox(
                                  height: 20,
                                  child: SingleChildScrollView(
                                    scrollDirection: Axis.horizontal,
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Text(
                                          '${bookingDetails.data!['from_location']}',
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                          style: GoogleFonts.sourceSansPro(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 17),
                                        ),
                                        if (bookingDetails.data!['trip_type'] !=
                                            'rental')
                                          Padding(
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 5.0),
                                            child: Icon(Icons.arrow_right_alt),
                                          ),
                                        if (bookingDetails.data!['trip_type'] !=
                                            'rental')
                                          Text(
                                            '${bookingDetails.data!['to_location']}',
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                            style: GoogleFonts.sourceSansPro(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 17),
                                          ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(
                                    top: 10.0, bottom: 10),
                                child: Text(
                                  '${Operations.getFormattedTime(dateTime: bookingDetails.data!['booking_time'])}, '
                                  '${Operations.getDateWithMonthName(bookingDetails.data!['booking_time'])}',
                                  style: GoogleFonts.sourceSansPro(
                                      fontWeight: FontWeight.w500,
                                      fontSize: 15,
                                      color: Colors.grey),
                                ),
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Container(
                                    padding: EdgeInsets.all(7),
                                    decoration: BoxDecoration(
                                      color: Colors.grey.shade300,
                                      borderRadius: BorderRadius.circular(5),
                                    ),
                                    child: Text(
                                      '#${bookingDetails.data!['booking_id']}',
                                      style: GoogleFonts.sourceSansPro(
                                          color: Colors.black,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                  SizedBox(
                                    width: 10,
                                  ),
                                  Container(
                                    padding: EdgeInsets.all(7),
                                    decoration: BoxDecoration(
                                      color: Colors.grey.shade300,
                                      borderRadius: BorderRadius.circular(5),
                                    ),
                                    child: Text(
                                      '${bookingDetails.data!['car_mode']}',
                                      style: GoogleFonts.sourceSansPro(
                                          color: Colors.black,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                  SizedBox(
                                    width: 10,
                                  ),
                                  Container(
                                    padding: EdgeInsets.all(7),
                                    decoration: BoxDecoration(
                                      color: Colors.grey.shade300,
                                      borderRadius: BorderRadius.circular(5),
                                    ),
                                    child: Text(
                                      '${bookingDetails.data!['trip_type']}',
                                      style: GoogleFonts.sourceSansPro(
                                          color: Colors.black,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  if (bookingDetails.data!['trip_status'] == 'ongoing')
                    Padding(
                      padding: const EdgeInsets.only(left: 15.0, bottom: 10),
                      child: Text(
                        'Driver details',
                        style: kDefaultBold.copyWith(fontSize: 20),
                      ),
                    ),
                  if (bookingDetails.data!['trip_status'] == 'ongoing')
                    SizedBox(
                      height: 5,
                      child: Divider(
                        indent: 15,
                        endIndent: 15,
                        color: Colors.grey,
                      ),
                    ),
                  bookingDetails.data!['driver_name'].isNotEmpty &&
                          bookingDetails.data!['trip_status'] == 'ongoing'
                      ? Container(
                          height: 70,
                          margin: EdgeInsets.only(left: 10, right: 10, top: 25),
                          padding: EdgeInsets.symmetric(horizontal: 10),
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
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey.withOpacity(0.5),
                                spreadRadius: 3,
                                blurRadius: 5,
                                offset:
                                    Offset(0, 3), // changes position of shadow
                              ),
                            ],
                          ),
                          child: Row(
                            children: [
                              Container(
                                padding: EdgeInsets.all(7),
                                decoration: BoxDecoration(
                                  border: Border.all(color: Colors.white),
                                  shape: BoxShape.circle,
                                ),
                                child: Icon(
                                  Icons.person,
                                  color: Colors.white,
                                ),
                              ),
                              Expanded(
                                child: Padding(
                                  padding: const EdgeInsets.only(left: 8.0),
                                  child: Text(
                                    '${bookingDetails.data!['driver_name']}',
                                    style: GoogleFonts.ptSans(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ),
                              ),
                              Container(
                                padding: EdgeInsets.all(6),
                                margin: EdgeInsets.symmetric(horizontal: 10),
                                decoration: BoxDecoration(
                                  border: Border.all(color: Colors.white),
                                  borderRadius: BorderRadius.circular(5),
                                ),
                                child: Text(
                                  'OTP ${bookingDetails.data!['otp']}',
                                  style: GoogleFonts.sourceSansPro(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                              InkWell(
                                onTap: () async {
                                  await launch(
                                      'tel:${bookingDetails.data!['driver_number']}');
                                },
                                child: Container(
                                  padding: EdgeInsets.all(7),
                                  decoration: BoxDecoration(
                                    border: Border.all(color: Colors.white),
                                    shape: BoxShape.circle,
                                  ),
                                  child: Icon(
                                    Icons.call,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        )
                      : bookingDetails.data!['trip_status'] == 'ongoing'
                          ? SizedBox(
                              height: 70,
                              child: Center(
                                child: Text('Driver has not been assigned yet'),
                              ),
                            )
                          : SizedBox(),
                  Padding(
                    padding:
                        const EdgeInsets.only(left: 15.0, top: 20, bottom: 10),
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
                  ListTile(
                    title: Text(
                      'Pickup date',
                      style: kDefault,
                    ),
                    trailing: Text(
                      '${Operations.getDateWithMonthName(bookingDetails.data!['trip_start_date'])}',
                      style: kDefaultBold,
                    ),
                  ),
                  ListTile(
                    title: Text(
                      'Pickup time',
                      style: kDefault,
                    ),
                    trailing: Text(
                      '${bookingDetails.data!['time']}',
                      style: kDefaultBold,
                    ),
                  ),
                  if (bookingDetails.data!['trip_type'] == 'round_way')
                    ListTile(
                      title: Text(
                        'Return date',
                        style: kDefault,
                      ),
                      trailing: Text(
                        '${bookingDetails.data!['trip_return_date']}',
                        style: kDefaultBold,
                      ),
                    ),
                  if (bookingDetails.data!['trip_type'] != 'rental')
                    ListTile(
                      title: Text(
                        'Distance',
                        style: kDefault,
                      ),
                      trailing: Text(
                        '${bookingDetails.data!['distance']}',
                        style: kDefaultBold,
                      ),
                    ),
                  Padding(
                    padding:
                        const EdgeInsets.only(left: 15.0, top: 20, bottom: 10),
                    child: Text(
                      bookingDetails.data!['trip_type'] == 'rental'
                          ? 'Package details'
                          : 'Fare details',
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
                  if (bookingDetails.data!['trip_type'] == 'rental')
                    ListTile(
                      title: Text(
                        'Distance',
                        style: kDefault,
                      ),
                      trailing: Text(
                        '${bookingDetails.data!['distance']}',
                        style: kDefaultBold,
                      ),
                    ),
                  if (bookingDetails.data!['trip_type'] == 'rental')
                    ListTile(
                      title: Text(
                        'Duration',
                        style: kDefault,
                      ),
                      trailing: Text(
                        '${bookingDetails.data!['duration']}',
                        style: kDefaultBold,
                      ),
                    ),
                  if (bookingDetails.data!['trip_type'] != 'rental')
                    ListTile(
                      title: Text(
                        'Base fare',
                        style: kDefault,
                      ),
                      trailing: Text(
                        bookingDetails.data!['trip_status'] == 'completed'
                            ? '₹ ${bookingDetails.data!['base_fare'] + bookingDetails.data!['reward_points']}'
                            : '₹ ${bookingDetails.data!['base_fare']}',
                        style: kDefaultBold,
                      ),
                    ),
                  if (bookingDetails.data!['trip_type'] != 'rental')
                    ListTile(
                      title: Text(
                        'Driver fee',
                        style: kDefault,
                      ),
                      trailing: Text(
                        '₹ ${bookingDetails.data!['driver_fee']}',
                        style: kDefaultBold,
                      ),
                    ),
                  ListTile(
                    title: Text(
                      'Reward points',
                      style: kDefault,
                    ),
                    trailing: Text(
                      '- ₹ ${bookingDetails.data!['reward_points']}',
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
                    title: Text(
                      'Subtotal',
                      style: kDefault.copyWith(fontSize: 15),
                    ),
                    trailing: Text(
                      bookingDetails.data!['trip_status'] == 'completed'
                          ? '₹ ${bookingDetails.data!['subtotal'] + bookingDetails.data!['reward_points']}'
                          : '₹ ${bookingDetails.data!['subtotal']}',
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
                    title: Text(
                      'Total fare',
                      style: kDefaultBold.copyWith(fontSize: 18),
                    ),
                    trailing: Text(
                      bookingDetails.data!['trip_status'] == 'completed'
                          ? '₹ ${bookingDetails.data!['total_fare']}'
                          : '₹ ${bookingDetails.data!['total_fare'] - bookingDetails.data!['reward_points']}',
                      style: kDefaultBold.copyWith(fontSize: 18),
                    ),
                  ),
                ],
              );
            } else {
              return BookingDetailsLoading();
            }
          },
        ),
      ),
    );
  }
}
