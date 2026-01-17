import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:wireframe_theme_flutter/wireframe_theme_flutter.dart';
import '../icons/app_icons.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _index = 0;

  @override
  Widget build(BuildContext context) {
    final theme = context.watch<ThemeController>();

    final pages = <Widget>[
      _Page(title: 'Home', icon: AppIcons.home),
      _Page(title: 'Search', icon: AppIcons.search),
      _Page(title: 'Profile', icon: AppIcons.profile),
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text('MONO_TEXT'),
        actions: [
  IconButton(
    tooltip: theme.isDarkMode ? 'Light mode' : 'Dark mode',
    icon: Icon(theme.isDarkMode ? AppIcons.lightMode : AppIcons.darkMode),
    onPressed: () => context.read<ThemeController>().toggle(),
  ),
],

      ),
      body: IndexedStack(index: _index, children: pages),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _index,
        onTap: (i) => setState(() => _index = i),
        unselectedItemColor: Theme.of(context).colorScheme.onSurface.withOpacity(0.6),
        items: const [
          BottomNavigationBarItem(icon: Icon(AppIcons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(AppIcons.search), label: 'Search'),
          BottomNavigationBarItem(icon: Icon(AppIcons.profile), label: 'Profile'),
        ],
      ),
    );
  }
}

class _Page extends StatelessWidget {
  const _Page({required this.title, required this.icon});

  final String title;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(icon, size: 48),
              const SizedBox(height: 12),
              Text(title, style: Theme.of(context).textTheme.headlineMedium),
              const SizedBox(height: 12),
              ElevatedButton(onPressed: () {}, child: const Text('Primary action')),
            ],
          ),
        ),
      ),
    );
  }
}
