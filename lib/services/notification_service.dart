import 'dart:io';

import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/data/latest.dart' as TzData;
import 'package:timezone/timezone.dart' as tz;
class NotificationService {
  static final NotificationService _instance = NotificationService._internal();
  factory NotificationService() => _instance;
  NotificationService._internal();

  final FlutterLocalNotificationsPlugin _notifications = FlutterLocalNotificationsPlugin();
  Future<void> init() async {
    TzData.initializeTimeZones();
    const android = AndroidInitializationSettings("@mipmap/ic_launcher");
    const iOS = DarwinInitializationSettings();

    const settings = InitializationSettings(android: android, iOS: iOS);
    await _notifications.initialize(settings);
    //Request Local Notification Permission
    if(Platform.isAndroid) {
      _notifications.resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>()?.requestNotificationsPermission();
    } else {
      _notifications.resolvePlatformSpecificImplementation<IOSFlutterLocalNotificationsPlugin>()?.requestPermissions(alert: true, badge: true, sound: true);
    }
  }

  //Schedule Renewal Notifications for Subscriptions
  Future<void> scheduleRenewalNotification({
    required int id,
    required String name,
    required DateTime date,
    required double amount,
  }) async {
    final tzDate = tz.TZDateTime.from(date, tz.local);
    await  _notifications.zonedSchedule(id, "Upcoming Renewal Reminder", '$name renews on ${date.toString().split(" ").first} (₹$amount)', tzDate.subtract(const Duration(hours: 2)), const NotificationDetails(
      android: AndroidNotificationDetails("renewal_channel", "Renewal Notifications",
      channelDescription: "Subscription Renewal Reminders",
      importance: Importance.high,
      priority: Priority.high
      ),
      iOS: DarwinNotificationDetails(
        presentAlert: true,
        presentBadge: true,
        presentBanner: true,
        presentSound: true
      ),
    ), androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle, matchDateTimeComponents: DateTimeComponents.dateAndTime);
  }

  //Cancel specific Notification
  Future<void> cancel(int id) async {
    await _notifications.cancel(id);
  }

  //Cancel All Notifications
  Future<void> cancelAll(int id) async {
    await _notifications.cancelAll();
  }
}