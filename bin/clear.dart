import 'dart:io';

void main(List<String> args) {
  stdout.writeln('═══════════════════════════════════════════════════════');
  stdout.writeln('  FLUX Wireframe CLI - Clear');
  stdout.writeln('  Reset to clean Flutter project');
  stdout.writeln('═══════════════════════════════════════════════════════');
  stdout.writeln('');
  stdout.writeln('⚠️  WARNING: This will:');
  stdout.writeln('   • Delete lib/main.dart');
  stdout.writeln('   • Delete lib/screens/ (entire directory)');
  stdout.writeln('   • Delete lib/icons/ (entire directory)');
  stdout.writeln('   • Delete all .bak backup files');
  stdout.writeln('   • Run "flutter create . --overwrite"');
  stdout.writeln('');
  stdout.writeln('This action cannot be undone unless you have git commits!');
  stdout.writeln('');

  final confirm = _askYesNo('Are you sure you want to clear everything?', defaultYes: false);
  if (!confirm) {
    stdout.writeln('Cancelled.');
    exit(0);
  }

  final doubleConfirm = _askYesNo('Really delete all generated files? (last chance!)', defaultYes: false);
  if (!doubleConfirm) {
    stdout.writeln('Cancelled.');
    exit(0);
  }

  stdout.writeln('');
  stdout.writeln('Cleaning up...');
  
  int deletedFiles = 0;
  int deletedDirs = 0;

  // Delete main.dart
  final mainDart = File('lib/main.dart');
  if (mainDart.existsSync()) {
    mainDart.deleteSync();
    stdout.writeln('✓ Deleted: lib/main.dart');
    deletedFiles++;
  }

  // Delete lib/screens directory
  final screensDir = Directory('lib/screens');
  if (screensDir.existsSync()) {
    screensDir.deleteSync(recursive: true);
    stdout.writeln('✓ Deleted: lib/screens/');
    deletedDirs++;
  }

  // Delete lib/icons directory
  final iconsDir = Directory('lib/icons');
  if (iconsDir.existsSync()) {
    iconsDir.deleteSync(recursive: true);
    stdout.writeln('✓ Deleted: lib/icons/');
    deletedDirs++;
  }

  // Delete all .bak files
  final libDir = Directory('lib');
  if (libDir.existsSync()) {
    final bakFiles = libDir.listSync(recursive: true)
        .whereType<File>()
        .where((f) => f.path.endsWith('.bak'));
    
    for (final bakFile in bakFiles) {
      bakFile.deleteSync();
      stdout.writeln('✓ Deleted backup: ${bakFile.path}');
      deletedFiles++;
    }
  }

  stdout.writeln('');
  stdout.writeln('Running "flutter create . --overwrite"...');
  stdout.writeln('');

  // Run flutter create
  final result = Process.runSync(
    'flutter',
    ['create', '.', '--overwrite'],
    runInShell: true,
  );

  if (result.exitCode == 0) {
    stdout.writeln('');
    stdout.writeln('═══════════════════════════════════════════════════════');
    stdout.writeln('  ✅ Reset complete!');
    stdout.writeln('═══════════════════════════════════════════════════════');
    stdout.writeln('');
    stdout.writeln('Summary:');
    stdout.writeln('  • Files deleted: $deletedFiles');
    stdout.writeln('  • Directories deleted: $deletedDirs');
    stdout.writeln('  • Clean Flutter project created');
    stdout.writeln('');
    stdout.writeln('Your project is now a fresh Flutter template.');
    stdout.writeln('');
    stdout.writeln('Next steps:');
    stdout.writeln('  1. flutter pub get    (if needed)');
    stdout.writeln('  2. flutter run');
    stdout.writeln('');
    stdout.writeln('Or run "flux_wireframe" to scaffold with wireframe theme again.');
    stdout.writeln('');
  } else {
    stdout.writeln('');
    stdout.writeln('⚠️  Warning: flutter create failed');
    stdout.writeln('');
    stdout.writeln('Error output:');
    stdout.writeln(result.stderr);
    stdout.writeln('');
    stdout.writeln('Files were deleted, but you may need to manually run:');
    stdout.writeln('  flutter create . --overwrite');
    stdout.writeln('');
    exit(1);
  }
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