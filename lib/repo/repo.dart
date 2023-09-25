import 'package:firebase_push_notification/network_request.dart';

class PushNotification{
 static Future sendPushNotification(String title,String body)async{
   try{
     var result = await NetworkRequest.post("https://fcm.googleapis.com/fcm/send",
         title, body);
     print(result);
   }
   catch(e){
     print(e.toString());
   }
  }
}