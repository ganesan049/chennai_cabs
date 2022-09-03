import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class BottomNavigatorElement extends StatelessWidget {
  const BottomNavigatorElement({
    required this.iconPath,
    this.height = 20,
    this.width = 20,
    required this.iconLabel,
    this.selected = false,
  });

  final String iconPath;
  final double height;
  final bool selected;
  final String iconLabel;
  final double width;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 47,
      width: 50,
      decoration: BoxDecoration(
        color: selected ? Colors.white : Colors.transparent,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Material(
        type: MaterialType.transparency,
        child: InkWell(
          onTap: () {},
          borderRadius:  BorderRadius.circular(10),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Image.asset(
                iconPath,
                height: height,
                width: width,
                color: selected ? Colors.black : Colors.white,
              ),
              Text(
                iconLabel,
                textAlign: TextAlign.center,
                style: GoogleFonts.ptSans(
                  fontSize: 9,
                  fontWeight: FontWeight.bold,
                  color: selected ? Colors.black : Colors.white,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
