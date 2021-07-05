import 'dart:async';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

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
  }

  static closeStreams() {
    _messageStream.close();
  }
}
