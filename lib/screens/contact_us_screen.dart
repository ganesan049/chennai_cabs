import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ContactUsScreen extends StatelessWidget {
  static final String contactUsScreen = 'ContactUsScreen';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.green,
      appBar: AppBar(
        backgroundColor: Colors.green,
        title: Text(
          'CONTACT US',
        ),
        titleTextStyle:
            GoogleFonts.ubuntu(fontWeight: FontWeight.bold, fontSize: 16),
      ),
      body: Column(
        children: [
          Expanded(
            child: Container(
              child: Image.network(
                'https://media.giphy.com/media/RepZNFg82lSV5H5Bbi/giphy.gif',
                height: 100,
                width: 100,
              ),
            ),
          ),
          Container(
            height: MediaQuery.of(context).size.height / 1.7,
            width: MediaQuery.of(context).size.width,
            padding: EdgeInsets.only(top: 20),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.only(
                  topRight: Radius.circular(40),
                  topLeft: Radius.circular(40),
                ),
                color: Colors.white),
            child: Column(
              children: [
                Icon(
                  Icons.phone_android,
                  color: Colors.green,
                  size: 40,
                ),
                SizedBox(
                  height: 10,
                ),
                Text(
                  '+918668190452',
                  style: GoogleFonts.ptSans(
                      fontWeight: FontWeight.bold,
                      fontSize: 17,
                      letterSpacing: 2),
                ),
                TextButton(
                  onPressed: () {},
                  style: ButtonStyle(),
                  child: Text('Call now'),
                ),
                SizedBox(
                  height: 30,
                ),
                Icon(
                  Icons.access_time,
                  color: Colors.green,
                  size: 40,
                ),
                SizedBox(
                  height: 10,
                ),
                Text(
                  'Monday - Sunday',
                  style: GoogleFonts.ptSans(
                      fontWeight: FontWeight.bold,
                      fontSize: 17,
                      letterSpacing: 2),
                ),
                SizedBox(
                  height: 5,
                ),
                Text(
                  '9am - 5pm',
                  style: GoogleFonts.ptSans(
                      fontWeight: FontWeight.bold,
                      fontSize: 17,
                      letterSpacing: 2),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
