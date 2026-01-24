import 'dart:developer';
import 'dart:io';

import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_timezone/flutter_timezone.dart';
import 'package:go_router/go_router.dart';
import 'package:monee/core/routes/routes.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

class NotificationService {
  factory NotificationService() => _instance;

  NotificationService._internal();
  static final NotificationService _instance = NotificationService._internal();

  final FlutterLocalNotificationsPlugin _flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  Future<void> init() async {
    // Request notification permissions first
    await _requestNotificationPermission();

    // Initialize timezone data - this automatically sets up the local timezone
    tz.initializeTimeZones();
    final currentTimeZone = await FlutterTimezone.getLocalTimezone();
    tz.setLocalLocation(tz.getLocation(currentTimeZone.identifier));

    const androidInitializationSettings = AndroidInitializationSettings(
      'app_icon',
    );

    const iosInitializationSettings = DarwinInitializationSettings();

    const initializationSettings = InitializationSettings(
      android: androidInitializationSettings,
      iOS: iosInitializationSettings,
    );

    await _flutterLocalNotificationsPlugin.initialize(
      initializationSettings,
      onDidReceiveNotificationResponse: _onDidReceiveNotificationResponse,
    );

    // Android channel configuration
    const channel = AndroidNotificationChannel(
      'high_importance_channel',
      'High Importance Notifications',
      description: 'This channel is used for important notifications.',
      importance: Importance.max,
    );

    await _flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin
        >()
        ?.createNotificationChannel(channel);
  }

  /// Request notification permissions using permission_handler
  Future<void> _requestNotificationPermission() async {
    if (Platform.isAndroid) {
      // Request POST_NOTIFICATIONS permission on Android 13+
      final status = await Permission.notification.request();
      log(
        'Android notification permission: ${status.isDenied
            ? 'Denied'
            : status.isGranted
            ? 'Granted'
            : status.isPermanentlyDenied
            ? 'Permanently Denied'
            : 'Unknown'}',
      );
    } else if (Platform.isIOS) {
      // Request notification permissions on iOS
      final status = await Permission.notification.request();
      log(
        'iOS notification permission: ${status.isDenied
            ? 'Denied'
            : status.isGranted
            ? 'Granted'
            : status.isPermanentlyDenied
            ? 'Permanently Denied'
            : 'Unknown'}',
      );

      // Also request iOS specific permissions if granted
      if (status.isGranted) {
        await _flutterLocalNotificationsPlugin
            .resolvePlatformSpecificImplementation<
              IOSFlutterLocalNotificationsPlugin
            >()
            ?.requestPermissions(
              alert: true,
              badge: true,
              sound: true,
            );
      }
    }
  }

  Future<void> _onDidReceiveNotificationResponse(
    NotificationResponse response,
  ) async {
    // Handle notification press here
    log('Notification pressed: ${response.payload}');

    // Navigate to tracking detail if payload exists
    if (response.payload != null && response.payload!.isNotEmpty) {
      try {
        // final tracking = TrackingModel.fromJson(response.payload!);
        final context = AppRouter.rootNavigatorKey.currentContext;

        if (context != null) {
          await GoRouter.of(context).pushNamed(
            Pages.trackingDetail.name,
            queryParameters: {'tracking': response.payload},
          );
        } else {
          log('Context not available for navigation');
        }
      } on Exception catch (e) {
        log('Error parsing tracking payload: $e');
      }
    }
  }

  Future<bool> showNotification({
    required int id,
    required String title,
    required String body,
    String? payload,
  }) async {
    try {
      const notificationDetails = NotificationDetails(
        android: AndroidNotificationDetails(
          'high_importance_channel',
          'High Importance Notifications',
          channelDescription:
              'This channel is used for important notifications.',
          importance: Importance.max,
          priority: Priority.high,
        ),
        iOS: DarwinNotificationDetails(
          presentAlert: true,
          presentBadge: true,
          presentSound: true,
        ),
      );

      await _flutterLocalNotificationsPlugin.show(
        id,
        title,
        body,
        notificationDetails,
        payload: payload,
      );
      log('Notification shown successfully with id: $id');
      return true;
    } on Exception catch (e) {
      log('Error showing notification: $e');
      return false;
    }
  }

  Future<void> scheduleNotification({
    required int id,
    required String title,
    required String body,
    required DateTime scheduledDate,
    String? payload,
  }) async {
    try {
      const notificationDetails = NotificationDetails(
        android: AndroidNotificationDetails(
          'high_importance_channel',
          'High Importance Notifications',
          channelDescription:
              'This channel is used for important notifications.',
          importance: Importance.max,
          priority: Priority.high,
        ),
        iOS: DarwinNotificationDetails(
          presentAlert: true,
          presentBadge: true,
          presentSound: true,
        ),
      );

      await _flutterLocalNotificationsPlugin.zonedSchedule(
        id,
        title,
        body,
        tz.TZDateTime.from(scheduledDate, tz.local),
        notificationDetails,
        androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
        matchDateTimeComponents: DateTimeComponents.time,
        payload: payload,
      );
      log('Notification scheduled successfully with id: $id');
    } on Exception catch (e) {
      log('Error scheduling notification: $e');
    }
  }
}
