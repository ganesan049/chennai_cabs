import 'package:flutter/material.dart';
import 'package:share_plus/share_plus.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter/services.dart';
import 'package:testing_referral/elements/button.dart';
import 'package:testing_referral/network/database.dart';

class ReferralScreen extends StatefulWidget {
  static final String referralScreen = '/ReferralScreen';

  @override
  _ReferralScreenState createState() => _ReferralScreenState();
}

class _ReferralScreenState extends State<ReferralScreen> {
  String refLink = '';

  @override
  void initState() {
    getRefLink();
    super.initState();
  }

  void getRefLink() async {
    final String link = await Database.getRefLink();
   if(mounted){
     setState(() => refLink = link);
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
              borderRadius: BorderRadius.circular(40), color: Colors.white),
          child: Padding(
            padding: const EdgeInsets.all(30),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  'Refer now & earn rewards',
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
                        padding: EdgeInsets.only(left: 10),
                        decoration: BoxDecoration(color: Colors.grey.shade300),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Expanded(
                              flex: 8,
                              child: Text(
                                refLink,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: GoogleFonts.ptSans(
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                            Expanded(
                              flex: 2,
                              child: Material(
                                type: MaterialType.transparency,
                                child: InkWell(
                                  splashColor: Colors.black12,
                                  onTap: () {
                                    Clipboard.setData(
                                      ClipboardData(text: refLink),
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
                    Share.share(refLink);
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
