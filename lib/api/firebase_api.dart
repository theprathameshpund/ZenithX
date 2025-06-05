import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:cloud_firestore/cloud_firestore.dart'; // For storing FCM tokens
import 'package:firebase_auth/firebase_auth.dart'; // For getting the current user
import 'dart:developer'; // For controlled logging

/// Background message handler function.
/// This must be a top-level function, as required by Firebase.
Future<void> handleBackgroundMessage(RemoteMessage message) async {
  log('Background Message Received:', name: 'FirebaseMessaging');
  log('Title: ${message.notification?.title ?? "No title"}', name: 'FirebaseMessaging');
  log('Body: ${message.notification?.body ?? "No body"}', name: 'FirebaseMessaging');
  log('Payload: ${message.data}', name: 'FirebaseMessaging');
}

class FirebaseApi {
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;

  // Local notifications plugin instance
  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
  FlutterLocalNotificationsPlugin();

  /// Initializes Firebase Messaging and handles permissions.
  Future<void> initNotifications() async {
    try {
      // Request notification permissions
      NotificationSettings settings = await _firebaseMessaging.requestPermission(
        alert: true,
        badge: true,
        sound: true,
      );

      if (settings.authorizationStatus == AuthorizationStatus.authorized) {
        log('User granted notification permission.', name: 'FirebaseMessaging');
      } else if (settings.authorizationStatus == AuthorizationStatus.provisional) {
        log('User granted provisional notification permission.', name: 'FirebaseMessaging');
      } else {
        log('User denied notification permission.', name: 'FirebaseMessaging');
        return; // Exit initialization if permission is denied
      }

      // Fetch the FCM token and log it
      final fcmToken = await _firebaseMessaging.getToken();
      log('FCM Token: $fcmToken', name: 'FirebaseMessaging');

      // Store the token in Firestore for the current user
      await _storeFcmToken(fcmToken);

      // Set up the background message handler
      FirebaseMessaging.onBackgroundMessage(handleBackgroundMessage);

      // Create a notification channel
      await _createNotificationChannel();

      // Initialize local notifications
      const AndroidInitializationSettings androidSettings =
      AndroidInitializationSettings('@mipmap/ic_launcher');
      const InitializationSettings initSettings =
      InitializationSettings(android: androidSettings);

      await flutterLocalNotificationsPlugin.initialize(initSettings);

      // Handle foreground messages
      FirebaseMessaging.onMessage.listen((RemoteMessage message) {
        log('Foreground Message Received:', name: 'FirebaseMessaging');
        log('Title: ${message.notification?.title ?? "No title"}', name: 'FirebaseMessaging');
        log('Body: ${message.notification?.body ?? "No body"}', name: 'FirebaseMessaging');
        log('Payload: ${message.data}', name: 'FirebaseMessaging');

        if (message.notification != null) {
          _showLocalNotification(
            message.notification!.title ?? 'Notification',
            message.notification!.body ?? '',
          );
        }
      });

      // Handle notification taps
      FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
        log('Notification Clicked:', name: 'FirebaseMessaging');
        log('Title: ${message.notification?.title ?? "No title"}', name: 'FirebaseMessaging');
        log('Body: ${message.notification?.body ?? "No body"}', name: 'FirebaseMessaging');
        log('Payload: ${message.data}', name: 'FirebaseMessaging');
      });
    } catch (e) {
      log('Error initializing Firebase Notifications: $e', name: 'FirebaseMessaging');
    }
  }

  /// Displays a local notification for foreground messages
  Future<void> _showLocalNotification(String title, String body) async {
    try {
      const AndroidNotificationDetails androidDetails = AndroidNotificationDetails(
        'default_channel', // Channel ID
        'Default',         // Channel name
        channelDescription: 'Default notifications',
        importance: Importance.max,
        priority: Priority.high,
        icon: '@drawable/ic_notification', // Custom notification icon
      );

      const NotificationDetails platformDetails =
      NotificationDetails(android: androidDetails);

      await flutterLocalNotificationsPlugin.show(
        0, // Notification ID
        title,
        body,
        platformDetails,
      );
    } catch (e) {
      log('Error showing local notification: $e', name: 'FirebaseMessaging');
    }
  }

  /// Creates a notification channel for Android devices.
  Future<void> _createNotificationChannel() async {
    try {
      const AndroidNotificationChannel channel = AndroidNotificationChannel(
        'default_channel', // ID
        'Default', // Name
        description: 'Default notification channel for the app',
        importance: Importance.max,
      );

      final AndroidFlutterLocalNotificationsPlugin? androidImplementation =
      flutterLocalNotificationsPlugin.resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin>();

      if (androidImplementation != null) {
        await androidImplementation.createNotificationChannel(channel);
      }
    } catch (e) {
      log('Error creating notification channel: $e', name: 'FirebaseMessaging');
    }
  }

  /// Stores the FCM token in Firestore for the current user
  Future<void> _storeFcmToken(String? fcmToken) async {
    if (fcmToken != null) {
      try {
        final User? user = FirebaseAuth.instance.currentUser;
        if (user != null) {
          await FirebaseFirestore.instance
              .collection('users')
              .doc(user.uid)
              .set({'fcmToken': fcmToken}, SetOptions(merge: true));
          log('FCM Token stored successfully for user ${user.uid}.', name: 'FirebaseMessaging');
        } else {
          log('No user is logged in. FCM Token not stored.', name: 'FirebaseMessaging');
        }
      } catch (e) {
        log('Failed to store FCM Token: $e', name: 'FirebaseMessaging');
      }
    } else {
      log('FCM Token is null. Skipping token storage.', name: 'FirebaseMessaging');
    }
  }
}
