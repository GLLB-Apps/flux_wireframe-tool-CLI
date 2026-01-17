import 'dart:io';

void main(List<String> args) {
  stdout.writeln('═══════════════════════════════════════════════════════');
  stdout.writeln('  FLUX Wireframe CLI - Status');
  stdout.writeln('  Project overview');
  stdout.writeln('═══════════════════════════════════════════════════════');
  stdout.writeln('');

  // Check if in Flutter project
  final pubspecFile = File('pubspec.yaml');
  if (!pubspecFile.existsSync()) {
    stdout.writeln('✗ Not in a Flutter project directory');
    stdout.writeln('  No pubspec.yaml found');
    stdout.writeln('');
    exit(1);
  }

  final content = pubspecFile.readAsStringSync();
  
  // Get project name
  final nameMatch = RegExp(r'^name:\s*(.+)$', multiLine: true).firstMatch(content);
  final projectName = nameMatch?.group(1)?.trim() ?? 'Unknown';

  // Get version
  final versionMatch = RegExp(r'^version:\s*(.+)$', multiLine: true).firstMatch(content);
  final version = versionMatch?.group(1)?.trim() ?? 'Unknown';

  stdout.writeln('📦 Project: $projectName');
  stdout.writeln('📌 Version: $version');
  stdout.writeln('');

  // Check FLUX status
  final hasWireframeTheme = content.contains(RegExp(r'^\s*wireframe_theme\s*:', multiLine: true));
  final hasProvider = content.contains(RegExp(r'^\s*provider\s*:', multiLine: true));
  final hasSharedPrefs = content.contains(RegExp(r'^\s*shared_preferences\s*:', multiLine: true));
  final hasRemixicon = content.contains(RegExp(r'^\s*remixicon\s*:', multiLine: true));
  final hasCupertinoIcons = content.contains(RegExp(r'^\s*cupertino_icons\s*:', multiLine: true));

  stdout.writeln('Dependencies:');
  stdout.writeln('  ${hasWireframeTheme ? '✓' : '✗'} wireframe_theme');
  stdout.writeln('  ${hasProvider ? '✓' : '✗'} provider');
  stdout.writeln('  ${hasSharedPrefs ? '✓' : '✗'} shared_preferences');
  stdout.writeln('  ${hasRemixicon ? '✓' : '○'} remixicon (optional)');
  stdout.writeln('  ${hasCupertinoIcons ? '✓' : '○'} cupertino_icons (optional)');
  stdout.writeln('');

  // Check generated files
  final mainDart = File('lib/main.dart');
  final screensDir = Directory('lib/screens');
  final iconsDir = Directory('lib/icons');

  final hasMain = mainDart.existsSync();
  final hasScreens = screensDir.existsSync();
  final hasIcons = iconsDir.existsSync();

  stdout.writeln('Generated files:');
  stdout.writeln('  ${hasMain ? '✓' : '✗'} lib/main.dart');
  stdout.writeln('  ${hasScreens ? '✓' : '✗'} lib/screens/');
  stdout.writeln('  ${hasIcons ? '✓' : '✗'} lib/icons/');

  // Count screens if directory exists
  if (hasScreens) {
    final screenFiles = screensDir
        .listSync()
        .whereType<File>()
        .where((f) => f.path.endsWith('.dart'))
        .toList();
    stdout.writeln('     └─ ${screenFiles.length} screen(s)');
    for (final screen in screenFiles) {
      final name = screen.path.split(Platform.pathSeparator).last;
      stdout.writeln('        • $name');
    }
  }

  // Count icons if directory exists
  if (hasIcons) {
    final iconFiles = iconsDir
        .listSync()
        .whereType<File>()
        .where((f) => f.path.endsWith('.dart'))
        .toList();
    stdout.writeln('     └─ ${iconFiles.length} icon file(s)');
  }

  stdout.writeln('');

  // Check for backup files
  final libDir = Directory('lib');
  if (libDir.existsSync()) {
    final bakFiles = libDir
        .listSync(recursive: true)
        .whereType<File>()
        .where((f) => f.path.endsWith('.bak'))
        .toList();

    if (bakFiles.isNotEmpty) {
      stdout.writeln('Backup files:');
      stdout.writeln('  ⚠ ${bakFiles.length} .bak file(s) found');
      for (final bak in bakFiles.take(5)) {
        final relativePath = bak.path.replaceAll('\\', '/').split('lib/').last;
        stdout.writeln('     • lib/$relativePath');
      }
      if (bakFiles.length > 5) {
        stdout.writeln('     ... and ${bakFiles.length - 5} more');
      }
      stdout.writeln('');
    }
  }

  // Determine FLUX status
  final isFluxProject = hasWireframeTheme && hasProvider && hasSharedPrefs;
  final isFullyScaffolded = hasMain && hasScreens && hasIcons;

  stdout.writeln('═══════════════════════════════════════════════════════');
  
  if (isFluxProject && isFullyScaffolded) {
    stdout.writeln('  ✅ FLUX Wireframe project - fully scaffolded');
    stdout.writeln('═══════════════════════════════════════════════════════');
    stdout.writeln('');
    stdout.writeln('Your app is ready to use!');
    stdout.writeln('');
    stdout.writeln('Commands:');
    stdout.writeln('  • flutter run              - Run your app');
    stdout.writeln('  • flux_wireframe_clear     - Reset to clean Flutter');
    stdout.writeln('  • flux_wireframe_doctor    - Check environment');
  } else if (isFluxProject && !isFullyScaffolded) {
    stdout.writeln('  ⚠️  FLUX Wireframe dependencies installed');
    stdout.writeln('═══════════════════════════════════════════════════════');
    stdout.writeln('');
    stdout.writeln('Dependencies are ready, but files are missing.');
    stdout.writeln('');
    stdout.writeln('Next steps:');
    stdout.writeln('  • flux_wireframe           - Scaffold your app');
  } else if (!isFluxProject && isFullyScaffolded) {
    stdout.writeln('  ⚠️  FLUX files found but dependencies missing');
    stdout.writeln('═══════════════════════════════════════════════════════');
    stdout.writeln('');
    stdout.writeln('Scaffolded files exist but dependencies are incomplete.');
    stdout.writeln('');
    stdout.writeln('Next steps:');
    stdout.writeln('  • flux_wireframe           - Add missing dependencies');
    stdout.writeln('  • flutter pub get          - Install dependencies');
  } else {
    stdout.writeln('  ○ Not a FLUX Wireframe project');
    stdout.writeln('═══════════════════════════════════════════════════════');
    stdout.writeln('');
    stdout.writeln('This is a regular Flutter project.');
    stdout.writeln('');
    stdout.writeln('Get started:');
    stdout.writeln('  • flux_wireframe           - Scaffold with FLUX');
    stdout.writeln('  • flux_wireframe_doctor    - Check environment');
  }

  stdout.writeln('');
}