import 'dart:io';

void main(List<String> args) {
  stdout.writeln('═══════════════════════════════════════════════════════');
  stdout.writeln('  FLUX Wireframe CLI - Doctor');
  stdout.writeln('  Checking your environment');
  stdout.writeln('═══════════════════════════════════════════════════════');
  stdout.writeln('');

  bool allGood = true;

  // Check Flutter
  stdout.write('Checking Flutter... ');
  final flutterResult = Process.runSync('flutter', ['--version'], runInShell: true);
  if (flutterResult.exitCode == 0) {
    final version = flutterResult.stdout.toString().split('\n').first;
    stdout.writeln('✓');
    stdout.writeln('  $version');
  } else {
    stdout.writeln('✗ Flutter not found');
    allGood = false;
  }

  stdout.writeln('');

  // Check Dart
  stdout.write('Checking Dart... ');
  final dartResult = Process.runSync('dart', ['--version'], runInShell: true);
  if (dartResult.exitCode == 0) {
    final version = dartResult.stdout.toString().trim();
    stdout.writeln('✓');
    stdout.writeln('  $version');
  } else {
    stdout.writeln('✗ Dart not found');
    allGood = false;
  }

  stdout.writeln('');

  // Check if in Flutter project
  stdout.write('Checking Flutter project... ');
  final pubspecFile = File('pubspec.yaml');
  if (pubspecFile.existsSync()) {
    final content = pubspecFile.readAsStringSync();
    if (content.contains('flutter:')) {
      stdout.writeln('✓');
      
      // Check for project name
      final nameMatch = RegExp(r'^name:\s*(.+)$', multiLine: true).firstMatch(content);
      if (nameMatch != null) {
        stdout.writeln('  Project: ${nameMatch.group(1)}');
      }
    } else {
      stdout.writeln('✗ Not a Flutter project');
      stdout.writeln('  pubspec.yaml exists but missing flutter: section');
      allGood = false;
    }
  } else {
    stdout.writeln('✗ pubspec.yaml not found');
    stdout.writeln('  Run this command from a Flutter project directory');
    allGood = false;
  }

  stdout.writeln('');

  // Check for wireframe_theme
  stdout.write('Checking wireframe_theme... ');
  if (pubspecFile.existsSync()) {
    final content = pubspecFile.readAsStringSync();
    if (content.contains(RegExp(r'^\s*wireframe_theme\s*:', multiLine: true))) {
      stdout.writeln('✓ installed');
    } else {
      stdout.writeln('○ not installed');
      stdout.writeln('  Run "flux_wireframe" to add it');
    }
  } else {
    stdout.writeln('○ skipped (no pubspec.yaml)');
  }

  stdout.writeln('');

  // Check for provider
  stdout.write('Checking provider... ');
  if (pubspecFile.existsSync()) {
    final content = pubspecFile.readAsStringSync();
    if (content.contains(RegExp(r'^\s*provider\s*:', multiLine: true))) {
      stdout.writeln('✓ installed');
    } else {
      stdout.writeln('○ not installed');
      stdout.writeln('  Run "flux_wireframe" to add it');
    }
  } else {
    stdout.writeln('○ skipped');
  }

  stdout.writeln('');

  // Check for shared_preferences
  stdout.write('Checking shared_preferences... ');
  if (pubspecFile.existsSync()) {
    final content = pubspecFile.readAsStringSync();
    if (content.contains(RegExp(r'^\s*shared_preferences\s*:', multiLine: true))) {
      stdout.writeln('✓ installed');
    } else {
      stdout.writeln('○ not installed');
      stdout.writeln('  Run "flux_wireframe" to add it');
    }
  } else {
    stdout.writeln('○ skipped');
  }

  stdout.writeln('');

  // Check for FLUX generated files
  stdout.write('Checking FLUX files... ');
  final mainDart = File('lib/main.dart');
  final screensDir = Directory('lib/screens');
  final iconsDir = Directory('lib/icons');

  final hasMain = mainDart.existsSync();
  final hasScreens = screensDir.existsSync();
  final hasIcons = iconsDir.existsSync();

  if (hasMain && hasScreens && hasIcons) {
    stdout.writeln('✓ found');
    stdout.writeln('  • lib/main.dart');
    stdout.writeln('  • lib/screens/');
    stdout.writeln('  • lib/icons/');
  } else if (!hasMain && !hasScreens && !hasIcons) {
    stdout.writeln('○ not generated');
    stdout.writeln('  Run "flux_wireframe" to scaffold your app');
  } else {
    stdout.writeln('⚠ partial');
    if (hasMain) stdout.writeln('  ✓ lib/main.dart');
    if (!hasMain) stdout.writeln('  ✗ lib/main.dart missing');
    if (hasScreens) stdout.writeln('  ✓ lib/screens/');
    if (!hasScreens) stdout.writeln('  ✗ lib/screens/ missing');
    if (hasIcons) stdout.writeln('  ✓ lib/icons/');
    if (!hasIcons) stdout.writeln('  ✗ lib/icons/ missing');
  }

  stdout.writeln('');
  stdout.writeln('═══════════════════════════════════════════════════════');
  
  if (allGood) {
    stdout.writeln('  ✅ Everything looks good!');
    stdout.writeln('═══════════════════════════════════════════════════════');
    stdout.writeln('');
    stdout.writeln('Ready to use FLUX Wireframe CLI:');
    stdout.writeln('  • flux_wireframe         - Scaffold your app');
    stdout.writeln('  • flux_wireframe_clear   - Reset to clean Flutter');
    stdout.writeln('');
  } else {
    stdout.writeln('  ⚠️  Issues found');
    stdout.writeln('═══════════════════════════════════════════════════════');
    stdout.writeln('');
    stdout.writeln('Please fix the issues above before using FLUX Wireframe CLI.');
    stdout.writeln('');
    exit(1);
  }
}