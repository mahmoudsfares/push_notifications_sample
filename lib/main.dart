import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:push_notifications_sample/local_notification_service.dart';

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
    );
  }
}

class MyHomePage extends StatelessWidget {
  // TODO 13: create an instance of the notification service class
  final LocalNotificationService _service = LocalNotificationService();

  MyHomePage({super.key});

  void _triggerNotification() async {
    if(await Permission.notification.isDenied){
      Fluttertoast.showToast(msg: 'Notifications permission is denied');
      return;
    }
    _service.showAndroidNotification('hey', 'this is a notification');
  }

  @override
  Widget build(BuildContext context) {
    // TODO 14: initialize notifications service
    _service.init();
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text('Push Notifications'),
      ),
      body: const Center(child: Text('Click the button below to get a notification')),
      floatingActionButton: FloatingActionButton(
        // TODO 15: call the method that shows the notification
        onPressed: _triggerNotification,
        child: const Icon(Icons.notifications),
      ),
    );
  }
}
