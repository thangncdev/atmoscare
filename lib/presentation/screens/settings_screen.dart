import 'package:flutter/material.dart';

/// Màn hình cài đặt (tạm thời để trống)
class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Cài đặt'),
      ),
      body: const Center(
        child: Text(
          'Cài đặt',
          style: TextStyle(fontSize: 24),
        ),
      ),
    );
  }
}

