import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class PushNotification {
  static final FirebaseMessaging firebaseMessaging = FirebaseMessaging.instance;

  static Future<String> getNotificationToken() async {
    String token = '';
    await firebaseMessaging.getToken().then((value) => token = value!);
    return token;
  }

  static Future<void> foreground() async {
    const AndroidNotificationChannel channel = AndroidNotificationChannel(
      'notification', // id
      'Notification', // title
      importance: Importance.max,
    );
    final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
        FlutterLocalNotificationsPlugin();
    await flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(channel);
    await flutterLocalNotificationsPlugin.initialize(
      InitializationSettings(
        android: AndroidInitializationSettings('mipmap/ic_launcher'),
      ),
    );
    FirebaseMessaging.onMessage.listen(
      (event) {
        print(event.messageId);
        flutterLocalNotificationsPlugin.show(
          event.hashCode,
          event.notification?.title ?? '',
          event.notification?.body ?? '',
          NotificationDetails(
            android: AndroidNotificationDetails(
              channel.id,
              channel.name,
            ),
          ),
        );
      },
    );
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
