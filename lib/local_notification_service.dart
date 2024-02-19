import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class LocalNotificationService {
  final FlutterLocalNotificationsPlugin notificationsPlugin =
      FlutterLocalNotificationsPlugin();

  /// initialize native notifications for the required platforms
  Future<void> init() async {
    const AndroidInitializationSettings androidInitializationSettings =
        AndroidInitializationSettings('@mipmap/ic_launcher');
    const DarwinInitializationSettings iosInitializationSettings =
        DarwinInitializationSettings(
      requestSoundPermission: true,
      requestBadgePermission: true,
      requestAlertPermission: true,
    );

    const InitializationSettings initializationSettings =
        InitializationSettings(
      android: androidInitializationSettings,
      iOS: iosInitializationSettings,
    );

    await notificationsPlugin.initialize(initializationSettings);
  }

  Future<void> showAndroidNotification(String title, String value) async {
    // id: has to be unique all over the app as it identifies the channel
    // name: channel name, for example "advertisements channel" or "payment notifications channel"
    // description: for example, this channel groups the notifications that are related to advertisements and offers
    // ticker: the text that will appear briefly in the status bar when the notification is first posted.
    const AndroidNotificationDetails androidNotificationChannel =
        AndroidNotificationDetails(
      'PAYMENT',
      'Payment channel',
      channelDescription:
          'this channel works as a group for payment related notifications',
      importance: Importance.max,
      priority: Priority.high,
      ticker: 'you\'ve got a notification',
    );

    const NotificationDetails notificationDetails =
        NotificationDetails(android: androidNotificationChannel);
    const int notificationId = 1;

    await notificationsPlugin.show(
        notificationId, title, value, notificationDetails);
  }

  Future<void> showIOSNotification(String title, String value) async {
    // presentAlert: Present an alert when the notification is displayed and the application is in the foreground (only from iOS 10 onwards)
    // presentBadge: Present the badge number when the notification is displayed and the application is in the foreground (only from iOS 10 onwards)
    // presentSound: Play a sound when the notification is displayed and the application is in the foreground (only from iOS 10 onwards)
    // sound: Specifics the file path to play (only from iOS 10 onwards)
    // badgeNumber: The application's icon badge number
    // attachments: List<IOSNotificationAttachment>?, (only from iOS 10 onwards)
    // subtitle: Secondary description  (only from iOS 10 onwards)
    const DarwinNotificationDetails iOSNotificationChannel =
        DarwinNotificationDetails(
      threadIdentifier: 'PAYMENT',
      subtitle:
          'Payment channel: this channel works as a group for payment related notifications',
      presentAlert: false,
      presentBadge: true,
      presentSound: true,
    );

    const NotificationDetails notificationDetails =
        NotificationDetails(iOS: iOSNotificationChannel);
    const int notificationId = 1;

    await notificationsPlugin.show(
        notificationId, title, value, notificationDetails);
  }

  Future<bool?> requestNotificationsPermissionIOS() async {
    return await notificationsPlugin
        .resolvePlatformSpecificImplementation<
            IOSFlutterLocalNotificationsPlugin>()
        ?.requestPermissions(alert: true, badge: true, sound: true);
  }
}
