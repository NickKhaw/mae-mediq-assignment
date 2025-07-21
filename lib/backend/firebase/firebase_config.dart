import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import '/firebase_options.dart';
Future<void> initFirebase() async {
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
}
