import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:testing_referral/elements/sliding_gradient_transform.dart';

class BookingDetailsLoading extends StatefulWidget {
  static final String testingScreen = 'TestingScreen';

  @override
  State<BookingDetailsLoading> createState() => _BookingDetailsLoadingState();
}

class _BookingDetailsLoadingState extends State<BookingDetailsLoading>
    with SingleTickerProviderStateMixin {
  final TextStyle kDefault = GoogleFonts.ptSans();

  final TextStyle kDefaultBold =
  GoogleFonts.poppins(fontWeight: FontWeight.bold);

  late AnimationController shimmerController;

  @override
  void initState() {
    super.initState();

    shimmerController = AnimationController.unbounded(vsync: this)
      ..repeat(
        min: -0.5,
        max: 1.5,
        period: const Duration(milliseconds: 1000),
      )
      ..addListener(
            () => setState(
              () {},
        ),
      );
  }

  @override
  void dispose() {
    shimmerController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
        body: ShaderMask(
          blendMode: BlendMode.srcATop,
          shaderCallback: (bounds) {
            return LinearGradient(
              colors: [
                Color(0xFFEBEBF4),
                Color(0xFFF4F4F4),
                Color(0xFFEBEBF4),
              ],
              stops: [
                0.1,
                0.3,
                0.4,
              ],
              begin: Alignment(-1.0, -0.3),
              end: Alignment(1.0, 0.3),
              tileMode: TileMode.clamp,
              transform: SlidingGradientTransform(
                  slidePercent: shimmerController.value),
            ).createShader(bounds);
          },
          child: ListView(
            physics: NeverScrollableScrollPhysics(),
            children: [
              Container(
                height: 300,
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Container(
                          height: 150,
                        )
                      ],
                    ),
                    Container(
                      height: 170,
                      padding: EdgeInsets.only(
                          top: 25, bottom: 15, left: 15, right: 15),
                      margin: EdgeInsets.symmetric(horizontal: 20),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.5),
                            spreadRadius: 5,
                            blurRadius: 7,
                            offset: Offset(0, 3), // changes position of shadow
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                height: 30,
                width: 60,
                margin:
                const EdgeInsets.only(left: 15.0, bottom: 10, right: 180),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(15),
                ),
              ),
              SizedBox(
                height: 5,
                child: Divider(
                  indent: 15,
                  endIndent: 15,
                  color: Colors.grey,
                ),
              ),
              Container(
                height: 70,
                margin: EdgeInsets.only(left: 10, right: 10, top: 25),
                padding: EdgeInsets.symmetric(horizontal: 10),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15),
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      Colors.green,
                      Color(0xff57C84D),
                      Color(0xff83D475),
                    ],
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.5),
                      spreadRadius: 3,
                      blurRadius: 5,
                      offset: Offset(0, 3), // changes position of shadow
                    ),
                  ],
                ),
              ),
              Container(
                height: 30,
                width: 60,
                margin: const EdgeInsets.only(
                    left: 15.0, bottom: 10, right: 180, top: 35),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(15),
                ),
              ),
              SizedBox(
                height: 5,
                child: Divider(
                  indent: 15,
                  endIndent: 15,
                  color: Colors.grey,
                ),
              ),
              DetailsTile(kDefault: kDefault, kDefaultBold: kDefaultBold),
              DetailsTile(kDefault: kDefault, kDefaultBold: kDefaultBold),
              DetailsTile(kDefault: kDefault, kDefaultBold: kDefaultBold),
              Container(
                height: 30,
                width: 60,
                margin: const EdgeInsets.only(
                    left: 15.0, bottom: 10, right: 180, top: 35),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(15),
                ),
              ),
              SizedBox(
                height: 5,
                child: Divider(
                  indent: 15,
                  endIndent: 15,
                  color: Colors.grey,
                ),
              ),
              DetailsTile(kDefault: kDefault, kDefaultBold: kDefaultBold),
              DetailsTile(kDefault: kDefault, kDefaultBold: kDefaultBold),
              DetailsTile(kDefault: kDefault, kDefaultBold: kDefaultBold),
            ],
          ),
        ),
      ),
    );
  }
}

class DetailsTile extends StatelessWidget {
  const DetailsTile({
    Key? key,
    required this.kDefault,
    required this.kDefaultBold,
  }) : super(key: key);

  final TextStyle kDefault;
  final TextStyle kDefaultBold;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Container(
        margin: EdgeInsets.only(right: 90),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(15),
        ),
        child: Text(
          'Pickup date',
          style: kDefault,
        ),
      ),
      trailing: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(15),
        ),
        child: Text(
          'November 05, 2021',
          style: kDefaultBold,
        ),
      ),
    );
  }
}
