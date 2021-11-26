import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:testing_referral/network/auth.dart';
import 'package:testing_referral/screens/contact_us_screen.dart';
import 'package:testing_referral/screens/my_rewards_screen.dart';
import 'package:testing_referral/screens/report_screen.dart';
import 'my_rides_screen.dart';

class OptionScreen extends StatelessWidget {
  const OptionScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height - AppBar().preferredSize.height,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          bottomRight: Radius.circular(40),
          bottomLeft: Radius.circular(40),
        ),
      ),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            SizedBox(
              height: 200,
              child: Stack(
                alignment: Alignment.centerRight,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Container(
                        height: 100,
                        padding: EdgeInsets.only(left: 20, bottom: 20),
                        child: Align(
                          alignment: Alignment.bottomLeft,
                          child: Text(
                            Auth.getName()?? '',
                            style: GoogleFonts.ptSans(
                                fontWeight: FontWeight.bold, fontSize: 25),
                          ),
                        ),
                      ),
                      Container(
                        height: 100,
                        color: Colors.grey.shade200,
                      )
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.only(right: 15.0),
                    child: PhysicalModel(
                      elevation: 3,
                      shape: BoxShape.circle,
                      color: Colors.transparent,
                      child: CircleAvatar(
                        radius: 50,
                        backgroundColor: Colors.grey.shade400,
                        child: Icon(
                          Icons.person,
                          size: 40,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Option(
              optionName: 'My rides',
              optionIcon: Icons.history,
              onTap: () => Navigator.pushNamed(context, MyRidesScreen.myRidesScreen),
            ),
            Option(
              optionName: 'My rewards',
              optionIcon: Icons.paid_outlined,
              onTap: () => Navigator.pushNamed(context, MyRewardsScreen.myRewardsScreen),
            ),
            Option(
              optionName: 'Contact us',
              optionIcon: Icons.phone,
              onTap: () =>
                  Navigator.pushNamed(context, ContactUsScreen.contactUsScreen),
            ),
            Option(
              optionName: 'Report an issue',
              optionIcon: Icons.report,
              onTap: () =>
                  Navigator.pushNamed(context, ReportScreen.reportScreen),
            ),
            Option(
              optionName: 'Sign out',
              optionIcon: Icons.logout,
              onTap: () => Auth.signOut(context),
            ),
          ],
        ),
      ),
    );
  }
}

class Option extends StatelessWidget {
  final String optionName;
  final IconData optionIcon;
  final VoidCallback onTap;

  const Option({
    required this.optionIcon,
    required this.optionName,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 70,
      color: Colors.grey.shade200,
      child: Material(
        type: MaterialType.transparency,
        child: InkWell(
          onTap: onTap,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              ListTile(
                title: Text(
                  optionName,
                  style: GoogleFonts.ptSans(),
                ),
                leading: Icon(optionIcon),
                trailing: Icon(CupertinoIcons.forward),
              ),
              SizedBox(
                height: 5,
                child: Divider(
                  indent: 60,
                  thickness: 1,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
