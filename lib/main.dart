import 'package:flutter/material.dart';
import 'package:push_notifications_sample/local_notification_service.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatelessWidget {
  final LocalNotificationService _service = LocalNotificationService();

  MyHomePage({super.key});

  void _triggerNotification() {
    _service.showIOSNotification('hey', 'this is a notification');
  }

  @override
  Widget build(BuildContext context) {
    _service.init();
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text('Notifications'),
      ),
      body: const Center(child: Text('Click the button below to get a notification')),
      floatingActionButton: FloatingActionButton(
        onPressed: _triggerNotification,
        child: const Icon(Icons.notifications),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
