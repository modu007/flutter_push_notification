import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:firebase_push_notification/repo/repo.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'main.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  TextEditingController title =TextEditingController();
  TextEditingController body =TextEditingController();
  TextEditingController username=TextEditingController();

  void showNotification(RemoteMessage message)async{
    AndroidNotificationDetails androidDetails = const AndroidNotificationDetails(
        "notifications-youtube",
        "YouTube Notifications",
        priority: Priority.max,
        importance: Importance.max
    );
    DarwinNotificationDetails iosDetails = const DarwinNotificationDetails(
      presentAlert: true,
      presentBadge: true,
      presentSound: true,
    );
    NotificationDetails notiDetails = NotificationDetails(
        android: androidDetails,
        iOS: iosDetails
    );
    await notificationsPlugin.show(
      0,
      message.notification?.title,
      message.notification?.body,
      notiDetails,
    payload: message.data["title"]);
    print("yes");
  }
  void incomingMessage()async{
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      print("on message ${message.data}data\n ${message.notification?.title}"
          " title\n ${message.notification?.body} body \n");
      showNotification(message);
    });
  }
  @override
  void initState() {
    super.initState();
    incomingMessage();
  }
  @override
  Widget build(BuildContext context) {
    return SafeArea
      (
        child: Scaffold(
          body: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
               Container(
                 margin: const EdgeInsets.symmetric(horizontal: 20,vertical: 20),
                 alignment: Alignment.center,
                 child: Column(
                   children: [
                     TextField(
                       controller: username,
                       decoration: const InputDecoration(
                         hintText: "username",
                       ),
                     ),
                     TextField(
                       controller: title,
                       decoration: const InputDecoration(
                         hintText: "title",
                       ),
                     ),
                     TextField(
                       controller: body,
                       decoration: const InputDecoration(
                         hintText: "body",
                       ),
                     ),
                   ],
                 ),
               ),
                TextButton(onPressed: (){
                  PushNotification.sendPushNotification(title.text, body.text);
                }, child: const Text("Submit",style: TextStyle(fontSize: 20),))
              ],
            ),
          ),
        )
    );
  }
}
