import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:testing_referral/elements/button.dart';
import 'package:testing_referral/elements/car_modes.dart';

class ReviewScreen {
  static final TextStyle kDefault = GoogleFonts.poppins();
  static final TextStyle kDefaultBold =
      GoogleFonts.poppins(fontWeight: FontWeight.bold);

  static List<Widget> generate(double length) {
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

  static Future<dynamic> show(
      {required BuildContext context,
      required String from,
      required String to,
      required CarModes carModes,
      required String pickUpDate,
      required String pickUptime,
      bool roundTrip = false,
      String? returnDate,
      String? returnTime,
      required String distance}) {
    return showModalBottomSheet(
      context: context,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
      ),
      builder: (context) => Column(
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
                          style:
                              GoogleFonts.ptSans(fontWeight: FontWeight.bold),
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
                        style: GoogleFonts.ptSans(fontWeight: FontWeight.bold),
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
                      child: carModes,
                    ),
                    ListTile(
                      title: Text(
                        'Pickup date',
                        style: kDefault,
                      ),
                      trailing: Text(
                        pickUpDate,
                        style: kDefaultBold,
                      ),
                    ),
                    ListTile(
                      title: Text(
                        'Pickup time',
                        style: kDefault,
                      ),
                      trailing: Text(
                        pickUptime,
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
                          returnDate!,
                          style: kDefaultBold,
                        ),
                      ),
                    if (roundTrip)
                      ListTile(
                        title: Text(
                          'Return time',
                          style: kDefault,
                        ),
                        trailing: Text(
                          returnTime!,
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
                        '₹ 4220',
                        style: kDefaultBold,
                      ),
                    ),
                    ListTile(
                      title: Text(
                        'Driver fee',
                        style: kDefault,
                      ),
                      trailing: Text(
                        '₹ 300',
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
                        '₹ 300',
                        style: kDefaultBold.copyWith(fontSize: 18),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 30.0, vertical: 15),
                      child: Button(
                        onPress: () {},
                        buttonText: 'BOOK YOUR RIDE',
                      ),
                    )
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
