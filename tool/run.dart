import 'dart:io';
import 'tour.dart' as tour;
import 'status.dart' as status;
import 'doctor.dart' as doctor;
import 'clear.dart' as clear;

void main(List<String> args) {
  if (args.isNotEmpty) {
    _runCommand(args.first);
    return;
  }
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
    stdout.writeln('─────────────────────────────────────────────────────');
    stdout.writeln('');
    stdout.write('Choose an option:\n');
    stdout.writeln('  1) Return to menu');
    stdout.writeln('  0) Exit');
    stdout.write('\nSelect (0-1): ');
    
    final cont = stdin.readLineSync()?.trim();
    if (cont == '0' || cont == 'exit' || cont == 'quit' || cont == 'q') {
      stdout.writeln('');
      stdout.writeln('Goodbye! 👋');
      stdout.writeln('');
      exit(0);
    }
    // Annars fortsätt till menyn
  }
}

void _runCommand(String command) {
  stdout.writeln('');
  
  try {
    switch (command) {
      case 'tour':
        tour.main([]);
        break;
      case 'status':
        status.main([]);
        break;
      case 'doctor':
        doctor.main([]);
        break;
      case 'clear':
        clear.main([]);
        break;
      default:
        stdout.writeln('Unknown command: $command');
        stdout.writeln('Available: tour, status, doctor, clear');
    }
  } catch (e) {
    stdout.writeln('');
    stdout.writeln('⚠️  Error running command: $e');
  }
}