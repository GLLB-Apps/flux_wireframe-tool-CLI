import 'dart:io';

void main(List<String> arguments) {
  print('🎨 FLUX Wireframe CLI Tool');
  print('========================');
  print('');
  print('Available commands:');
  print('  flux_wireframe       - Interactive menu');
  print('  flux_wireframe_tour  - Project tour');
  print('  flux_wireframe_status - Check status');
  print('  flux_wireframe_doctor - Run diagnostics');
  print('  flux_wireframe_clear  - Clear project data');
  print('');
  
  // Din CLI-logik här
  showInteractiveMenu();
}

void showInteractiveMenu() {
  print('Select an option:');
  print('1. Start tour');
  print('2. Check status');
  print('3. Run doctor');
  print('4. Clear data');
  print('0. Exit');
  print('');
  stdout.write('Enter choice: ');
  
  var choice = stdin.readLineSync();
  
  switch (choice) {
    case '1':
      print('Starting tour...');
      break;
    case '2':
      print('Checking status...');
      break;
    case '3':
      print('Running doctor...');
      break;
    case '4':
      print('Clearing data...');
      break;
    case '0':
      print('Goodbye!');
      exit(0);
    default:
      print('Invalid choice');
  }
}