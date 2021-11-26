import 'package:firebase_messaging/firebase_messaging.dart';

class PushNotification {
  static final FirebaseMessaging firebaseMessaging = FirebaseMessaging.instance;

  static Future<String> getNotificationToken() async {
    String token = '';
    await firebaseMessaging.getToken().then((value) => token = value!);
    return token;
  }

  static Future<String> getNotificationDetails() async {
    String message = '';
    await firebaseMessaging.getInitialMessage().then(
      (value) {
        message = value == null ? '' : value.data['booking_id'];
      },
    );
    return message;
  }

}
