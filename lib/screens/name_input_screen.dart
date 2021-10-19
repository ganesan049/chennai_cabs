import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:testing_referral/elements/auth_screen_template.dart';
import 'package:testing_referral/elements/button.dart';
import 'package:testing_referral/elements/keys.dart';
import 'package:testing_referral/network/auth.dart';
import 'package:testing_referral/operations/operations.dart';

class NameInputScreen extends StatefulWidget {
  static final String nameInputScreen = 'NameInputScreen';

  @override
  State<NameInputScreen> createState() => _NameInputScreenState();
}

class _NameInputScreenState extends State<NameInputScreen> {
  final TextEditingController controller = TextEditingController();
  bool loading = false;

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () => Operations.exit(context),
      child: AuthScreenTemplate(
        screenTitle: 'Let\'s get started',
        gifURL: 'https://media.giphy.com/media/h3WIBP37C8AsqMrvCn/giphy.gif',
        elements: [
          Form(
            key: Keys.nameValidatorKey,
            child: TextFormField(
              controller: controller,
              validator: (input) {
                if (input!.isEmpty) {
                  return 'enter a name';
                }
              },
              style: GoogleFonts.ptSans(fontWeight: FontWeight.bold),
              keyboardType: TextInputType.name,
              cursorColor: Colors.black38,
              decoration: InputDecoration(
                prefixIcon: Icon(
                  Icons.person,
                  color: Colors.grey,
                ),
                hintText: 'Enter your name',
                prefixStyle: GoogleFonts.ptSans(
                    fontWeight: FontWeight.bold, fontSize: 15),
                hintStyle: GoogleFonts.ptSans(),
                focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.black, width: 1),
                ),
              ),
            ),
          ),
          Button(
            loading: loading,
            buttonText: 'DONE',
            onPress: loading? () => null : () {
              if (Keys.nameValidatorKey.currentState!.validate()) {
                setState(() => loading = true);
                Auth.setName(
                  controller.text.trim(),
                  context,
                  (status) => setState(() => loading = status),
                );
              }
            },
          ),
        ],
      ),
    );
  }
}
