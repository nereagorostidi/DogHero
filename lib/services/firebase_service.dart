import 'dart:convert';
import 'dart:io';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

import '../firebase_options.dart';

@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  print("Handling a background message ${message.messageId}");

  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform, name:'dog');
  await setupFlutterNotifications();
  showFlutterNotification(message);
}

void onSelectNotification(NotificationResponse notificationResponse) async {
  try {
    print("onSelectNotification::${notificationResponse.payload}");
    FirebaseService.removeBadge();
  } catch (e) {}
}

late AndroidNotificationChannel channel;
bool isFlutterLocalNotificationsInitialized = false;

Future<void> setupFlutterNotifications() async {
  if (isFlutterLocalNotificationsInitialized) {
    return;
  }
  channel = const AndroidNotificationChannel(
    'high_importance_channel',
    'High Importance Notifications',
    description: 'This channel is used for important notifications.',
    importance: Importance.high,
  );

  flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
  const AndroidInitializationSettings initializationSettingsAndroid =
      AndroidInitializationSettings('icon_push_color');
  const DarwinInitializationSettings initializationSettingsIOS =
      DarwinInitializationSettings(
    defaultPresentSound: true,
    requestSoundPermission: true,
  );
  flutterLocalNotificationsPlugin.initialize(
    const InitializationSettings(
        android: initializationSettingsAndroid, iOS: initializationSettingsIOS),
    onDidReceiveNotificationResponse: onSelectNotification,
    onDidReceiveBackgroundNotificationResponse: onSelectNotification,
  );

  await flutterLocalNotificationsPlugin
      .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin>()
      ?.createNotificationChannel(channel);

  await FirebaseMessaging.instance.setForegroundNotificationPresentationOptions(
    alert: true,
    badge: true,
    sound: true,
  );

  isFlutterLocalNotificationsInitialized = true;
}

void showFlutterNotification(RemoteMessage message) {
  RemoteNotification? notification = message.notification;
  AndroidNotification? android = message.notification?.android;
  if (notification != null && android != null && !kIsWeb) {
    flutterLocalNotificationsPlugin.show(
        notification.hashCode,
        notification.title,
        notification.body,
        NotificationDetails(
          android: AndroidNotificationDetails(channel.id, channel.name,
              channelDescription: channel.description,
              playSound: true,
              icon: 'icon_push_color'),
        ),
        payload: json.encode(message.data).toString());
  }
}

/// Initialize the [FlutterLocalNotificationsPlugin] package.
late FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;

late FirebaseMessaging firebaseMessaging;

class FirebaseService {
  final GlobalKey<NavigatorState> navigatorKey;

  FirebaseService(this.navigatorKey);

  Future<void> init() async {
    try {
      WidgetsFlutterBinding.ensureInitialized();
      await Firebase.initializeApp(
          options: DefaultFirebaseOptions.currentPlatform, name:'dog');

      firebaseMessaging = FirebaseMessaging.instance;

      RemoteMessage? msg = await firebaseMessaging.getInitialMessage();
      if (msg != null) {
        print("getInitialMessage::Has message::${msg.toString()}");
      }

      NotificationSettings settings = await firebaseMessaging.requestPermission(
        alert: true,
        badge: true,
        provisional: false,
        sound: true,
      );

      final fcmToken = await firebaseMessaging.getToken();
      firebaseMessaging.onTokenRefresh.listen((fcmToken) {}).onError((err) {});

      FirebaseMessaging.onBackgroundMessage(
          _firebaseMessagingBackgroundHandler);

      FirebaseMessaging.onMessage.listen((message) {
        showPushNotificationDialog(message);
      });

      FirebaseMessaging.onMessageOpenedApp.listen(messageOpenedApp);

      if (!kIsWeb) {
        await setupFlutterNotifications();
      }
    } catch (e) {
      print('FirebaseService::Error::$e');
    }
  }

  void showPushNotificationDialog(RemoteMessage message) {
    final BuildContext? context = navigatorKey.currentContext;

    if (context != null) {
      final RemoteNotification? notification = message.notification;
      if (notification != null) {
        showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: Text(notification.title ?? 'Nueva Notificación'),
              content: Text(notification.body ?? 'Tienes un nuevo mensaje.'),
              actions: [
                TextButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: Text('Cerrar'),
                ),
              ],
            );
          },
        );
      }
    }
  }

  static void removeBadge() {
    if (Platform.isIOS) {
      print("removeBadge::Removing badge from iOS");
    }
  }
}

void messageOpenedApp(RemoteMessage message) {
  try {
    print("messageOpenedApp::${jsonEncode(message.data).toString()}");
    FirebaseService.removeBadge();
  } catch (e) {}
}

class PushNotification {
  PushNotification({
    this.title,
    this.body,
  });
  String? title;
  String? body;
}
