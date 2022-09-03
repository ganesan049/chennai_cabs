import 'package:flutter/material.dart';
import 'package:chennai_cabs_dev/elements/sliding_gradient_transform.dart';

class CarModesLoadingCard extends StatefulWidget {
  @override
  State<CarModesLoadingCard> createState() => _CarModesLoadingCardState();
}

class _CarModesLoadingCardState extends State<CarModesLoadingCard>
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
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 20),
      child: Material(
        elevation: 5,
        color: Colors.grey.shade100,
        borderRadius: BorderRadius.circular(20),
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
              transform: SlidingGradientTransform(
                  slidePercent: shimmerController.value),
            ).createShader(bounds);
          },
          child: SizedBox(
            height: 130,
            child: Column(
              children: [
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 15.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          height: 30,
                          width: 130,
                          decoration: BoxDecoration(
                            color: Colors.grey,
                            borderRadius: BorderRadius.circular(15),
                          ),
                        ),
                        Container(
                          height: 30,
                          width: 50,
                          decoration: BoxDecoration(
                            color: Colors.grey,
                            borderRadius: BorderRadius.circular(15),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(
                  height: 50,
                  child: Row(
                    children: List.generate(
                      4,
                          (index) => Expanded(
                        child: Container(
                          height: 15,
                          width: 50,
                          margin: EdgeInsets.symmetric(horizontal: 20),
                          decoration: BoxDecoration(
                            color: Colors.grey,
                            borderRadius: BorderRadius.circular(15),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
