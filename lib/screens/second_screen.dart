import 'package:flutter/material.dart';

class SecondScreen extends StatelessWidget {

  static const String routeName = '/second';

  const SecondScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final String payload = ModalRoute.of(context)!.settings.arguments as String;
    return Scaffold(
      appBar: AppBar(title: const Text('Data')),
      body: Center(child: Text(payload),),
    );
  }
}
