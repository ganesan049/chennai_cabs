import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'button.dart';

class DialogBox{

  static Future<dynamic> show(BuildContext context, String errorMessage){

    return showDialog(
      context: context,
      builder: (buildContext) => AlertDialog(
        title: Text(
          'Error',
          textAlign: TextAlign.center,
        ),
        titleTextStyle: GoogleFonts.ubuntu(
            fontWeight: FontWeight.bold, color: Colors.black, fontSize: 20),
        content: Text(
          errorMessage,
          textAlign: TextAlign.center,
        ),
        contentTextStyle: GoogleFonts.ubuntu(color: Colors.black),
        actionsPadding: EdgeInsets.only(left: 20, right: 20, bottom: 10),
        actions: [
          Button(
            buttonText: 'OK',
            onPress: () => Navigator.pop(buildContext),
          ),
        ],
      ),
    );

  }

}