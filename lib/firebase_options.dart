import 'package:firebase_core/firebase_core.dart';

class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    return android;
  }

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyAp8an2YEkTYxbGx2WtGiANHPzOEXwU8qk',
    appId: '1:842378302796:android:f1b5050daac8b4ae666be9',
    messagingSenderId: '842378302796',
    projectId: 'ecommerce-54e40',
    storageBucket: 'ecommerce-54e40.appspot.com',
  );
}
