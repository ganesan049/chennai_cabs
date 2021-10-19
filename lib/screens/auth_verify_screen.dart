import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:testing_referral/elements/auth_screen_template.dart';
import 'package:testing_referral/elements/button.dart';
import 'package:testing_referral/elements/keys.dart';
import 'package:testing_referral/network/auth.dart';
import '../elements/otp_textfield.dart';

class AuthVerifyScreen extends StatefulWidget {
  const AuthVerifyScreen(
      {this.phoneNumber, this.resendToken, this.referralCode});

  static final String authVerifyScreen = 'AuthVerifyScreen';
  final String? phoneNumber;
  final int? resendToken;
  final String? referralCode;

  @override
  State<AuthVerifyScreen> createState() => _AuthVerifyScreenState();
}

class _AuthVerifyScreenState extends State<AuthVerifyScreen> {
  bool loading = false;
  bool sendAgain = false;
  bool autoRead = true;
  int sendAgainTime = 59;
  int autoReadTime = 30;

  void autoReadTimer() {
    autoReadTime--;
    if (autoReadTime != 0) {
      Future.delayed(
        Duration(seconds: 1),
        () => setState(() => sendAgainTimer()),
      );
    } else {
      autoReadTime = 30;
      setState(() => autoRead = false);
    }
  }

  void sendAgainTimer() {
    sendAgainTime--;
    if (sendAgainTime != 0) {
      Future.delayed(
        Duration(seconds: 1),
        () => setState(() => sendAgainTimer()),
      );
    } else {
      sendAgainTime = 59;
      setState(() => sendAgain = true);
    }
  }

  @override
  void initState() {
    autoReadTimer();
    sendAgainTimer();
    super.initState();
  }

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
                child: Form(
                  key: Keys.otpValidatorKey,
                  child: Row(
                    children: OTPTextField.generate(6),
                  ),
                ),
              ),
              if (autoRead)
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
                  if (Keys.otpValidatorKey.currentState!.validate()) {
                    setState(() => loading = true);
                    String otp = '';
                    OTPTextField.otpControllers.forEach(
                      (controller) => otp = otp + controller.text.trim(),
                    );
                    Auth.signInWithOTP(
                      otp,
                      context,
                      (status) => setState(() => loading = status),
                      widget.referralCode!,
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
            TextButton(
              onPressed: !sendAgain
                  ? () => null
                  : () => Auth.signIn(
                        phoneNumber: widget.phoneNumber!,
                        buildContext: context,
                        referralCode: widget.referralCode!,
                        resendingToken: widget.resendToken,
                        onError: (status) => setState(() => loading = status),
                      ),
              child: Text(
                sendAgain
                    ? 'Send again'
                    : sendAgainTime.toString().length > 1
                        ? 'Send again in 00:$sendAgainTime'
                        : 'Send again in 00:0$sendAgainTime',
                style: GoogleFonts.ptSans(
                    fontWeight: FontWeight.bold, color: Colors.black),
              ),
            ),
          ],
        )
      ],
    );
  }
}
