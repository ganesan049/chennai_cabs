import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:url_launcher/url_launcher.dart';

class ContactUsScreen extends StatelessWidget {
  static final String contactUsScreen = 'ContactUsScreen';
  final String whatsapp = 'whatsapp://send?phone=+919841346080';
  final String email =
      'mailto:chennaicabscare@gmail.com?subject=<subject>&body=<body>';
  final String call1 = 'tel:9841346080';
  final String call2 = 'tel:9551114411';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.green,
      appBar: AppBar(
        elevation: 0,
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
              child: CachedNetworkImage(
                imageUrl: 'https://media.giphy.com/media/RepZNFg82lSV5H5Bbi/giphy.gif',
                height: 100,
                width: 100,
                placeholder: (context, none) => SizedBox(
                  height: 15,
                  width: 15,
                  child: Center(
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      valueColor: AlwaysStoppedAnimation(Colors.white),
                    ),
                  ),
                ),
                errorWidget:
                    (context, object, stacktrace) =>
                    SizedBox(
                      height: 40,
                      width: 50,
                      child: Center(
                        child: Icon(Icons.broken_image),
                      ),
                    ),
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
                SizedBox(
                  height: 10,
                ),
                ListTile(
                  title: Text(
                    'Customer support 1',
                    style: GoogleFonts.ptSans(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  leading: Icon(Icons.call_outlined),
                  trailing: TextButton(
                    onPressed: () async => launch(call1),
                    style: TextButton.styleFrom(backgroundColor: Colors.green),
                    child: Text(
                      'Call now'.toUpperCase(),
                      style: GoogleFonts.josefinSans(
                          fontWeight: FontWeight.bold, color: Colors.white),
                    ),
                  ),
                ),
                ListTile(
                  title: Text(
                    'Customer support 2',
                    style: GoogleFonts.ptSans(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  leading: Icon(Icons.call_outlined),
                  trailing: TextButton(
                    onPressed: () async => launch(call2),
                    style: TextButton.styleFrom(backgroundColor: Colors.green),
                    child: Text(
                      'Call now'.toUpperCase(),
                      style: GoogleFonts.josefinSans(
                          fontWeight: FontWeight.bold, color: Colors.white),
                    ),
                  ),
                ),
                ListTile(
                  title: Text(
                    'WhatsApp',
                    style: GoogleFonts.ptSans(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  leading: Icon(Icons.chat_outlined),
                  trailing: TextButton(
                    onPressed: () async => await launch(whatsapp),
                    style: TextButton.styleFrom(backgroundColor: Colors.green),
                    child: Text(
                      'Chat now'.toUpperCase(),
                      style: GoogleFonts.josefinSans(
                          fontWeight: FontWeight.bold, color: Colors.white),
                    ),
                  ),
                ),
                ListTile(
                  title: Text(
                    'Email',
                    style: GoogleFonts.ptSans(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  leading: Icon(Icons.mail_outline_outlined),
                  trailing: TextButton(
                    onPressed: () async => launch(email),
                    style: TextButton.styleFrom(backgroundColor: Colors.green),
                    child: Text(
                      'SEND NOW'.toUpperCase(),
                      style: GoogleFonts.josefinSans(
                          fontWeight: FontWeight.bold, color: Colors.white),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
