import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:testing_referral/elements/auth_screen_template.dart';
import 'package:testing_referral/elements/button.dart';
import 'package:testing_referral/network/auth.dart';
import '../elements/otp_textfield.dart';

class AuthVerifyScreen extends StatefulWidget {
  const AuthVerifyScreen({this.phoneNumber});

  static final String authVerifyScreen = 'AuthVerifyScreen';
  final String? phoneNumber;

  @override
  State<AuthVerifyScreen> createState() => _AuthVerifyScreenState();
}

class _AuthVerifyScreenState extends State<AuthVerifyScreen> {
  bool loading = false;

  @override
  Widget build(BuildContext context) {
    return AuthScreenTemplate(
      screenTitle: 'Enter verification code',
      header1: 'Enter OTP',
      header2: 'We have a sent a OTP message on your number',
      gifURL: 'https://media.giphy.com/media/j6waMWSdaXW5SYp0Id/giphy.gif',
      elements: [
        Container(
          height: 90,
          child: Column(
            children: [
              Container(
                height: 60,
                child: Row(
                  children: OTPTextField.generate(6),
                ),
              ),
              Container(
                height: 15,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Text(
                      'Auto reading OTP',
                      style: GoogleFonts.ptSans(fontSize: 11),
                    ),
                    SizedBox(
                      width: 5,
                    ),
                    SizedBox(
                      height: 10,
                      width: 10,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        valueColor: AlwaysStoppedAnimation(Colors.green),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        Button(
          loading: loading,
          buttonText: 'SUBMIT',
          onPress: loading
              ? () => null
              : () {
                  bool validator = true;
                  for (var key in OTPTextField.keys) {
                    validator = key.currentState!.validate();
                  }
                  if (validator) {
                    setState(() => loading = true);
                    String otp = '';
                    OTPTextField.otpControllers.forEach(
                      (controller) => otp = otp + controller.text.trim(),
                    );
                    Auth.signInWithOTP(
                      otp,
                      context,
                      (status) => setState(() => loading = status),
                    );
                  }
                },
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Did not receive the code?',
              style: GoogleFonts.ptSans(),
            ),
            SizedBox(
              width: 5,
            ),
            InkWell(
              onTap: () {
                Auth.signIn(
                  phoneNumber: widget.phoneNumber!,
                  buildContext: context,
                  onError: (status) => setState(() => loading = status),
                );
              },
              child: Text(
                'Send again',
                style: GoogleFonts.ptSans(fontWeight: FontWeight.bold),
              ),
            ),
          ],
        )
      ],
    );
  }
}
