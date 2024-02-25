import 'dart:async';
import 'dart:io';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

class LocalNotificationService {
  // TODO 5: instantiate FlutterLocalNotificationsPlugin
  final FlutterLocalNotificationsPlugin notificationsPlugin = FlutterLocalNotificationsPlugin();

  // TODO 6: handle onTap actions by passing the payload to an observable stream
  static final StreamController<String> notificationStream = StreamController<String>();

  static void onTapNotification(NotificationResponse response) => notificationStream.add(response.payload!);

  /// initialize native notifications for the required platforms
  Future<void> init() async {
    // TODO 7: check if the notifications permission is granted (permission required starting from API 33)
    if (!(await checkNotificationsPermission())) return;
    // TODO 8: specify both platforms notification settings
    const AndroidInitializationSettings androidInitializationSettings = AndroidInitializationSettings('@mipmap/ic_launcher');
    DarwinInitializationSettings iosInitializationSettings = DarwinInitializationSettings(
      onDidReceiveLocalNotification: (id, title, body, payload) {},
    );
    // TODO 9: add both platform specific settings as arguments for the generic notification initialization settings
    InitializationSettings initializationSettings = InitializationSettings(android: androidInitializationSettings, iOS: iosInitializationSettings);
    // TODO 10: initialize the notifications plugin using the generic initialization settings
    await notificationsPlugin.initialize(
      initializationSettings,
      onDidReceiveNotificationResponse: onTapNotification,
      onDidReceiveBackgroundNotificationResponse: onTapNotification,
    );
  }

  Future<void> showAndroidNotification(String title, String body, {String? payload, Duration? scheduledAfter, RepeatInterval? repeatInterval}) async {
    // TODO 11: define android channel
    // id: has to be unique all over the app as it identifies the channel
    // name: channel name, for example "advertisements channel" or "payment notifications channel"
    // description: for example, this channel groups the notifications that are related to advertisements and offers
    // ticker: the text that will appear briefly in the status bar when the notification is first posted.
    const AndroidNotificationDetails androidNotificationChannel = AndroidNotificationDetails(
      'PAYMENT',
      'Payment channel',
      channelDescription: 'this channel works as a group for payment related notifications',
      importance: Importance.max,
      priority: Priority.high,
      ticker: 'you\'ve got a notification',
    );
    const NotificationDetails notificationDetails = NotificationDetails(android: androidNotificationChannel);
    const int notificationId = 1;

    // TODO 12: show notification
    if (scheduledAfter != null) {
      tz.initializeTimeZones();
      tz.Location localTime = tz.local;
      tz.TZDateTime scheduledDate = tz.TZDateTime.now(localTime).add(scheduledAfter);
      await notificationsPlugin.zonedSchedule(
        notificationId,
        title,
        body,
        scheduledDate,
        notificationDetails,
        payload: payload,
        uiLocalNotificationDateInterpretation: UILocalNotificationDateInterpretation.absoluteTime,
      );
    } else if (repeatInterval != null) {
      await notificationsPlugin.periodicallyShow(notificationId, title, body, RepeatInterval.everyMinute, notificationDetails, payload: payload);
    } else {
      await notificationsPlugin.show(notificationId, title, body, notificationDetails, payload: payload);
    }
  }

  Future<void> showIOSNotification(String title, String body, {String? payload, Duration? scheduledAfter, RepeatInterval? repeatInterval}) async {
    // TODO 11: define ios channel
    // presentAlert: Present an alert when the notification is displayed and the application is in the foreground (only from iOS 10 onwards)
    // presentBadge: Present the badge number when the notification is displayed and the application is in the foreground (only from iOS 10 onwards)
    // presentSound: Play a sound when the notification is displayed and the application is in the foreground (only from iOS 10 onwards)
    // sound: Specifics the file path to play (only from iOS 10 onwards)
    // badgeNumber: The application's icon badge number
    // attachments: List<IOSNotificationAttachment>?, (only from iOS 10 onwards)
    // subtitle: Secondary description  (only from iOS 10 onwards)
    const DarwinNotificationDetails iOSNotificationChannel = DarwinNotificationDetails(
      threadIdentifier: 'PAYMENT',
      subtitle: 'Payment channel: this channel works as a group for payment related notifications',
      presentAlert: false,
      presentBadge: true,
      presentSound: true,
    );
    const NotificationDetails notificationDetails = NotificationDetails(iOS: iOSNotificationChannel);
    const int notificationId = 1;

    // TODO 12: show notification
    if (scheduledAfter != null) {
      tz.initializeTimeZones();
      tz.Location localTime = tz.local;
      tz.TZDateTime scheduledDate = tz.TZDateTime.now(localTime).add(scheduledAfter);
      await notificationsPlugin.zonedSchedule(
        notificationId,
        title,
        body,
        scheduledDate,
        notificationDetails,
        payload: payload,
        uiLocalNotificationDateInterpretation: UILocalNotificationDateInterpretation.absoluteTime,
      );
    } else if (repeatInterval != null) {
      await notificationsPlugin.periodicallyShow(notificationId, title, body, RepeatInterval.everyMinute, notificationDetails, payload: payload);
    } else {
      await notificationsPlugin.show(notificationId, title, body, notificationDetails, payload: payload);
    }
  }

  Future<void> cancelNotificationWithId(int notificationId) async {
    await notificationsPlugin.cancel(notificationId);
  }

  Future<void> cancelAllNotifications() async {
    await notificationsPlugin.cancelAll();
  }

  Future<bool> checkNotificationsPermission() async {
    if (Platform.isAndroid && await Permission.notification.isDenied) {
      PermissionStatus status = await Permission.notification.request();
      if (status.isDenied) {
        Fluttertoast.showToast(msg: 'You have to accept push notifications permission');
        return false;
      }
    }
    return true;
  }
}