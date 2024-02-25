import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:push_notifications_sample/local_notification_service.dart';
import 'package:push_notifications_sample/second_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
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

  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  @override
  void initState() {
    super.initState();
    _initNotifications();
  }

  void _initNotifications() async {
    await LocalNotificationService.init();
    var initialNotification = await FlutterLocalNotificationsPlugin().getNotificationAppLaunchDetails();
    if (initialNotification?.didNotificationLaunchApp == true) {
      Future.delayed(const Duration(milliseconds: 500), () {
        Navigator.pushNamed(context, SecondScreen.routeName, arguments: initialNotification?.notificationResponse?.payload);
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
              onPressed: () => LocalNotificationService.cancelAllNotifications(),
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
    LocalNotificationService.showAndroidNotification('hey', 'this is a notification', payload: 'my payload', scheduledAfter: scheduledAfter, repeatInterval: repeatInterval);
  }

  @override
  void dispose() {
    LocalNotificationService.notificationStream.close();
    super.dispose();
  }
}
