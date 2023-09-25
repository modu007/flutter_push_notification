import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:firebase_push_notification/SharedPref/shared_pref.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'my_home_page.dart';
FlutterLocalNotificationsPlugin notificationsPlugin = FlutterLocalNotificationsPlugin();
Future _firebaseMessagingBackgroundHandler(RemoteMessage message)async{
  print("handling a message id ${message.messageId}");
}
Future<void> _handleNotificationResponse(NotificationResponse response) async {
  print("yes");
}
void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await FirebaseMessaging.instance.getInitialMessage();
  FirebaseMessaging messaging =FirebaseMessaging.instance;
  NotificationSettings settings =await messaging.requestPermission(
    alert: true,
    announcement: false,
    badge: true,
    sound: true,
    carPlay: false,
    criticalAlert: false,
    provisional: false,
  );
  if(settings.authorizationStatus ==AuthorizationStatus.authorized){
    print("user granted permission");
  }
  else if(settings.authorizationStatus == AuthorizationStatus.provisional){
    print("user granted provisonal permission");
  }
  else{
    print("user declined or not granted permission");
  }
  AndroidInitializationSettings androidSettings = const AndroidInitializationSettings(
      "@mipmap/ic_launcher");
  DarwinInitializationSettings iosSettings = const DarwinInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestCriticalPermission: true,
      requestSoundPermission: true
  );
  InitializationSettings initializationSettings = InitializationSettings(
      android: androidSettings,
      iOS: iosSettings,
  );
  bool? intialized = await notificationsPlugin.initialize(
      initializationSettings,
  onDidReceiveNotificationResponse: _handleNotificationResponse);
  print("notification $intialized");
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  await FirebaseMessaging.instance.getToken().then((value)async
  {
    print(value);
    await SharedData.setToken(value!);
  });
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(),
    );
  }
}

