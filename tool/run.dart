import 'dart:io';

void main(List<String> args) {
  // Om argument finns, kör direkt det kommandot
  if (args.isNotEmpty) {
    _runCommand(args.first);
    return;
  }

  // Annars visa meny
  _showMenu();
}

void _showMenu() {
  while (true) {
    stdout.writeln('');
    stdout.writeln('═══════════════════════════════════════════════════════');
    stdout.writeln('  FLUX Wireframe CLI');
    stdout.writeln('  Flutter UI Experience - Wireframe');
    stdout.writeln('═══════════════════════════════════════════════════════');
    stdout.writeln('');
    stdout.writeln('Available commands:');
    stdout.writeln('');
    stdout.writeln('  1) tour       - Interactive project setup wizard');
    stdout.writeln('  2) status     - Show project status');
    stdout.writeln('  3) doctor     - Check environment health');
    stdout.writeln('  4) clear      - Reset to clean Flutter project');
    stdout.writeln('');
    stdout.writeln('  0) exit       - Exit FLUX CLI');
    stdout.writeln('');
    stdout.write('Select option (0-4): ');

    final input = stdin.readLineSync()?.trim();

    switch (input) {
      case '1':
      case 'tour':
        _runCommand('tour');
        break;
      case '2':
      case 'status':
        _runCommand('status');
        break;
      case '3':
      case 'doctor':
        _runCommand('doctor');
        break;
      case '4':
      case 'clear':
        _runCommand('clear');
        break;
      case '0':
      case 'exit':
      case 'quit':
      case 'q':
        stdout.writeln('');
        stdout.writeln('Goodbye! 👋');
        stdout.writeln('');
        exit(0);
      default:
        stdout.writeln('');
        stdout.writeln('⚠️  Invalid option. Please select 0-4.');
        continue;
    }

    // Efter kommando, fråga om användaren vill fortsätta
    stdout.writeln('');
    stdout.write('Return to menu? (Y/n): ');
    final cont = stdin.readLineSync()?.trim().toLowerCase();
    if (cont == 'n' || cont == 'no') {
      stdout.writeln('');
      stdout.writeln('Goodbye! 👋');
      stdout.writeln('');
      exit(0);
    }
  }
}

void _runCommand(String command) {
  stdout.writeln('');
  
  // Find the bin directory
  final scriptDir = Platform.script.toFilePath();
  final binDir = File(scriptDir).parent.path;
  
  String scriptPath;
  switch (command) {
    case 'tour':
      scriptPath = '$binDir${Platform.pathSeparator}tour.dart';
      break;
    case 'status':
      scriptPath = '$binDir${Platform.pathSeparator}status.dart';
      break;
    case 'doctor':
      scriptPath = '$binDir${Platform.pathSeparator}doctor.dart';
      break;
    case 'clear':
      scriptPath = '$binDir${Platform.pathSeparator}clear.dart';
      break;
    default:
      stdout.writeln('Unknown command: $command');
      stdout.writeln('');
      stdout.writeln('Available: tour, status, doctor, clear');
      return;
  }

  // Check if script exists
  if (!File(scriptPath).existsSync()) {
    stdout.writeln('Error: Script not found: $scriptPath');
    stdout.writeln('');
    return;
  }

  // Run the script
  final result = Process.runSync(
    'dart',
    [scriptPath],
    runInShell: true,
  );
  
  stdout.write(result.stdout);
  if (result.exitCode != 0) {
    stderr.write(result.stderr);
  }
}