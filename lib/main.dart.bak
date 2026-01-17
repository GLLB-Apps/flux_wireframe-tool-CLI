import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:wireframe_theme/wireframe_theme.dart';

import 'screens/home_screen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final theme = ThemeController(storageKey: 'flux_wireframe_isdarkmode');
  await theme.init();

  runApp(
    ChangeNotifierProvider.value(
      value: theme,
      child: const App(),
    ),
  );
}

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = context.watch<ThemeController>();

    return MaterialApp(
      title: 'FLUX_WIREFRAME',
      debugShowCheckedModeBanner: false,
      theme: WireframeTheme.getTheme(false),
      darkTheme: WireframeTheme.getTheme(true),
      themeMode: theme.isDarkMode ? ThemeMode.dark : ThemeMode.light,
      home: const HomeScreen(),
    );
  }
}
