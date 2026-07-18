import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;

class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    return const FirebaseOptions(
      apiKey: 'YOUR_API_KEY',
      appId: 'YOUR_APP_ID',
      messagingSenderId: 'YOUR_MESSAGING_SENDER_ID',
      projectId: 'hindi-moral-stories',
      authDomain: 'hindi-moral-stories.firebaseapp.com',
      databaseURL: 'https://hindi-moral-stories.firebaseio.com',
      storageBucket: 'hindi-moral-stories.appspot.com',
    );
  }
}
