import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';

Future initFirebase() async {
  if (kIsWeb) {
    await Firebase.initializeApp(
        options: FirebaseOptions(
            apiKey: "AIzaSyC7GeuKMPTb1jpCxbnkb_G0JLKvuTXVvBE",
            authDomain: "trivia-master-48ll8w.firebaseapp.com",
            projectId: "trivia-master-48ll8w",
            storageBucket: "trivia-master-48ll8w.firebasestorage.app",
            messagingSenderId: "297294877365",
            appId: "1:297294877365:web:e05b51ff20555ed156a4fc"));
  } else {
    await Firebase.initializeApp();
  }
}
