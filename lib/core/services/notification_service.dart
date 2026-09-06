// import 'package:flutter_local_notifications/flutter_local_notifications.dart';
// import 'package:timezone/data/latest_all.dart' as tz;
// import 'package:timezone/timezone.dart' as tz;

// class NotificationService {
//   static final FlutterLocalNotificationsPlugin _notificationsPlugin =
//       FlutterLocalNotificationsPlugin();

//   static Future<void> initNotification() async {
//     tz.initializeTimeZones();

//     const AndroidInitializationSettings initializationSettingsAndroid =
//         AndroidInitializationSettings('@mipmap/ic_launcher');

//     const DarwinInitializationSettings initializationSettingsIOS =
//         DarwinInitializationSettings(
//       requestAlertPermission: true,
//       requestBadgePermission: true,
//       requestSoundPermission: true,
//     );

//     const InitializationSettings initializationSettings = InitializationSettings(
//       android: initializationSettingsAndroid,
//       iOS: initializationSettingsIOS,
//     );

//     await _notificationsPlugin.initialize(
//       settings: initializationSettings,
//     );

//     final androidImplementation =
//         _notificationsPlugin.resolvePlatformSpecificImplementation<
//             AndroidFlutterLocalNotificationsPlugin>();
//     if (androidImplementation != null) {
//       await androidImplementation.requestNotificationsPermission();
//       await androidImplementation.requestExactAlarmsPermission();
//     }
//   }

//   static Future<void> scheduleEvery6HoursNotification() async {
//     const AndroidNotificationDetails androidDetails = AndroidNotificationDetails(
//       'news_channel_id',
//       'News Updates',
//       channelDescription: 'Notifications for the latest news updates',
//       importance: Importance.high,
//       priority: Priority.high,
//     );

//     const NotificationDetails notificationDetails = NotificationDetails(
//       android: androidDetails,
//       iOS: DarwinNotificationDetails(),
//     );

//     // حساب موعد أول إشعار بعد 6 ساعات
//     final tz.TZDateTime scheduledDate =
//         tz.TZDateTime.now(tz.local).add(const Duration(hours: 6));

//     await _notificationsPlugin.zonedSchedule(
//       id: 0,
//       title:'new news',
//       body: 'check out the latest news!',
//       scheduledDate: scheduledDate,
//       notificationDetails: notificationDetails,
//       androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
//       matchDateTimeComponents: DateTimeComponents.time,
//     );
//   }
// }

import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/data/latest_all.dart' as tz;
import 'package:timezone/timezone.dart' as tz;


class NotificationService {
  static final FlutterLocalNotificationsPlugin _notificationsPlugin =
      FlutterLocalNotificationsPlugin();

  static Future<void> initNotification() async {
    tz.initializeTimeZones();

    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/ic_launcher');

    const DarwinInitializationSettings initializationSettingsIOS =
        DarwinInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: true,
    );

    const InitializationSettings initializationSettings = InitializationSettings(
      android: initializationSettingsAndroid,
      iOS: initializationSettingsIOS,
    );

    await _notificationsPlugin.initialize(
      settings: initializationSettings,
    );

    final androidImplementation =
        _notificationsPlugin.resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>();
    if (androidImplementation != null) {
      await androidImplementation.requestNotificationsPermission();
      await androidImplementation.requestExactAlarmsPermission();
    }
  }

  // هذه الدالة ترسل إشعاراً كل 6 ساعات تلقائياً
  static Future<void> scheduleEvery6HoursNotification() async {
    const AndroidNotificationDetails androidDetails = AndroidNotificationDetails(
      'news_channel_id',
      'News Updates',
      channelDescription: 'Notifications for the latest news updates',
      importance: Importance.high,
      priority: Priority.high,
    );

    const NotificationDetails notificationDetails = NotificationDetails(
      android: androidDetails,
      iOS: DarwinNotificationDetails(),
    );

    final now = tz.TZDateTime.now(tz.local);
    for (var index = 1; index <= 4; index++) {
      await _notificationsPlugin.zonedSchedule(
        id: index,
        title: 'new news',
        body: 'check out the latest news!',
        scheduledDate: now.add(Duration(hours: index * 6)),
        notificationDetails: notificationDetails,
        androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
        matchDateTimeComponents: DateTimeComponents.time,
      );
    }
  }
}