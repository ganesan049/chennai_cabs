import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:chennai_cabs_dev/elements/button.dart';
import 'package:chennai_cabs_dev/elements/keys.dart';
import 'package:chennai_cabs_dev/network/auth.dart';
import 'package:chennai_cabs_dev/operations/operations.dart';
import 'package:url_launcher/url_launcher.dart';
import '../elements/auth_screen_template.dart';

class AuthInputScreen extends StatefulWidget {
  static final String authInputScreen = 'AuthInputScreen';

  @override
  State<AuthInputScreen> createState() => _AuthInputScreenState();
}

class _AuthInputScreenState extends State<AuthInputScreen> {
  final TextEditingController numberController = TextEditingController();

  final FocusNode focusNode = FocusNode();
  String referralCode = '';
  bool loading = false;
  late int resendToken;

  @override
  void initState() {
    super.initState();
    this.initDynamicLinks();
  }

  @override
  void dispose() {
    numberController.dispose();
    super.dispose();
  }

  void initDynamicLinks() async {
    FirebaseDynamicLinks.instance.onLink(
        onSuccess: (PendingDynamicLinkData? dynamicLink) async {
          final Uri? deepLink = dynamicLink?.link;

          if (deepLink != null) {
            referralCode = deepLink.queryParameters['c']!;
          }
        }, onError: (OnLinkErrorException e) async {
      print('onLinkError');
      print(e.message);
    });

    final PendingDynamicLinkData? data =
    await FirebaseDynamicLinks.instance.getInitialLink();
    final Uri? deepLink = data?.link;

    if (deepLink != null) {
      referralCode = deepLink.queryParameters['c']!;
    }
  }

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
                  referralCode: referralCode,
                  phoneNumber: numberController.text.trim(),
                  onError: (bool value) =>
                      setState(() => loading = value),
                );
              }
            },
          ),
          SizedBox(
            height: 20,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'By continuing you are agreeing to our',
                  style: GoogleFonts.ptSans(fontSize: 12),
                ),
                SizedBox(width: 3,),
                InkWell(
                  onTap: () async =>
                  await launch(
                      'https://github.com/suvindran3/privacy_policy/blob/main/policy.md'),
                  child: Text(
                    'Terms & Conditions',
                    style: GoogleFonts.ptSans(
                        color: Colors.green, fontSize: 12),
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
