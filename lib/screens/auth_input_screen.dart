import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:testing_referral/elements/button.dart';
import 'package:testing_referral/elements/keys.dart';
import 'package:testing_referral/network/auth.dart';
import 'package:testing_referral/operations/operations.dart';
import '../elements/auth_screen_template.dart';

class AuthInputScreen extends StatefulWidget {
  static final String authInputScreen = 'AuthInputScreen';

  @override
  State<AuthInputScreen> createState() => _AuthInputScreenState();
}

class _AuthInputScreenState extends State<AuthInputScreen> {
  final TextEditingController numberController = TextEditingController();

  final FocusNode focusNode = FocusNode();

  bool loading = false;

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () => Operations.exit(context),
      child: AuthScreenTemplate(
        screenTitle: 'OTP Verification',
        header1: 'Enter your mobile number',
        header2: 'We will send you a OTP message',
        gifURL: 'https://media.giphy.com/media/VqCF8gjbWCXm7sdj3Z/giphy.gif',
        elements: [
          Form(
            key: Keys.numberValidatorKey,
            child: TextFormField(
              focusNode: focusNode,
              controller: numberController,
              validator: (input) {
                if (input!.length != 10) {
                  return 'enter a valid phone number';
                }
              },
              onChanged: (input) {
                if (input.length == 10) {
                  focusNode.unfocus();
                }
              },
              style: GoogleFonts.ptSans(fontWeight: FontWeight.bold),
              inputFormatters: [
                FilteringTextInputFormatter.digitsOnly,
                LengthLimitingTextInputFormatter(10),
              ],
              keyboardType: TextInputType.number,
              cursorColor: Colors.black38,
              decoration: InputDecoration(
                prefixText: '+91',
                hintText: 'Enter your phone number',
                prefixStyle: GoogleFonts.ptSans(
                    fontWeight: FontWeight.bold, fontSize: 15),
                hintStyle: GoogleFonts.ptSans(),
                focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.black, width: 1),
                ),
              ),
            ),
          ),
          Button(
            buttonText: 'SEND OTP',
            loading: loading,
            onPress: loading
                ? () => null
                : () {
                    if (Keys.numberValidatorKey.currentState!.validate()) {
                      setState(() => loading = true);
                      Auth.signIn(
                        buildContext: context,
                        phoneNumber: numberController.text.trim(),
                        onError: (bool value) =>
                            setState(() => loading = value),
                      );
                    }
                  },
          ),
        ],
      ),
    );
  }
}
