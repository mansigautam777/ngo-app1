import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:samarthya/screens/splashscreen.dart';
import 'package:firebase_core/firebase_core.dart';



Future<void> _messageHandler(RemoteMessage message) async {
  print('background message ${message.notification!.body}');
} 

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  late FirebaseMessaging messaging;
  messaging = FirebaseMessaging.instance;
  messaging.subscribeToTopic("messaging");
      FirebaseMessaging.onMessage.listen((RemoteMessage event) {
        print("message recieved");
        print(event.notification!.body);
    });
    FirebaseMessaging.onMessageOpenedApp.listen((message) {
      print('Message clicked!');
    });
    FirebaseMessaging.onBackgroundMessage(_messageHandler);
  runApp(MaterialApp(
      color: Colors.amberAccent.shade400,
      debugShowCheckedModeBanner: false,
      home: Splash(),
    ));

}