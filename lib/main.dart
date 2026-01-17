import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:wireframe_theme_flutter/wireframe_theme_flutter.dart';
import 'package:google_fonts/google_fonts.dart';

import 'screens/home_screen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final theme = ThemeController(storageKey: 'mono_text_isdarkmode');
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

    ThemeData _applyMonospace(ThemeData t) {
    return t.copyWith(
      textTheme: GoogleFonts.ibmPlexMonoTextTheme(t.textTheme),
      primaryTextTheme: GoogleFonts.ibmPlexMonoTextTheme(t.primaryTextTheme),
    );
  }
  

  @override
  Widget build(BuildContext context) {
    final theme = context.watch<ThemeController>();

    return MaterialApp(
      title: 'MONO_TEXT',
      debugShowCheckedModeBanner: false,
      theme: _applyMonospace(WireframeTheme.getTheme(false)),
      darkTheme: _applyMonospace(WireframeTheme.getTheme(true)),
      themeMode: theme.isDarkMode ? ThemeMode.dark : ThemeMode.light,
      home: const HomeScreen(),
    );
  }
}
