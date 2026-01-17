import 'dart:io';

void main() {
  stdout.writeln('FLUX_WIREFRAME – RESET');
  stdout.writeln('This will restore a native Material setup.');
  stdout.writeln('');

  final ok = _askYesNo('Proceed with reset?', defaultYes: false);
  if (!ok) {
    stdout.writeln('Aborted.');
    exit(0);
  }

  Directory('lib/screens').createSync(recursive: true);
  Directory('lib/icons').createSync(recursive: true);

  _writeWithBackup(
    path: 'lib/icons/app_icons.dart',
    content: _appIconsMaterial(),
  );

  _writeWithBackup(
    path: 'lib/main.dart',
    content: _nativeMainDart(),
  );

  _writeWithBackup(
    path: 'lib/screens/home_screen.dart',
    content: _nativeHomeScreen(),
  );

  _deleteIfExists('lib/screens/detail_screen.dart');

  stdout.writeln('');
  stdout.writeln('Reset complete ✅');
  stdout.writeln('Next: flutter run');
}

bool _askYesNo(String prompt, {required bool defaultYes}) {
  final def = defaultYes ? 'Y/n' : 'y/N';
  while (true) {
    stdout.write('$prompt [$def]: ');
    final input = stdin.readLineSync()?.trim().toLowerCase();
    if (input == null || input.isEmpty) return defaultYes;
    if (input == 'y' || input == 'yes') return true;
    if (input == 'n' || input == 'no') return false;
    stdout.writeln('Please answer y or n.');
  }
}

void _writeWithBackup({required String path, required String content}) {
  final file = File(path);

  if (file.existsSync()) {
    final backupPath = '$path.bak';
    File(backupPath).writeAsBytesSync(file.readAsBytesSync());
    stdout.writeln('Backup: $backupPath');
  } else {
    file.parent.createSync(recursive: true);
  }

  file.writeAsStringSync(content);
  stdout.writeln('Wrote:  $path');
}

void _deleteIfExists(String path) {
  final f = File(path);
  if (f.existsSync()) {
    f.deleteSync();
    stdout.writeln('Removed: $path');
  }
}

String _nativeMainDart() {
  return '''
import 'package:flutter/material.dart';
import 'screens/home_screen.dart';

void main() {
  runApp(const App());
}

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(useMaterial3: true),
      darkTheme: ThemeData(
        useMaterial3: true,
        brightness: Brightness.dark,
      ),
      home: const HomeScreen(),
    );
  }
}
''';
}

String _nativeHomeScreen() {
  return '''
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
''';
}

String _appIconsMaterial() {
  return '''
import 'package:flutter/material.dart';

class AppIcons {
  static const IconData home = Icons.home_outlined;
  static const IconData settings = Icons.settings_outlined;
  static const IconData inbox = Icons.inbox_outlined;

  static const IconData lightMode = Icons.light_mode;
  static const IconData darkMode = Icons.dark_mode;
}
''';
}
