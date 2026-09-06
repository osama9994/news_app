
// import 'package:firebase_messaging/firebase_messaging.dart';
// import 'package:news_app/core/models/article_model.dart';
// import 'package:news_app/features/notifications/notification_cubit/notification_cubit.dart';

// class FirebaseNotificationService {
//   final FirebaseMessaging _messaging = FirebaseMessaging.instance;

//   Future<void> init(NotificationCubit cubit) async {
//     await _messaging.requestPermission();

//     FirebaseMessaging.onMessage.listen((RemoteMessage message) {
//       final data = message.data;

//       final article = Article(
//         title: data['title'],
//         description: data['description'],
//         urlToImage: data['image'],
//         url: data['url'],
//         publishedAt: DateTime.now().toString(),
//       );

//       cubit.addNotification(article);
//     });
//   }
// }
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:news_app/core/models/article_model.dart';
import 'package:news_app/features/notifications/notification_cubit/notification_cubit.dart';

@pragma('vm:entry-point')
Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {}

class FirebaseNotificationService {
  final FirebaseMessaging _messaging = FirebaseMessaging.instance;

  Future<void> init(NotificationCubit cubit) async {
    await _messaging.requestPermission(
      alert: true,
      badge: true,
      sound: true,
    );

    FirebaseMessaging.onBackgroundMessage(firebaseMessagingBackgroundHandler);

    // ✅ التطبيق مفتوح
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      _saveToNotifications(message, cubit);
    });

    // ✅ التطبيق في الخلفية وضغط على الإشعار
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      _saveToNotifications(message, cubit);
    });

    // ✅ التطبيق كان مغلقاً
    final initialMessage = await _messaging.getInitialMessage();
    if (initialMessage != null) {
      _saveToNotifications(initialMessage, cubit);
    }
  }

  void _saveToNotifications(RemoteMessage message, NotificationCubit cubit) {
    final data = message.data;
    final notification = message.notification;

    final article = Article(
      title: data['title'] ?? notification?.title ?? 'No title',
      description: data['description'] ?? notification?.body ?? '',
      urlToImage: data['image'] ?? '',
      url: data['url'] ?? '',
      publishedAt: DateTime.now().toString(),
    );

    cubit.addNotification(article);
  }
}
