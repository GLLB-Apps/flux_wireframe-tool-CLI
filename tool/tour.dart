import 'dart:io';

enum LayoutChoice { sidebar, bottomNav, grid, splitView }
enum IconSetChoice { material, remix }

void main(List<String> args) {
  stdout.writeln('═══════════════════════════════════════════════════════');
  stdout.writeln('  FLUX Wireframe CLI');
  stdout.writeln('  Flutter UI Experience - Wireframe');
  stdout.writeln('═══════════════════════════════════════════════════════');
  stdout.writeln('');
  stdout.writeln('This will overwrite lib/main.dart and create screens.');
  stdout.writeln('Tip: revert quickly with git or your reset tool.');
  stdout.writeln('');

  final layout = _askLayout();
  final iconSet = _askIconSet();

  final appTitle = _askString(
    prompt: 'App title (shown in AppBar)',
    defaultValue: 'FLUX_WIREFRAME',
  );

  final storageKeyDefault = _slugify('${appTitle}_isDarkMode');
  final storageKey = _askString(
    prompt: 'Theme storageKey (SharedPreferences)',
    defaultValue: storageKeyDefault,
  );

  stdout.writeln('');
  stdout.writeln('Selected layout: ${layout.name}');
  stdout.writeln('Icon set: ${iconSet.name}');
  stdout.writeln('Typography: IBM Plex Mono (included in wireframe_theme)');
  stdout.writeln('Title: $appTitle');
  stdout.writeln('storageKey: $storageKey');
  stdout.writeln('');

  final ok = _askYesNo('Proceed and overwrite files?', defaultYes: true);
  if (!ok) {
    stdout.writeln('Aborted.');
    exit(0);
  }

  // Ensure dirs
  Directory('lib/screens').createSync(recursive: true);
  Directory('lib/icons').createSync(recursive: true);

  stdout.writeln('');
  stdout.writeln('Updating pubspec.yaml...');
  
  // CRITICAL: Add wireframe_theme and dependencies FIRST
  _ensureWireframeThemeDependency();
  
  // Ensure Material icon font is bundled (prevents "square" icons)
  _ensureMaterialDesignEnabled();

  // Patch pubspec if Remix chosen
  if (iconSet == IconSetChoice.remix) {
    _ensureRemixDependency();
  }

  stdout.writeln('');
  stdout.writeln('Generating code...');

  // Write icons abstraction
  _writeWithBackup(
    path: 'lib/icons/app_icons.dart',
    content: iconSet == IconSetChoice.remix ? _appIconsRemix() : _appIconsMaterial(),
  );

  // Write main.dart
  _writeWithBackup(
    path: 'lib/main.dart',
    content: _mainDartTemplate(
      appTitle: appTitle,
      storageKey: storageKey,
    ),
  );

  // Write screens
  switch (layout) {
    case LayoutChoice.sidebar:
      _writeWithBackup(
        path: 'lib/screens/home_screen.dart',
        content: _sidebarHomeTemplate(appTitle: appTitle),
      );
      _deleteIfExists('lib/screens/detail_screen.dart');
      break;

    case LayoutChoice.bottomNav:
      _writeWithBackup(
        path: 'lib/screens/home_screen.dart',
        content: _bottomNavHomeTemplate(appTitle: appTitle),
      );
      _deleteIfExists('lib/screens/detail_screen.dart');
      break;

    case LayoutChoice.grid:
      _writeWithBackup(
        path: 'lib/screens/home_screen.dart',
        content: _gridHomeTemplate(appTitle: appTitle),
      );
      _deleteIfExists('lib/screens/detail_screen.dart');
      break;

    case LayoutChoice.splitView:
      _writeWithBackup(
        path: 'lib/screens/home_screen.dart',
        content: _splitViewHomeTemplate(appTitle: appTitle),
      );
      _writeWithBackup(
        path: 'lib/screens/detail_screen.dart',
        content: _splitViewDetailTemplate(),
      );
      break;
  }

  stdout.writeln('');
  stdout.writeln('═══════════════════════════════════════════════════════');
  stdout.writeln('  ✅ Done!');
  stdout.writeln('═══════════════════════════════════════════════════════');
  stdout.writeln('');
  stdout.writeln('Next steps:');
  stdout.writeln('  1. flutter pub get');
  stdout.writeln('  2. flutter run');
  stdout.writeln('');
}

/// ---------------------- PROMPTS ----------------------

LayoutChoice _askLayout() {
  while (true) {
    stdout.writeln('Choose layout:');
    stdout.writeln('  a) Sidebar');
    stdout.writeln('  b) Bottom navbar');
    stdout.writeln('  c) Grid');
    stdout.writeln('  d) Split view');
    stdout.write('Select (a/b/c/d): ');

    final input = stdin.readLineSync()?.trim().toLowerCase();
    switch (input) {
      case 'a':
        return LayoutChoice.sidebar;
      case 'b':
        return LayoutChoice.bottomNav;
      case 'c':
        return LayoutChoice.grid;
      case 'd':
        return LayoutChoice.splitView;
      default:
        stdout.writeln('Invalid choice. Try again.\n');
    }
  }
}

IconSetChoice _askIconSet() {
  while (true) {
    stdout.writeln('\nIcon set:');
    stdout.writeln('  m) Material (default)');
    stdout.writeln('  r) Remix');
    stdout.write('Select (m/r): ');

    final input = stdin.readLineSync()?.trim().toLowerCase();
    if (input == null || input.isEmpty || input == 'm') return IconSetChoice.material;
    if (input == 'r') return IconSetChoice.remix;

    stdout.writeln('Invalid choice. Try again.\n');
  }
}

String _askString({required String prompt, required String defaultValue}) {
  stdout.write('$prompt [$defaultValue]: ');
  final input = stdin.readLineSync();
  final v = (input ?? '').trim();
  return v.isEmpty ? defaultValue : v;
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

/// ---------------------- IO HELPERS ----------------------

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

String _slugify(String s) {
  final lower = s.toLowerCase();
  final buf = StringBuffer();
  for (final rune in lower.runes) {
    final ch = String.fromCharCode(rune);
    final isAz = ch.codeUnitAt(0) >= 97 && ch.codeUnitAt(0) <= 122;
    final is09 = ch.codeUnitAt(0) >= 48 && ch.codeUnitAt(0) <= 57;
    if (isAz || is09) {
      buf.write(ch);
    } else {
      buf.write('_');
    }
  }
  return buf.toString().replaceAll(RegExp(r'_+'), '_').replaceAll(RegExp(r'^_|_$'), '');
}

/// ---------------------- PUBSPEC PATCHES ----------------------

void _ensureWireframeThemeDependency() {
  final pubspec = File('pubspec.yaml');
  if (!pubspec.existsSync()) {
    stdout.writeln('⚠ Warning: pubspec.yaml not found - please add wireframe_theme manually');
    return;
  }

  final text = pubspec.readAsStringSync();

  // Check if wireframe_theme already exists
  if (text.contains(RegExp(r'^\s*wireframe_theme\s*:', multiLine: true))) {
    stdout.writeln('✓ pubspec.yaml: wireframe_theme already present');
    return;
  }

  // Check if provider and shared_preferences exist  
  final hasProvider = text.contains(RegExp(r'^\s*provider\s*:', multiLine: true));
  final hasSharedPrefs = text.contains(RegExp(r'^\s*shared_preferences\s*:', multiLine: true));

  final lines = text.split('\n');
  final out = <String>[];

  bool inDependencies = false;
  bool inserted = false;

  for (var i = 0; i < lines.length; i++) {
    final line = lines[i];
    out.add(line);

    if (line.trim() == 'dependencies:') {
      inDependencies = true;
      continue;
    }

    if (inDependencies && !inserted) {
      final isFlutterSdkLine =
          line.trim() == 'sdk: flutter' && i > 0 && lines[i - 1].trim() == 'flutter:';
      if (isFlutterSdkLine) {
        out.add('');
        out.add('  # Wireframe theme from pub.dev');
        out.add('  wireframe_theme: ^1.0.4');
        
        if (!hasProvider) {
          out.add('');
          out.add('  # State management');
          out.add('  provider: ^6.0.0');
        }
        
        if (!hasSharedPrefs) {
          out.add('');
          out.add('  # Persistent storage');
          out.add('  shared_preferences: ^2.0.0');
        }
        
        // ALWAYS add cupertino_icons for iOS compatibility
        out.add('');
        out.add('  # iOS icons');
        out.add('  cupertino_icons: ^1.0.8');
        
        inserted = true;
      }
    }

    if (inDependencies && line.isNotEmpty && !line.startsWith(' ') && line.trim() != 'dependencies:') {
      inDependencies = false;
    }
  }

  pubspec.writeAsStringSync(out.join('\n'));
  stdout.writeln('✓ pubspec.yaml: added wireframe_theme: ^1.0.4');
  if (!hasProvider) stdout.writeln('✓ pubspec.yaml: added provider: ^6.0.0');
  if (!hasSharedPrefs) stdout.writeln('✓ pubspec.yaml: added shared_preferences: ^2.0.0');
  stdout.writeln('✓ pubspec.yaml: added cupertino_icons: ^1.0.8');
}

void _ensureMaterialDesignEnabled() {
  final pubspec = File('pubspec.yaml');
  if (!pubspec.existsSync()) return;

  final text = pubspec.readAsStringSync();

  // Already set
  if (text.contains(RegExp(r'^\s*uses-material-design\s*:\s*true', multiLine: true))) {
    stdout.writeln('✓ pubspec.yaml: uses-material-design already true');
    return;
  }

  // If flutter: section exists, inject uses-material-design under it
  if (text.contains(RegExp(r'^\s*flutter\s*:\s*$', multiLine: true))) {
    final updated = text.replaceFirst(
      RegExp(r'^\s*flutter\s*:\s*$', multiLine: true),
      'flutter:\n  uses-material-design: true',
    );
    pubspec.writeAsStringSync(updated);
    stdout.writeln('✓ pubspec.yaml: added uses-material-design: true');
    return;
  }

  // Otherwise append flutter section at end
  final updated = '${text.trimRight()}\n\nflutter:\n  uses-material-design: true\n';
  pubspec.writeAsStringSync(updated);
  stdout.writeln('✓ pubspec.yaml: added flutter section with uses-material-design: true');
}

void _ensureRemixDependency() {
  final pubspec = File('pubspec.yaml');
  if (!pubspec.existsSync()) return;

  final text = pubspec.readAsStringSync();

  // Already present
  if (text.contains(RegExp(r'^\s*remixicon\s*:', multiLine: true))) {
    stdout.writeln('✓ pubspec.yaml: remixicon already present');
    return;
  }

  // Insert after "flutter:\n    sdk: flutter" inside dependencies:
  final lines = text.split('\n');
  final out = <String>[];

  bool inDependencies = false;
  bool inserted = false;

  for (var i = 0; i < lines.length; i++) {
    final line = lines[i];
    out.add(line);

    if (line.trim() == 'dependencies:') {
      inDependencies = true;
      continue;
    }

    if (inDependencies && !inserted) {
      final isFlutterSdkLine =
          line.trim() == 'sdk: flutter' && i > 0 && lines[i - 1].trim() == 'flutter:';
      if (isFlutterSdkLine) {
        out.add('');
        out.add('  # Remix icons');
        out.add('  remixicon: ^1.0.0');
        inserted = true;
      }
    }

    // Leaving dependencies block
    if (inDependencies && line.isNotEmpty && !line.startsWith(' ') && line.trim() != 'dependencies:') {
      inDependencies = false;
    }
  }

  pubspec.writeAsStringSync(out.join('\n'));
  stdout.writeln('✓ pubspec.yaml: added remixicon: ^1.0.0');
}

/// ---------------------- TEMPLATES ----------------------

String _mainDartTemplate({
  required String appTitle,
  required String storageKey,
}) {
  return '''
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:wireframe_theme/wireframe_theme.dart';

import 'screens/home_screen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final theme = ThemeController(storageKey: '$storageKey');
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
      title: '$appTitle',
      debugShowCheckedModeBanner: false,
      theme: WireframeTheme.getTheme(false),
      darkTheme: WireframeTheme.getTheme(true),
      themeMode: theme.isDarkMode ? ThemeMode.dark : ThemeMode.light,
      home: const HomeScreen(),
    );
  }
}
''';
}

String _appBarActionsTemplate() {
  return r'''
actions: [
  IconButton(
    tooltip: theme.isDarkMode ? 'Light mode' : 'Dark mode',
    icon: Icon(theme.isDarkMode ? AppIcons.lightMode : AppIcons.darkMode),
    onPressed: () => context.read<ThemeController>().toggle(),
  ),
],
''';
}

String _sidebarHomeTemplate({required String appTitle}) {
  return '''
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:wireframe_theme/wireframe_theme.dart';
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
      _Page(title: 'Dashboard', icon: AppIcons.dashboard),
      _Page(title: 'Inbox', icon: AppIcons.inbox),
      _Page(title: 'Settings', icon: AppIcons.settings),
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text('$appTitle'),
        ${_appBarActionsTemplate()}
      ),
      body: Row(
        children: [
          NavigationRail(
            selectedIndex: _index,
            onDestinationSelected: (i) => setState(() => _index = i),
            labelType: NavigationRailLabelType.all,
            destinations: const [
              NavigationRailDestination(
                icon: Icon(AppIcons.dashboard),
                selectedIcon: Icon(AppIcons.dashboard),
                label: Text('Dash'),
              ),
              NavigationRailDestination(
                icon: Icon(AppIcons.inbox),
                selectedIcon: Icon(AppIcons.inbox),
                label: Text('Inbox'),
              ),
              NavigationRailDestination(
                icon: Icon(AppIcons.settings),
                selectedIcon: Icon(AppIcons.settings),
                label: Text('Settings'),
              ),
            ],
          ),
          const VerticalDivider(width: 2, thickness: 2),
          Expanded(child: pages[_index]),
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
              SizedBox(
                width: 360,
                child: TextField(
                  decoration: const InputDecoration(
                    labelText: 'TextField',
                    hintText: 'Theme smoke test…',
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
''';
}

String _bottomNavHomeTemplate({required String appTitle}) {
  return '''
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:wireframe_theme/wireframe_theme.dart';
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
        title: const Text('$appTitle'),
        ${_appBarActionsTemplate()}
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
''';
}

String _gridHomeTemplate({required String appTitle}) {
  return '''
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:wireframe_theme/wireframe_theme.dart';
import '../icons/app_icons.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = context.watch<ThemeController>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('$appTitle'),
        ${_appBarActionsTemplate()}
      ),
      body: LayoutBuilder(
        builder: (context, c) {
          final width = c.maxWidth;
          final crossAxisCount = width >= 1100 ? 4 : width >= 800 ? 3 : width >= 520 ? 2 : 1;

          return Padding(
            padding: const EdgeInsets.all(12),
            child: GridView.builder(
              itemCount: 12,
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: crossAxisCount,
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
                childAspectRatio: 1.2,
              ),
              itemBuilder: (context, i) {
                return Card(
                  child: InkWell(
                    onTap: () {},
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Card \${i + 1}', style: Theme.of(context).textTheme.titleLarge),
                          const SizedBox(height: 12),
                          const Text('Grid layout starter block.'),
                          const Spacer(),
                          Row(
                            children: [
                              Expanded(
                                child: OutlinedButton(
                                  onPressed: () {},
                                  child: const Text('Action'),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }
}
''';
}

String _splitViewHomeTemplate({required String appTitle}) {
  return '''
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:wireframe_theme/wireframe_theme.dart';
import '../icons/app_icons.dart';

import 'detail_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  static const double _breakpoint = 840;
  int? _selectedId;

  final _items = List.generate(
    25,
    (i) => _Item(id: i + 1, title: 'Item \${(i + 1).toString().padLeft(2, '0')}'),
  );

  @override
  Widget build(BuildContext context) {
    final theme = context.watch<ThemeController>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('$appTitle'),
        ${_appBarActionsTemplate()}
      ),
      body: LayoutBuilder(
        builder: (context, c) {
          final wide = c.maxWidth >= _breakpoint;

          if (!wide) {
            return ListView.separated(
              itemCount: _items.length,
              separatorBuilder: (_, __) => const Divider(),
              itemBuilder: (context, i) {
                final item = _items[i];
                return ListTile(
                  title: Text(item.title),
                  trailing: const Icon(AppIcons.chevronRight),
                  onTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (_) => DetailScreen(item: item),
                      ),
                    );
                  },
                );
              },
            );
          }

          final selected = _selectedId == null ? null : _items.firstWhere((x) => x.id == _selectedId);

          return Row(
            children: [
              SizedBox(
                width: 360,
                child: ListView.separated(
                  itemCount: _items.length,
                  separatorBuilder: (_, __) => const Divider(),
                  itemBuilder: (context, i) {
                    final item = _items[i];
                    final isSelected = item.id == _selectedId;

                    return ListTile(
                      selected: isSelected,
                      title: Text(item.title),
                      onTap: () => setState(() => _selectedId = item.id),
                    );
                  },
                ),
              ),
              const VerticalDivider(width: 2, thickness: 2),
              Expanded(
                child: selected == null ? const _EmptyDetail() : DetailScreen(item: selected, embedded: true),
              ),
            ],
          );
        },
      ),
    );
  }
}

class _EmptyDetail extends StatelessWidget {
  const _EmptyDetail();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Text(
            'Välj en sak till vänster',
            style: Theme.of(context).textTheme.headlineMedium,
          ),
        ),
      ),
    );
  }
}

class _Item {
  const _Item({required this.id, required this.title});
  final int id;
  final String title;
}
''';
}

String _splitViewDetailTemplate() {
  return '''
import 'package:flutter/material.dart';

class DetailScreen extends StatelessWidget {
  const DetailScreen({
    super.key,
    required this.item,
    this.embedded = false,
  });

  final dynamic item;
  final bool embedded;

  @override
  Widget build(BuildContext context) {
    final title = (item as dynamic).title as String;

    final body = Center(
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 520),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(title, style: Theme.of(context).textTheme.headlineMedium),
                const SizedBox(height: 12),
                const Text('Split view detail panel / page.'),
                const SizedBox(height: 16),
                const TextField(
                  decoration: InputDecoration(
                    labelText: 'Notes',
                    hintText: 'Skriv något...',
                  ),
                  maxLines: 3,
                ),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () {},
                  child: const Text('Save'),
                ),
                const SizedBox(height: 12),
                OutlinedButton(
                  onPressed: () {},
                  child: const Text('Secondary'),
                ),
              ],
            ),
          ),
        ),
      ),
    );

    if (embedded) return body;

    return Scaffold(
      appBar: AppBar(title: Text(title)),
      body: body,
    );
  }
}
''';
}

String _appIconsMaterial() {
  return '''
import 'package:flutter/material.dart';

class AppIcons {
  static const IconData dashboard = Icons.dashboard_outlined;
  static const IconData inbox = Icons.inbox_outlined;
  static const IconData settings = Icons.settings_outlined;

  static const IconData home = Icons.home_outlined;
  static const IconData search = Icons.search_outlined;
  static const IconData profile = Icons.person_outline;

  static const IconData chevronRight = Icons.chevron_right;

  static const IconData darkMode = Icons.dark_mode;
  static const IconData lightMode = Icons.light_mode;
}
''';
}

String _appIconsRemix() {
  return '''
import 'package:flutter/widgets.dart';
import 'package:remixicon/remixicon.dart';

class AppIcons {
  static const IconData dashboard = Remix.dashboard_line;
  static const IconData inbox = Remix.inbox_line;
  static const IconData settings = Remix.settings_3_line;

  static const IconData home = Remix.home_2_line;
  static const IconData search = Remix.search_2_line;
  static const IconData profile = Remix.user_3_line;

  static const IconData chevronRight = Remix.arrow_right_s_line;

  static const IconData darkMode = Remix.moon_line;
  static const IconData lightMode = Remix.sun_line;
}
''';
}