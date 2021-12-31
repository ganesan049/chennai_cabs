import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:testing_referral/elements/button.dart';
import 'package:testing_referral/network/database.dart';
import 'package:testing_referral/operations/operations.dart';
import 'package:url_launcher/url_launcher.dart';

class RideHistoryCard extends StatefulWidget {
  final String tripFare;
  final String bookingDateTime;
  final String tripType;
  final String carMode;
  final String from;
  final String to;
  final String tripID;
  final int ratings;
  final String driverName;
  final String otp;
  final String driverNumber;
  final String carName;
  final String carNumber;
  final VoidCallback review;
  final String tripStatus;

  RideHistoryCard(
      {required this.tripFare,
      required this.bookingDateTime,
      required this.tripID,
      required this.tripStatus,
      required this.tripType,
      required this.carMode,
      required this.from,
      required this.to,
      required this.review,
      required this.ratings,
      required this.driverName,
      required this.otp,
      required this.driverNumber,
      required this.carName,
      required this.carNumber});

  @override
  State<RideHistoryCard> createState() => _RideHistoryCardState();
}

class _RideHistoryCardState extends State<RideHistoryCard> {
  final TextEditingController reviewController = TextEditingController();
  final RideHistoryScreenDialogs dialogs = RideHistoryScreenDialogs();

  @override
  void dispose() {
    reviewController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height:
          widget.tripStatus != 'completed' || widget.tripStatus != 'cancelled'
              ? 200
              : widget.driverName.isNotEmpty
                  ? 280
                  : 230,
      padding: EdgeInsets.only(left: 20),
      margin: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
      decoration: BoxDecoration(
        color: Color(0xffFBFBFB),
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.5),
            spreadRadius: 5,
            blurRadius: 7,
            offset: Offset(0, 5), // changes position of shadow
          ),
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            height: 50,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '#${widget.tripID}',
                  style: GoogleFonts.sourceSansPro(fontWeight: FontWeight.bold),
                ),
                Container(
                  padding: EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: Colors.grey.shade300,
                    borderRadius: BorderRadius.horizontal(
                      left: Radius.circular(25),
                    ),
                  ),
                  child: Text(
                    'Rs. ${widget.tripFare}',
                    style:
                        GoogleFonts.sourceSansPro(fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.only(right: 15.0),
                  child: SizedBox(
                    height: 20,
                    child: SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children: [
                          Text(
                            '${widget.from}',
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: GoogleFonts.sourceSansPro(
                                fontWeight: FontWeight.bold, fontSize: 17),
                          ),
                          if (widget.tripType != 'rental')
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 5.0),
                              child: Icon(Icons.arrow_right_alt),
                            ),
                          if (widget.tripType != 'rental')
                            Text(
                              '${widget.to}',
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: GoogleFonts.sourceSansPro(
                                  fontWeight: FontWeight.bold, fontSize: 17),
                            ),
                        ],
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 10.0, bottom: 10),
                  child: Text(
                    '${Operations.getFormattedTime(dateTime: widget.bookingDateTime)}, '
                    '${Operations.getDateWithMonthName(widget.bookingDateTime)}',
                    style: GoogleFonts.sourceSansPro(
                        fontWeight: FontWeight.w500,
                        fontSize: 13,
                        color: Colors.grey),
                  ),
                ),
                Row(
                  children: [
                    Container(
                      padding: EdgeInsets.all(7),
                      decoration: BoxDecoration(
                        color: Colors.grey.shade300,
                        borderRadius: BorderRadius.circular(5),
                      ),
                      child: Text(
                        widget.carMode,
                        style: GoogleFonts.sourceSansPro(
                            color: Colors.black, fontWeight: FontWeight.bold),
                      ),
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    Container(
                      padding: EdgeInsets.all(7),
                      decoration: BoxDecoration(
                        color: Colors.grey.shade300,
                        borderRadius: BorderRadius.circular(5),
                      ),
                      child: Text(
                        widget.tripType.toLowerCase(),
                        style: GoogleFonts.sourceSansPro(
                            color: Colors.black, fontWeight: FontWeight.bold),
                      ),
                    ),
                    if (widget.ratings > -1)
                      SizedBox(
                        width: 10,
                      ),
                    if (widget.ratings > -1)
                      Container(
                        padding: EdgeInsets.all(7),
                        decoration: BoxDecoration(
                          color: Colors.grey.shade300,
                          borderRadius: BorderRadius.circular(5),
                        ),
                        child: Text(
                          '☆ ${widget.ratings + 1}',
                          style: GoogleFonts.sourceSansPro(
                              color: Colors.black, fontWeight: FontWeight.bold),
                        ),
                      ),
                    SizedBox(
                      width: 10,
                    ),
                    Container(
                      padding: EdgeInsets.all(7),
                      decoration: BoxDecoration(
                        color: widget.tripStatus == 'ongoing'
                            ? Colors.orange.shade300
                            : widget.tripStatus == 'completed'
                                ? Colors.green.shade300
                                : Colors.red.shade300,
                        borderRadius: BorderRadius.circular(5),
                      ),
                      child: Text(
                        widget.tripStatus,
                        style: GoogleFonts.sourceSansPro(
                            color: Colors.black, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          widget.tripStatus == 'completed' || widget.tripStatus == 'cancelled'
              ? SizedBox()
              : widget.driverName.isNotEmpty
                  ? Container(
                      height: 70,
                      padding: EdgeInsets.symmetric(horizontal: 10),
                      margin: EdgeInsets.only(right: 20, bottom: 7),
                      decoration: BoxDecoration(
                        color: Colors.grey.shade300,
                        borderRadius: BorderRadius.circular(5),
                      ),
                      child: Row(
                        children: [
                          Container(
                            padding: EdgeInsets.all(7),
                            decoration: BoxDecoration(
                              border: Border.all(color: Colors.black54),
                              shape: BoxShape.circle,
                            ),
                            child: Icon(
                              Icons.person,
                              color: Colors.black54,
                            ),
                          ),
                          Expanded(
                            child: Padding(
                              padding: const EdgeInsets.only(left: 8.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    '${widget.driverName}',
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                    style: GoogleFonts.ptSans(
                                        color: Colors.black54,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  Text(
                                    '${widget.carNumber}',
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                    style: GoogleFonts.ptSans(
                                      color: Colors.black54,
                                      fontSize: 12,
                                    ),
                                  ),
                                  Text(
                                    '${widget.carName}',
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                    style: GoogleFonts.ptSans(
                                      color: Colors.black54,
                                      fontSize: 12,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          Container(
                            padding: EdgeInsets.all(6),
                            margin: EdgeInsets.symmetric(horizontal: 10),
                            decoration: BoxDecoration(
                              border: Border.all(color: Colors.black54),
                              borderRadius: BorderRadius.circular(5),
                            ),
                            child: Text(
                              'OTP ${widget.otp}',
                              style: GoogleFonts.sourceSansPro(
                                  color: Colors.black54,
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                          InkWell(
                            onTap: () async {
                              await launch('tel:${widget.driverNumber}');
                            },
                            child: Container(
                              padding: EdgeInsets.all(7),
                              decoration: BoxDecoration(
                                border: Border.all(color: Colors.black54),
                                shape: BoxShape.circle,
                              ),
                              child: Icon(
                                Icons.call,
                                color: Colors.black54,
                              ),
                            ),
                          ),
                        ],
                      ),
                    )
                  : Padding(
                      padding: const EdgeInsets.only(bottom: 5.0),
                      child: Text(
                        '• Driver has not been assigned to you yet',
                        style: GoogleFonts.ptSans(fontWeight: FontWeight.bold),
                      ),
                    ),
          Container(
            height: 40,
            margin: EdgeInsets.only(right: 5),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                if (widget.tripStatus == 'completed' && widget.ratings < 0)
                  TextButton(
                    onPressed: () => dialogs.showRatingDialog(
                        context, widget.tripID, reviewController),
                    child: Text(
                      'Rate',
                      style: GoogleFonts.sourceSansPro(
                          color: Colors.black, fontWeight: FontWeight.bold),
                    ),
                  ),
                TextButton(
                  onPressed: widget.review,
                  child: Text(
                    'Review',
                    style: GoogleFonts.sourceSansPro(
                        color: Colors.black, fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class RideHistoryScreenDialogs {
  Future<dynamic> showSuccessDialog(
      BuildContext context, String dialogContext) async {
    return showGeneralDialog(
      context: context,
      barrierDismissible: true,
      barrierLabel: '',
      transitionBuilder: (context, firstAnimation, secondAnimation, child) =>
          Transform.scale(
        scale: firstAnimation.value,
        child: child,
      ),
      pageBuilder: (
        context,
        firstAnimation,
        secondAnimation,
      ) =>
          AlertDialog(
        title: Icon(
          Icons.check_circle,
          size: 60,
        ),
        content: Text(
          dialogContext,
          textAlign: TextAlign.center,
          style: GoogleFonts.sourceSansPro(fontWeight: FontWeight.bold),
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        actionsPadding: EdgeInsets.only(bottom: 15),
        actions: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: Button(
              buttonText: 'OK',
              onPress: () => Navigator.pop(context),
            ),
          ),
        ],
      ),
    );
  }

  Future<dynamic> showRatingDialog(BuildContext context, String bookingID,
      TextEditingController controller) async {
    int starCount = -1;
    bool ratingLoading = false;
    return showGeneralDialog(
      context: context,
      barrierDismissible: true,
      barrierLabel: '',
      transitionBuilder: (context, firstAnimation, secondAnimation, child) =>
          Transform.scale(
        scale: firstAnimation.value,
        child: child,
      ),
      pageBuilder: (context, firstAnimation, secondAnimation) =>
          StatefulBuilder(
        builder: (context, setReviewState) => AlertDialog(
          title: Text(
            'How was your ride?',
            textAlign: TextAlign.center,
            style: GoogleFonts.sourceSansPro(fontWeight: FontWeight.bold),
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          content: SizedBox(
            height: 165,
            child: SingleChildScrollView(
              child: Column(
                children: [
                  SizedBox(
                    height: 50,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: List.generate(
                        5,
                        (index) => InkWell(
                          onTap: () => setReviewState(
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
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    child: TextField(
                      maxLines: 3,
                      controller: controller,
                      style: GoogleFonts.ptSans(),
                      decoration: InputDecoration(
                        hintText: 'Leave a comment (optional)',
                        hintStyle: GoogleFonts.ptSans(),
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.grey.shade400),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.grey.shade400),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          actionsPadding: EdgeInsets.only(right: 10),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text(
                'CANCEL',
                style: GoogleFonts.josefinSans(
                    fontWeight: FontWeight.bold, color: Colors.black),
              ),
            ),
            TextButton(
              onPressed: starCount == -1
                  ? null
                  : () async {
                      setReviewState(() => ratingLoading = true);
                      await Database.addRatings(bookingID, starCount,
                          comments: controller.text);
                      Navigator.pop(context);
                    },
              style: TextButton.styleFrom(
                  backgroundColor:
                      starCount == -1 ? Colors.grey : Colors.green),
              child: ratingLoading
                  ? SizedBox(
                      height: 15,
                      width: 15,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        valueColor: AlwaysStoppedAnimation(Colors.white),
                      ),
                    )
                  : Text(
                      'SUBMIT',
                      style: GoogleFonts.josefinSans(
                          fontWeight: FontWeight.bold, color: Colors.white),
                    ),
            ),
          ],
        ),
      ),
    ).whenComplete(
      () {
        if (ratingLoading) {
          showSuccessDialog(
            context,
            'Your rating has been successfully submitted',
          );
        }
      },
    );
  }
}
