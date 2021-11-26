import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class FeedbackScreen extends StatefulWidget {
  static final String feedbackScreen = 'FeedbackScreen';

  const FeedbackScreen({Key? key}) : super(key: key);

  @override
  State<FeedbackScreen> createState() => _FeedbackScreenState();
}

class _FeedbackScreenState extends State<FeedbackScreen> {
  int starCount = 0;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Container(
          height: double.infinity,
          width: double.infinity,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Color(0xff83D475),
                Color(0xff57C84D),
                Colors.green,
              ],
            ),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Your last trip',
                style: GoogleFonts.lato(color: Colors.white),
              ),
              SizedBox(
                height: 5,
              ),
              Text(
                '4:34 PM, November 06 2021',
                style: GoogleFonts.lato(color: Colors.white),
              ),
              SizedBox(
                height: 15,
              ),
              Container(
                height: MediaQuery.of(context).size.height / 1.5,
                width: MediaQuery.of(context).size.width / 1.1,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(15),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black12,
                      spreadRadius: 5,
                      blurRadius: 5,
                      offset: Offset(0, 3), // changes position of shadow
                    ),
                  ],
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.only(top: 0),
                        child: SizedBox(
                          height: 250,
                          child: Column(
                            children: [
                              Text(
                                'How was your last trip to',
                                textAlign: TextAlign.center,
                                style: GoogleFonts.sourceSansPro(),
                              ),
                              SizedBox(
                                height: 50,
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: List.generate(
                                    5,
                                    (index) => InkWell(
                                      onTap: () => setState(
                                        () {
                                          if (starCount == index) {
                                            starCount = -1;
                                          } else {
                                            starCount = index;
                                          }
                                        },
                                      ),
                                      child: Icon(
                                        Icons.star,
                                        size: 30,
                                        color: starCount >= index
                                            ? Colors.yellow
                                            : Colors.black,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 20.0),
                                child: TextField(
                                  maxLines: 3,
                                  style: GoogleFonts.ptSans(),
                                  decoration: InputDecoration(
                                    hintText: 'Leave a comment',
                                    hintStyle: GoogleFonts.ptSans(),
                                    enabledBorder: OutlineInputBorder(
                                      borderSide:
                                          BorderSide(color: Colors.grey.shade400),
                                    ),
                                    focusedBorder: OutlineInputBorder(
                                      borderSide:
                                          BorderSide(color: Colors.grey.shade400),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                   /* Expanded(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 15.0),
                        child: Button(
                          buttonText: 'SUBMIT',
                          onPress: () {},
                        ),
                      ),
                    ),*/
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
