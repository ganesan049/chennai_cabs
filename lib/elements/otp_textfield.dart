import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';

class OTPTextField {
  static final List<TextEditingController> otpControllers =
      List.generate(6, (index) => TextEditingController());

  static void clear() {
    otpControllers.forEach(
      (element) => element.clear(),
    );
  }

  static List<Widget> generate(int otpLength) {
    final List<FocusNode> textFieldNodes =
        List.generate(otpLength, (index) => FocusNode());
    final List<FocusNode> keyBoardNodes =
        List.generate(otpLength, (index) => FocusNode());
    List<Widget> textFields = [];

    for (int i = 0; i < otpLength; i++) {
      textFields.add(
        Expanded(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: RawKeyboardListener(
              focusNode: keyBoardNodes[i],
              onKey: (event) {
                if (i > 0) {
                  if (event is RawKeyDownEvent) {
                    if (event.logicalKey == LogicalKeyboardKey.backspace) {
                      if (otpControllers[i].text.isEmpty) {
                        textFieldNodes[i - 1].requestFocus();
                      }
                    }
                  }
                }
              },
              child: TextFormField(
                controller: otpControllers[i],
                focusNode: textFieldNodes[i],
                validator: (input) {
                  if (input!.isEmpty) {
                    return '';
                  }
                },
                onChanged: (input) {
                  if (i < 5) {
                    if (input.length == 1) {
                      textFieldNodes[i + 1].requestFocus();
                    }
                  }
                  if (i == 5) {
                    textFieldNodes[i].unfocus();
                  }
                },
                showCursor: false,
                textAlign: TextAlign.center,
                keyboardType: TextInputType.phone,
                style: GoogleFonts.ptSans(fontWeight: FontWeight.bold),
                inputFormatters: [
                  LengthLimitingTextInputFormatter(1),
                  FilteringTextInputFormatter.digitsOnly,
                ],
                decoration: InputDecoration(
                  errorStyle: TextStyle(height: 0),
                  border: OutlineInputBorder(),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.black, width: 1.5),
                  ),
                ),
              ),
            ),
          ),
        ),
      );
    }
    return textFields;
  }
}
