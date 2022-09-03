import 'package:flutter/material.dart';
import 'package:chennai_cabs_dev/elements/sliding_gradient_transform.dart';

class MyRidesScreenLoading extends StatefulWidget {
  const MyRidesScreenLoading({Key? key}) : super(key: key);

  @override
  State<MyRidesScreenLoading> createState() => _MyRidesScreenLoadingState();
}

class _MyRidesScreenLoadingState extends State<MyRidesScreenLoading>
    with SingleTickerProviderStateMixin {
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
            () {
          setState(
                () {},
          );
        },
      );
  }

  @override
  void dispose() {
    shimmerController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 190,
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
      child: ShaderMask(
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
            transform:
            SlidingGradientTransform(slidePercent: shimmerController.value),
          ).createShader(bounds);
        },
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              height: 25,
              width: 180,
              decoration: BoxDecoration(
                color: Colors.grey.shade300,
                borderRadius: BorderRadius.circular(15),
              ),
            ),
            Container(
              height: 20,
              width: 130,
              decoration: BoxDecoration(
                color: Colors.grey.shade300,
                borderRadius: BorderRadius.circular(15),
              ),
            ),
            Container(
              height: 20,
              width: 80,
              decoration: BoxDecoration(
                color: Colors.grey.shade300,
                borderRadius: BorderRadius.circular(15),
              ),
            ),
            Container(
              height: 25,
              margin: EdgeInsets.only(right: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Container(
                    height: 25,
                    width: 50,
                    decoration: BoxDecoration(
                      color: Colors.grey.shade300,
                      borderRadius: BorderRadius.circular(15),
                    ),
                  ),
                  SizedBox(
                    width: 15,
                  ),
                  Container(
                    height: 25,
                    width: 50,
                    decoration: BoxDecoration(
                      color: Colors.grey.shade300,
                      borderRadius: BorderRadius.circular(15),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}