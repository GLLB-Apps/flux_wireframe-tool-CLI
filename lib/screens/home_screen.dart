import 'package:flutter/material.dart';
import '../icons/app_icons.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Native reset'),
      ),
      body: Center(
        child: Card(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(AppIcons.home, size: 48),
                const SizedBox(height: 12),
                Text(
                  'Reset successful',
                  style: Theme.of(context).textTheme.headlineSmall,
                ),
                const SizedBox(height: 8),
                const Text('You are back on native Material 3.'),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
