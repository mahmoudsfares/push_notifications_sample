import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:push_notifications_sample/notifications/local_notification_service.dart';
import 'package:push_notifications_sample/screens/second_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final LocalNotificationService _notificationService = LocalNotificationService();

  @override
  void initState() {
    super.initState();
    _initNotifications();
  }

  // TODO 13: initialize notification service and set the action to be made when the notification is tapped
  void _initNotifications() async {
    await _notificationService.init();
    var initialNotification = await _notificationService.notificationsPlugin.getNotificationAppLaunchDetails();
    if (initialNotification?.didNotificationLaunchApp == true) {
      // avoid using context across an async gap by ensuring that the context is used after the current frame is rendered
      Future.delayed(
        Duration.zero,
        () => Navigator.pushNamed(context, SecondScreen.routeName, arguments: initialNotification?.notificationResponse?.payload),
      );
    } else {
      LocalNotificationService.notificationStream.stream.listen((payload) {
        Navigator.pushNamed(context, SecondScreen.routeName, arguments: payload);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text('Push Notifications'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // TODO 14: call the notification triggering method
            ElevatedButton(onPressed: () => _triggerNotification(), child: const Text('Instant notification')),
            ElevatedButton(
              onPressed: () => _triggerNotification(repeatInterval: RepeatInterval.everyMinute),
              child: const Text('Periodic notification'),
            ),
            ElevatedButton(
              onPressed: () => _triggerNotification(scheduledAfter: const Duration(seconds: 5)),
              child: const Text('Scheduled notification'),
            ),
            ElevatedButton(
              onPressed: () => _notificationService.cancelAllNotifications(),
              child: const Text('Cancel all notifications'),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _triggerNotification({Duration? scheduledAfter, RepeatInterval? repeatInterval}) async {
    if (await Permission.notification.isDenied) {
      Fluttertoast.showToast(msg: 'Notifications permission is denied');
      return;
    }
    _notificationService.showIOSNotification(
      'hey',
      'this is a notification',
      payload: 'my payload',
      scheduledAfter: scheduledAfter,
      repeatInterval: repeatInterval,
    );
  }

  @override
  void dispose() {
    LocalNotificationService.notificationStream.close();
    super.dispose();
  }
}
