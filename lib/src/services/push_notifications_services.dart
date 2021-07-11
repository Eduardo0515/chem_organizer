import 'dart:async';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest.dart' as tz;

FlutterLocalNotificationsPlugin notificationsPlugin =
    new FlutterLocalNotificationsPlugin();
    

class PushNotificationsServices {
  static FirebaseMessaging messaging = FirebaseMessaging.instance;
  static String? token;
  static StreamController<String> _messageStream =
      new StreamController.broadcast();
  static Stream<String> get messagesStream => _messageStream.stream;

  static Future _backgroundHandler(RemoteMessage message) async {
    //print('backgroundHandler ${message.messageId}');
    _messageStream.add(message.data['AlarmName'] ?? 'Sin titulo');
  }

  static Future _onMessageHandler(RemoteMessage message) async {
    //print('onMessageHandler ${message.messageId}');
    _messageStream.add(message.data['AlarmName'] ?? 'Sin titulo');
  }

  static Future _onMessageOpenAppHandler(RemoteMessage message) async {
    //print('onMessageOpenAppHandler ${message.messageId}');
    _messageStream.add(message.data['AlarmName'] ?? 'Sin titulo');
  }

  static Future initializeApp() async {
    //push notifications service
    await Firebase.initializeApp();
    token = await FirebaseMessaging.instance.getToken();
    print('TOKEEEEN: $token');

    //Handlers
    FirebaseMessaging.onBackgroundMessage(_backgroundHandler);
    FirebaseMessaging.onMessage.listen(_onMessageHandler);
    FirebaseMessaging.onMessageOpenedApp.listen(_onMessageOpenAppHandler);

    //local notifications
    var initializeAndroid = AndroidInitializationSettings('cheems');
    var initializationSettings =
        InitializationSettings(android: initializeAndroid);
    notificationsPlugin.initialize(initializationSettings);
    tz.initializeTimeZones();
  }

  Future<void> displayNotification(
    int id,
    String title,
    String body,
  ) async {
    notificationsPlugin.zonedSchedule(
        id,
        title,
        body,
        tz.TZDateTime.now(tz.local).add(
          Duration(seconds: 3),
        ),
        NotificationDetails(
            android: AndroidNotificationDetails(
                'channelId', 'channelName', 'channelDescription')),
        uiLocalNotificationDateInterpretation:
            UILocalNotificationDateInterpretation.absoluteTime,
        androidAllowWhileIdle: true);
  }

  static closeStreams() {
    _messageStream.close();
  }

  cancelNotificaion(int id) async{
    await notificationsPlugin.cancel(id);
  }
}
