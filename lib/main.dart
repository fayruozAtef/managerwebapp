import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:managerweb/widgets/Login.dart';


void main()  async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
      options: const FirebaseOptions(
          apiKey: "AIzaSyBgi5-xQd9BtXG0Za3LjyVlyFf1Pgu15Us",
          appId: "1:736288426370:web:d4f5bc6377d460cb7b679b",
          messagingSenderId:  "736288426370",
          projectId: "testfirebaseflutter-aa934"));
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false ,
      home:Loginmanager (),
    );
  }
}

