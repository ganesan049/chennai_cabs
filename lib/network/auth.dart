import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:testing_referral/elements/dialog_box.dart';
import 'package:testing_referral/elements/otp_textfield.dart';
import 'package:testing_referral/screens/auth_verify_screen.dart';
import 'package:testing_referral/screens/name_input_screen.dart';
import 'package:testing_referral/screens/navigator_screen.dart';

class Auth {
  static final FirebaseAuth firebaseAuth = FirebaseAuth.instance;
  static String id = '';

  static void signIn(
      {required String phoneNumber,
      required BuildContext buildContext,
      required ValueSetter<bool> onError, int? resendingToken}) async {
    await firebaseAuth.verifyPhoneNumber(
      phoneNumber: '+91 ' + phoneNumber,
      forceResendingToken: resendingToken,
      verificationCompleted: (PhoneAuthCredential credential) async {
        List<String> otp = credential.smsCode!.split('');
        for (int i = 0; i < 6; i++) {
          OTPTextField.otpControllers.elementAt(i).value = TextEditingValue(
            text: otp.elementAt(i),
          );
        }
        await firebaseAuth.signInWithCredential(credential);
        firebaseAuth.currentUser!.displayName == null
            ? Navigator.pushNamedAndRemoveUntil(
            buildContext, NameInputScreen.nameInputScreen, (route) => false)
            : Navigator.pushNamedAndRemoveUntil(
            buildContext, NavigatorScreen.navigatorScreen, (route) => false);
      },
      verificationFailed: (FirebaseAuthException e) {
        DialogBox.show(buildContext, e.message!);
        onError(false);
      },
      codeSent: (String verificationId, int? resendToken) {
        id = verificationId;
        if (resendingToken == null){
          onError(false);
          Navigator.push(
            buildContext,
            MaterialPageRoute(
              builder: (context) => AuthVerifyScreen(
                phoneNumber: phoneNumber,
              ),
            ),
          );
        }
      },
      codeAutoRetrievalTimeout: (String verificationId) {
        print('3');
      },
    );
  }

  static void signInWithOTP(String otp, BuildContext context, ValueSetter<bool> onError) async {
    final PhoneAuthCredential credential = PhoneAuthProvider.credential(verificationId: id, smsCode: otp);
    try{
      await firebaseAuth.signInWithCredential(credential);
      firebaseAuth.currentUser!.displayName == null
          ? Navigator.pushReplacementNamed(
          context, NameInputScreen.nameInputScreen)
          : Navigator.pushReplacementNamed(
          context, NavigatorScreen.navigatorScreen);
    }
    on FirebaseAuthException catch(error){
      onError(false);
      DialogBox.show(context, error.message!);
    }
  }

  static void setName(String name, BuildContext context, ValueSetter<bool> onError) async {
    try{
      await firebaseAuth.currentUser!.updateDisplayName(name);
      Navigator.pushReplacementNamed(
          context, NavigatorScreen.navigatorScreen);
    }
    on FirebaseAuthException catch(error){
      onError(false);
      DialogBox.show(context, error.message!);
    }
  }

  static String? getName(){
    return firebaseAuth.currentUser!.displayName;
  }

  static void signOut(BuildContext context) async {
    await firebaseAuth.signOut();
    Navigator.pushNamedAndRemoveUntil(context, '/', (route) => false);
  }
}
