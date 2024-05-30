// import 'dart:convert';
//
// import 'package:firebase_messaging/firebase_messaging.dart';
// import 'package:flutter_local_notifications/flutter_local_notifications.dart';
//
// class FirebaseAPI {
//   final _firebaseMessaging = FirebaseMessaging.instance;
//   final _androidChannel = AndroidNotificationChannel(
//     'high_importance_channel',
//     'High Importance Notifications',
//     description: 'This channel is used for important notifications',
//     importance: Importance.defaultImportance,
//   );
//
//   final _localNotification = FlutterLocalNotificationsPlugin();
//
//   Future<void> handleBackgroundMessage(RemoteMessage message) async {
//     print('Title: ${message.notification?.title}');
//     print('Body: ${message.notification?.body}');
//     print('Payload: ${message.data}');
//   }
//
//   void handleMessage(RemoteMessage? message) {
//     if (message == null) return;
//
//     // Handle the message as needed
//   }
//
//   Future<void> initLocalNotifications() async {
//     const android = AndroidInitializationSettings(
//         'app_logo'); // Replace with the correct image name
//     const setting = InitializationSettings(android: android);
//
//     final platform = _localNotification.resolvePlatformSpecificImplementation<
//         AndroidFlutterLocalNotificationsPlugin>();
//     await platform?.createNotificationChannel(_androidChannel);
//
//     await _localNotification.initialize(
//       setting,
//     );
//   }
//
//   Future<void> initPushNotifications() async {
//     await FirebaseMessaging.instance
//         .setForegroundNotificationPresentationOptions(
//       alert: true,
//       badge: true,
//       sound: true,
//     );
//
//     FirebaseMessaging.instance.getInitialMessage().then(handleMessage);
//     FirebaseMessaging.onMessageOpenedApp.listen(handleMessage);
//     FirebaseMessaging.onBackgroundMessage(handleBackgroundMessage);
//     FirebaseMessaging.onMessage.listen((message) {
//       final notification = message.notification;
//       if (notification == null) return;
//       _localNotification.show(
//         notification.hashCode,
//         notification.title ?? '',
//         notification.body ?? '',
//         NotificationDetails(
//           android: AndroidNotificationDetails(
//             _androidChannel.id,
//             _androidChannel.name,
//             channelDescription: _androidChannel.description,
//             importance: _androidChannel.importance,
//           ),
//         ),
//         payload: jsonEncode(message.toMap()),
//       );
//     });
//   }
//
//   Future<void> initNotification() async {
//     await _firebaseMessaging.requestPermission();
//     final fCMToken = await _firebaseMessaging.getToken();
//     print('Token: $fCMToken');
//
//     FirebaseMessaging.onBackgroundMessage(handleBackgroundMessage);
//     initPushNotifications();
//     initLocalNotifications();
//   }
// }
