import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';

Future initFirebase() async {
  if (kIsWeb) {
    await Firebase.initializeApp(
        options: FirebaseOptions(
            apiKey: "AIzaSyCUpna_mufsa5RorY-LHPmsZ0BnWSOi4jE",
            authDomain: "m-a-e-medi-q-gmdamg.firebaseapp.com",
            projectId: "m-a-e-medi-q-gmdamg",
            storageBucket: "m-a-e-medi-q-gmdamg.firebasestorage.app",
            messagingSenderId: "777711238454",
            appId: "1:777711238454:web:942aaad2b98fef32ee8797"));
  } else {
    await Firebase.initializeApp();
  }
}
