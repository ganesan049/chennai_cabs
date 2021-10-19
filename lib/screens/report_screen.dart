import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:testing_referral/elements/button.dart';

class ReportScreen extends StatelessWidget {
  static final String reportScreen = 'ReportScreen';

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.green,
          title: Text(
            'REPORT AN ISSUE',
          ),
          titleTextStyle:
              GoogleFonts.ubuntu(fontWeight: FontWeight.bold, fontSize: 16),
        ),
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                'Report:',
                style: GoogleFonts.ptSans(fontSize: 16),
              ),
              SizedBox(
                height: 10,
              ),
              TextField(
                maxLines: 10,
                decoration: InputDecoration(
                  hintText: 'Write your issue here...',
                  hintStyle: GoogleFonts.ptSans(),
                  enabledBorder: OutlineInputBorder(),
                  focusedBorder: OutlineInputBorder(),
                ),
              ),
              SizedBox(
                height: 30,
              ),
              Button(
                buttonText: 'SUBMIT',
                onPress: () {},
              ),
            ],
          ),
        ),
      ),
    );
  }
}
