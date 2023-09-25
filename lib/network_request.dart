import 'dart:convert';
import 'package:firebase_push_notification/SharedPref/shared_pref.dart';
import 'package:http/http.dart'as http;
class NetworkRequest{

  static Future post(String api,String title,String body)async{
    Map<String, String> headers = {
      'Content-Type': 'application/json',
      "Authorization":"key=AAAAfkLtRR0:APA91bHnH-Mi4JQKcbwHN-gUVTHjZoiX1F-IP6VLjtiq0B94m2vzbgqjfUIWGfbduxs-apx6Sf6I3ckO1kmxtYL3SEDtwoTDVVfs3_n-ojW-dl252XnpvgihkydXP9URAq_vbYB9JajN"
    };
    try {
      String token =await SharedData.getToken("token");
      http.Request request = http.Request('POST', Uri.parse(api));
      request.body = json.encode({
        "priority":"high",
        "to": token,
        "notification": {
          "title": title,
          "body": body,
          "sound": "Tri-tone",
          "android_channel_id":"notifications-youtube"
        },

        "data": {
          "click_action":"FLUTTER_NOTIFICATION_CLICK",
          "status":"done",
          "title": title,
          "body": body,
        }
      });
      request.headers.addAll(headers);
      http.StreamedResponse response = await request.send();

      final statusCode = response.statusCode;
      final responseBody = await response.stream.bytesToString();

      print('Response status code: $statusCode');
      print('Response body: $responseBody');

      if (statusCode == 200 || statusCode == 201) {
        // Successful response
        return jsonDecode(responseBody);
      } else {
        // Handle error response here, if needed
        print('Error: $statusCode');
        return jsonDecode(responseBody);
      }
    } catch (e) {
      print('Exception: $e');
      // Handle any exceptions here
      throw e; // Optionally rethrow the exception for higher-level error handling.
    }
  }
}