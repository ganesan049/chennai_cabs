import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:flutter/painting.dart';
import 'package:share_plus/share_plus.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter/services.dart';
import 'package:testing_referral/elements/button.dart';

class ReferralScreen extends StatefulWidget {
  static final String referralScreen = '/ReferralScreen';

  @override
  _ReferralScreenState createState() => _ReferralScreenState();
}

class _ReferralScreenState extends State<ReferralScreen> {
  String? refCode = '';
  final TextEditingController controller = TextEditingController();

  @override
  void initState() {
    super.initState();
    this.initDynamicLinks();
  }

  void initDynamicLinks() async {
    FirebaseDynamicLinks.instance.onLink(
        onSuccess: (PendingDynamicLinkData? dynamicLink) async {
      final Uri? deepLink = dynamicLink?.link;

      if (deepLink != null) {
        refCode = deepLink.queryParameters['c'];
        controller.text = refCode!;
      }
    }, onError: (OnLinkErrorException e) async {
      print('onLinkError');
      print(e.message);
    });

    final PendingDynamicLinkData? data =
        await FirebaseDynamicLinks.instance.getInitialLink();
    final Uri? deepLink = data?.link;

    if (deepLink != null) {
      refCode = deepLink.queryParameters['c'];
      controller.text = refCode!;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
        children: [
          Expanded(
            child: Stack(
              alignment: Alignment.topCenter,
              children: [
                Container(
                  color: Colors.transparent,
                  child: Image.asset(
                    'images/referral.png',
                    height: 300,
                    width: 300,
                  ),
                ),
              ],
            ),
          ),
          Container(
            height: MediaQuery.of(context).size.height / 1.7,
            width: MediaQuery.of(context).size.width,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(40),
                color: Colors.white),
            child: Padding(
              padding: const EdgeInsets.all(30),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    'Refer now & earn 1% of your friend\'s spending',
                    textAlign: TextAlign.center,
                    style: GoogleFonts.ptSans(
                        fontWeight: FontWeight.bold, fontSize: 20),
                  ),
                  Text(
                    'Share your unique referral link with your friends via SMS/ Email / Whatsapp',
                    textAlign: TextAlign.center,
                    style: GoogleFonts.ptSans(),
                  ),
                  Container(
                    child: Column(
                      children: [
                        Text(
                          'Your unique referral link',
                          textAlign: TextAlign.center,
                        ),
                        Container(
                          height: 50,
                          margin: EdgeInsets.only(top: 10),
                          decoration:
                              BoxDecoration(color: Colors.grey.shade300),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Text(
                                'https://exampletesting.page.link/y1E4',
                                style: GoogleFonts.ptSans(),
                              ),
                              Material(
                                type: MaterialType.transparency,
                                child: InkWell(
                                  splashColor: Colors.black12,
                                  onTap: () {
                                    Clipboard.setData(
                                      ClipboardData(
                                          text:
                                              'https://exampletesting.page.link/y1E4'),
                                    );
                                    final SnackBar snackBar = SnackBar(
                                      content: Text('Copied to clipboard'),
                                      duration: Duration(milliseconds: 1500),
                                    );
                                    ScaffoldMessenger.of(context)
                                        .showSnackBar(snackBar);
                                  },
                                  child: Icon(
                                    Icons.copy,
                                    size: 20,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  Button(
                    buttonText: 'INVITE NOW',
                    onPress: () {
                      Share.share(
                          'https://exampletesting.page.link/y1E4');
                    },
                  ),
                ],
              ),
            ),
          ),
        ],
    );
  }
}
