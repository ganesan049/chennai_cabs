import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:uuid/uuid.dart';

class Operations {
  static int pressCount = 0;

  static Future<bool> exit(BuildContext context) {
    pressCount++;
    Future.delayed(Duration(seconds: 2), () => pressCount = 0);
    if (pressCount > 1) {
      return Future.value(true);
    } else {
      final SnackBar snackBar = SnackBar(
        elevation: 3,
        behavior: SnackBarBehavior.floating,
        duration: Duration(seconds: 2),
        content: Text(
          'Press again to exit',
          style: GoogleFonts.ptSans(),
        ),
      );
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
      return Future.value(false);
    }
  }

  static String getSessionToken(){
    return Uuid().v4();
  }

}
