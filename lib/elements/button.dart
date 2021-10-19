import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class Button extends StatelessWidget {
  const Button({
    required this.buttonText,
    required this.onPress,
    this.loading = false,
  });

  final String buttonText;
  final VoidCallback onPress;
  final bool loading;

  @override
  Widget build(BuildContext context) {
    return Material(
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
            onTap: onPress,
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
                    : Text(
                  buttonText,
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
    );
  }
}
