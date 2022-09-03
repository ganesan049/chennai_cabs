import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:chennai_cabs_dev/elements/button.dart';
import 'package:chennai_cabs_dev/network/database.dart';
import 'package:chennai_cabs_dev/screens/contact_us_screen.dart';

class ReportScreen extends StatefulWidget {
  static final String reportScreen = 'ReportScreen';

  @override
  State<ReportScreen> createState() => _ReportScreenState();
}

class _ReportScreenState extends State<ReportScreen> {
  bool loading = false;
  bool buttonDisabled = true;
  final TextEditingController controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
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
              style: GoogleFonts.ptSans(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            SizedBox(
              height: 10,
            ),
            TextField(
              maxLines: 10,
              controller: controller,
              style: GoogleFonts.ptSans(),
              decoration: InputDecoration(
                hintText: 'Write your issue here...',
                hintStyle: GoogleFonts.ptSans(),
                enabledBorder: OutlineInputBorder(),
                focusedBorder: OutlineInputBorder(),
              ),
              onChanged: (value) {
                if (value.isEmpty) {
                  if (!buttonDisabled) {
                    setState(() => buttonDisabled = true);
                  }
                } else {
                  if (buttonDisabled) {
                    setState(() => buttonDisabled = false);
                  }
                }
              },
            ),
            Padding(
              padding: const EdgeInsets.only(top: 15.0),
              child: SizedBox(
                height: 40,
                child: RichText(
                  text: TextSpan(
                    text: 'Note: If you\'re having any issues regarding '
                        'your booking, ',
                    style:
                        GoogleFonts.ptSans(color: Colors.grey, fontSize: 12),
                    children: [
                      TextSpan(
                        text: 'contact us ',
                        style: GoogleFonts.ptSans(
                            color: Colors.green, fontWeight: FontWeight.bold),
                        recognizer: TapGestureRecognizer()
                          ..onTap = () => Navigator.pushReplacementNamed(
                              context, ContactUsScreen.contactUsScreen),
                      ),
                      TextSpan(
                        text: 'for a quick solution.',
                      ),
                    ],
                  ),
                ),
              ),
            ),
            SizedBox(
              height: 20,
            ),
            Button(
              disabled: buttonDisabled,
              loading: loading,
              buttonText: 'SUBMIT',
              onPress: submit,
            ),
          ],
        ),
      ),
    );
  }

  void submit() async {
    if (controller.text.isNotEmpty) {
      setState(() => loading = true);
      await Database.sendReport(controller.text);
      controller.clear();
      setState(() => loading = false);
      final SnackBar snackBar = SnackBar(
        content: Text(
          'Report has been submitted',
          style: GoogleFonts.ptSans(),
        ),
        behavior: SnackBarBehavior.floating,
      );
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    }
  }
}
