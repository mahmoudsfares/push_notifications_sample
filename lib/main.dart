import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:push_notifications_sample/local_notification_service.dart';
import 'package:push_notifications_sample/second_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: MyHomePage(),
      routes: {
        SecondScreen.routeName: (context) => const SecondScreen(),
      },
    );
  }
}

class MyHomePage extends StatefulWidget {

  // TODO 13: create an instance of the notification service class
  final LocalNotificationService _service = LocalNotificationService();

  MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  @override
  void initState() {
    super.initState();
    // TODO 14: initialize notifications service
    widget._service.init();

    LocalNotificationService.notificationStream.stream.listen((String payload) {
      Navigator.pushNamed(context, SecondScreen.routeName, arguments: payload);
    });
  }

  @override
  void dispose() {
    // LocalNotificationService.notificationStream.close();
    super.dispose();
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
            // TODO 15: call the notification triggering method
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
              onPressed: () => widget._service.cancelAllNotifications(),
              child: const Text('Cancel Periodic notification'),
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
    widget._service.showAndroidNotification('hey', 'this is a notification', payload: 'my payload', scheduledAfter: scheduledAfter, repeatInterval: repeatInterval);
  }
}
