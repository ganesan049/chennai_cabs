
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:testing_referral/operations/operations.dart';

class TestingScreen extends StatefulWidget {
  static final String testingScreen = 'TestingScreen';

  @override
  State<TestingScreen> createState() => _TestingScreenState();
}

class _TestingScreenState extends State<TestingScreen> {
  bool loading = false;
  int time = 30;

  void timer() {
    time--;
    if (time != 0) {
      Future.delayed(
        Duration(seconds: 1),
        () => setState(() => timer()),
      );
    }
  }

  @override
  void initState() {
    timer();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: Material(
              elevation: 5,
              borderRadius: BorderRadius.circular(30),
              child: Container(
                height: 50,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(30),
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      Colors.green,
                      Color(0xff57C84D),
                      Color(0xff83D475),
                    ],
                  ),
                ),
                child: Material(
                  type: MaterialType.transparency,
                  child: InkWell(
                    borderRadius: BorderRadius.circular(30),
                    onTap: () {
                     Operations.generateRefLink();
                    },
                    child: Center(
                      child: AnimatedSwitcher(
                        duration: Duration(milliseconds: 500),
                        switchInCurve: Curves.decelerate,
                        switchOutCurve: Curves.decelerate,
                        transitionBuilder: (child, animation) =>
                            ScaleTransition(
                          scale: animation,
                          child: child,
                        ),
                        child: loading
                            ? SizedBox(
                                height: 30,
                                width: 30,
                                child: CircularProgressIndicator(
                                  strokeWidth: 3,
                                  valueColor:
                                      AlwaysStoppedAnimation(Colors.white),
                                ),
                              )
                            : time == 0
                                ? Text(
                                    'SUBMIT',
                                    style: GoogleFonts.josefinSans(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  )
                                : Text(
                                    time.toString().length == 2
                                        ? 'Auto reading OTP 00:$time'
                                            .toUpperCase()
                                        : 'Auto reading OTP 00:0$time'
                                            .toUpperCase(),
                                    style: GoogleFonts.josefinSans(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
