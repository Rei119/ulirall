import 'package:firebase_messaging/firebase_messaging.dart';

class NotificationService {
  final FirebaseMessaging _messaging = FirebaseMessaging.instance;

  Future<void> initialize() async {
    // Request permission
    await _messaging.requestPermission(alert: true, badge: true, sound: true);

    // Get token
    String? token = await _messaging.getToken();
    print('FCM Token: $token');

    //foreground messages
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      print('Мэдэгдэл ирлээ: ${message.notification?.title}');
    });

    //background messages
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      print('Мэдэгдэл дээр дарлаа: ${message.notification?.title}');
    });
  }
}
