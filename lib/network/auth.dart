import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:chennai_cabs_dev/elements/dialog_box.dart';
import 'package:chennai_cabs_dev/elements/otp_textfield.dart';
import 'package:chennai_cabs_dev/network/database.dart';
import 'package:chennai_cabs_dev/screens/auth_verify_screen.dart';
import 'package:chennai_cabs_dev/screens/name_input_screen.dart';
import 'package:chennai_cabs_dev/screens/navigator_screen.dart';

class Auth {
  static final FirebaseAuth firebaseAuth = FirebaseAuth.instance;
  static String id = '';

  static void signIn(
      {required String phoneNumber,
      required BuildContext buildContext,
      required ValueSetter<bool> onError,
      int? resendingToken,
      required String referralCode}) async {
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
        OTPTextField.clear();
        firebaseAuth.currentUser!.displayName == null
            ? Navigator.pushAndRemoveUntil(
                buildContext,
                MaterialPageRoute(
                  builder: (context) => NameInputScreen(
                    referralCode: referralCode,
                  ),
                ),
                (route) => false)
            : Navigator.pushNamedAndRemoveUntil(buildContext,
                NavigatorScreen.navigatorScreen, (route) => false);
      },
      verificationFailed: (FirebaseAuthException e) {
        DialogBox.show(buildContext, e.message!);
        onError(false);
      },
      codeSent: (String verificationId, int? resendToken) {
        id = verificationId;
        if (resendingToken == null) {
          onError(false);
          Navigator.push(
            buildContext,
            MaterialPageRoute(
              builder: (context) => AuthVerifyScreen(
                phoneNumber: phoneNumber,
                resendToken: resendToken!,
                referralCode: referralCode,
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

  static void signInWithOTP(
      String otp, BuildContext context, ValueSetter<bool> onError, String referralCode) async {
    final PhoneAuthCredential credential =
        PhoneAuthProvider.credential(verificationId: id, smsCode: otp);
    try {
      await firebaseAuth.signInWithCredential(credential);
      OTPTextField.clear();
      firebaseAuth.currentUser!.displayName == null
          ? Navigator.pushAndRemoveUntil(
           context,
          MaterialPageRoute(
            builder: (context) => NameInputScreen(
              referralCode: referralCode,
            ),
          ),
              (route) => false)
          : Navigator.pushNamedAndRemoveUntil(
              context, NavigatorScreen.navigatorScreen, (route) => false);
    } on FirebaseAuthException catch (error) {
      onError(false);
      DialogBox.show(context, error.message!);
    }
  }

  static void setName(
      String name, BuildContext context, ValueSetter<bool> onError, String referralCode) async {
    try {
      print(referralCode);
      await firebaseAuth.currentUser!.updateDisplayName(name);
      await Database.createUser(firebaseAuth.currentUser?.uid ?? '',
          firebaseAuth.currentUser?.displayName ?? '', referralCode);
      Navigator.pushReplacementNamed(context, NavigatorScreen.navigatorScreen);
    } on FirebaseAuthException catch (error) {
      onError(false);
      DialogBox.show(context, error.message!);
    }
  }

  static String? getName() {
    return firebaseAuth.currentUser!.displayName;
  }

  static bool userSignedIn() {
    final bool user = firebaseAuth.currentUser == null ? false : true;
    return user;
  }

  static void signOut(BuildContext context) async {
    await firebaseAuth.signOut();
    Navigator.pushNamedAndRemoveUntil(context, '/', (route) => false);
  }

  static String getUserId() => firebaseAuth.currentUser!.uid;

  static String? getUserName() => firebaseAuth.currentUser!.displayName;

  static String? getPhoneNumber() => firebaseAuth.currentUser!.phoneNumber;
}
