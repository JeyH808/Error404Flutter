import 'package:firebase_core/firebase_core.dart';

const firebaseOptions = FirebaseOptions(
  apiKey: "AIzaSyDhnqBxnCz2ZZuY0L4bcPsI0hV0OD7nffc",
  authDomain: "error404-project-de166.firebaseapp.com",
  projectId: "error404-project-de166",
  storageBucket: "error404-project-de166.appspot.com",
  messagingSenderId: "403286526941",
  appId: "1:403286526941:web:2b681a0b2555e65c8dc434",
);

Future<FirebaseApp> initializeFirebase() async {
  return await Firebase.initializeApp(options: firebaseOptions);
}
