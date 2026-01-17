# FLUX Wireframe CLI

**Flutter UI Experience - Wireframe**

A powerful CLI tool for scaffolding Flutter applications with a beautiful wireframe aesthetic. Get a production-ready app with dark mode, custom layouts, and professional theming in seconds.

[![pub package](https://img.shields.io/pub/v/flux_wireframe_theme_cli.svg)](https://pub.dev/packages/flux_wireframe_theme_cli)

## ✨ Features

- 🎯 **Interactive Menu** - Easy-to-use guided interface for all commands
- 🎨 **4 Professional Layouts** - Sidebar, Bottom Navigation, Grid, and Split View
- 🌓 **Dark Mode** - Built-in theme switching with persistent state
- 🔤 **IBM Plex Mono** - Professional monospace typography via Google Fonts
- 🎨 **Icon Sets** - Choose between Material Icons or Remix Icons
- 📱 **Responsive Design** - Adaptive layouts with smart breakpoints
- 🔒 **Safe** - Automatic backups of existing files
- ⚡ **Fast** - Complete project setup in ~30 seconds
- 🏥 **Health Check** - Built-in doctor and status commands
- 🧹 **Clean Reset** - One command to reset to clean Flutter project

## 🚀 Quick Start

### Installation
```bash
dart pub global activate flux_wireframe_theme_cli
```

### Usage
```bash
# Interactive menu (recommended)
flux_wireframe
```

**Menu options:**
```
═══════════════════════════════════════════════════════
  FLUX Wireframe CLI
  Flutter UI Experience - Wireframe
═══════════════════════════════════════════════════════

Available commands:

  1) tour       - Interactive project setup wizard
  2) status     - Show project status
  3) doctor     - Check environment health
  4) clear      - Reset to clean Flutter project

  0) exit       - Exit FLUX CLI

Select option (0-4):
```

### Quick Commands
```bash
# Run commands directly
flux_wireframe tour        # Interactive setup wizard
flux_wireframe status      # Project status
flux_wireframe doctor      # Environment health check
flux_wireframe clear       # Reset project
```

### Individual Commands
```bash
flux_wireframe_tour        # Interactive setup wizard
flux_wireframe_status      # Project status
flux_wireframe_doctor      # Environment check
flux_wireframe_clear       # Reset project
```

## 📐 Available Commands

### 🎯 Tour - Interactive Setup Wizard

The main scaffolding wizard that guides you through project setup:
```bash
flux_wireframe tour
```

**Interactive prompts:**
```
Choose layout:
  a) Sidebar
  b) Bottom navbar
  c) Grid
  d) Split view
Select (a/b/c/d): 

Icon set:
  m) Material (default)
  r) Remix
Select (m/r): 

App title (shown in AppBar) [FLUX_WIREFRAME]: 

Theme storageKey (SharedPreferences) [myapp_isDarkMode]: 
```

**What it does:**
- ✅ Creates `lib/main.dart` with theme setup
- ✅ Generates `lib/screens/` with chosen layout
- ✅ Creates `lib/icons/app_icons.dart` abstraction
- ✅ Adds required dependencies to `pubspec.yaml`
- ✅ Backs up existing files as `.bak`
- ✅ Enables Material Design icons

### 📊 Status - Project Overview

Shows comprehensive project status:
```bash
flux_wireframe status
```

**Example output:**
```
📦 Project: my_awesome_app
📌 Version: 1.0.0+1

Dependencies:
  ✓ wireframe_theme
  ✓ provider
  ✓ shared_preferences
  ○ remixicon (optional)
  ✓ cupertino_icons (optional)

Generated files:
  ✓ lib/main.dart
  ✓ lib/screens/
     └─ 1 screen(s)
        • home_screen.dart
  ✓ lib/icons/
     └─ 1 icon file(s)

═══════════════════════════════════════════════════════
  ✅ FLUX Wireframe project - fully scaffolded
═══════════════════════════════════════════════════════
```

### 🏥 Doctor - Environment Health Check

Diagnoses your development environment:
```bash
flux_wireframe doctor
```

**Checks:**
- ✓ Flutter installation and version
- ✓ Dart SDK availability
- ✓ Valid Flutter project
- ✓ Required dependencies
- ✓ FLUX generated files
- ✓ Material Design icons setup

**Example output:**
```
Checking Flutter... ✓
  Flutter 3.16.0 • channel stable

Checking Dart... ✓
  Dart 3.2.0 (stable)

Checking Flutter project... ✓
  Project: my_app

Checking wireframe_theme... ✓ installed

═══════════════════════════════════════════════════════
  ✅ Everything looks good!
═══════════════════════════════════════════════════════
```

### 🧹 Clear - Reset Project

Resets project to clean Flutter state:
```bash
flux_wireframe clear
```

**What it does:**
- ⚠️ Deletes `lib/main.dart`
- ⚠️ Removes `lib/screens/` directory
- ⚠️ Removes `lib/icons/` directory
- ⚠️ Deletes all `.bak` backup files
- ✅ Runs `flutter create . --overwrite` automatically
- ✅ Creates fresh Flutter counter app

**⚠️ Warning:** This action cannot be undone! Commit to git first.

## 📐 Layouts

### Sidebar Navigation
Desktop-first layout with NavigationRail.

**Best for:** Admin dashboards, content management systems, desktop apps

**Features:**
- Persistent sidebar navigation
- Multiple content pages
- Material NavigationRail component

### Bottom Navigation Bar
Mobile-friendly layout with BottomNavigationBar.

**Best for:** Mobile apps, social media apps, e-commerce

**Features:**
- 3-tab navigation
- IndexedStack for state preservation
- Mobile-optimized touch targets

### Grid Layout
Responsive grid with automatic column adjustment.

**Best for:** Portfolios, product catalogs, image galleries

**Breakpoints:**
- `≥1100px` → 4 columns
- `≥800px` → 3 columns
- `≥520px` → 2 columns
- `<520px` → 1 column

### Split View (Master-Detail)
Adaptive layout with master-detail pattern.

**Best for:** Email clients, file browsers, settings panels

**Features:**
- Side-by-side view on wide screens (≥840px)
- Stack navigation on narrow screens
- 25 sample items included

## 🎨 Theming

### Wireframe Theme Package

Uses [`wireframe_theme`](https://pub.dev/packages/wireframe_theme) which provides:

- ✨ Monochromatic color scheme (black/white)
- 🔤 IBM Plex Mono typography
- 📏 2px borders on all components
- 🚫 Zero elevation/shadows
- ⬜ Sharp corners (no border radius)
- 🎯 Clean, minimal aesthetic

### Dark Mode Support

Built-in theme switching with persistent storage:
```dart
// Toggle dark mode
context.read().toggle();

// Check current mode
final isDark = context.watch().isDarkMode;

// Access colors
final foreground = WireframeTheme.getForeground(isDark);
final background = WireframeTheme.getBackground(isDark);
```

**Persistence:** Theme preference is saved using SharedPreferences and persists across app restarts.

## 📦 Generated Project Structure
```
lib/
├── main.dart                    # App entry point
│   ├── ThemeController setup
│   ├── Provider configuration
│   └── MaterialApp with themes
│
├── icons/
│   └── app_icons.dart          # Icon abstraction layer
│       ├── Material OR Remix icons
│       └── Consistent API
│
└── screens/
    ├── home_screen.dart        # Main screen (layout-specific)
    └── detail_screen.dart      # Detail screen (split view only)
```

### Backup System

Before overwriting, automatic backups are created:
```
lib/main.dart           → lib/main.dart.bak
lib/screens/foo.dart    → lib/screens/foo.dart.bak
```

**Restore:** `mv lib/main.dart.bak lib/main.dart`

## 🔧 Dependencies

### Automatically Added to pubspec.yaml
```yaml
dependencies:
  flutter:
    sdk: flutter
  
  # Wireframe theme from pub.dev
  wireframe_theme: ^1.0.4
  
  # State management
  provider: ^6.0.0
  
  # Persistent storage
  shared_preferences: ^2.0.0
  
  # iOS icons
  cupertino_icons: ^1.0.8
  
  # Remix icons (if selected)
  remixicon: ^1.0.0

flutter:
  uses-material-design: true
```

## 🎯 Icon Sets

### Material Icons (Default)
```dart
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
```

### Remix Icons (Optional)
```dart
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
```

## 🏗️ Generated Code Structure

### main.dart
```dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:wireframe_theme/wireframe_theme.dart';

import 'screens/home_screen.dart';

Future main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final theme = ThemeController(storageKey: 'myapp_isDarkMode');
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
    final theme = context.watch();

    return MaterialApp(
      title: 'MyApp',
      debugShowCheckedModeBanner: false,
      theme: WireframeTheme.getTheme(false),
      darkTheme: WireframeTheme.getTheme(true),
      themeMode: theme.isDarkMode ? ThemeMode.dark : ThemeMode.light,
      home: const HomeScreen(),
    );
  }
}
```

### State Management with Provider
```dart
// Access theme state
final theme = context.watch();

// Toggle dark mode
context.read().toggle();

// Set mode explicitly
context.read().setDarkMode(true);
```

## 📱 Responsive Breakpoints

| Layout | Breakpoint | Behavior |
|--------|-----------|----------|
| **Sidebar** | N/A | Always shows sidebar |
| **Bottom Nav** | N/A | Always shows bottom bar |
| **Grid** | 1100px / 800px / 520px | 4 → 3 → 2 → 1 columns |
| **Split View** | 840px | Side-by-side ↔ Stack navigation |

## 🔄 Recommended Workflow
```bash
# 1. Create Flutter project
flutter create my_awesome_app
cd my_awesome_app

# 2. Install FLUX Wireframe CLI
dart pub global activate flux_wireframe_theme_cli

# 3. Check environment (optional)
flux_wireframe doctor

# 4. Run interactive setup
flux_wireframe tour
# OR use the menu
flux_wireframe

# 5. Install dependencies
flutter pub get

# 6. Run your app
flutter run

# 7. Check status anytime
flux_wireframe status
```

## 🐛 Troubleshooting

### Icons showing as squares

**Solution:**
```bash
flutter pub get
```

Verify `pubspec.yaml` has:
```yaml
flutter:
  uses-material-design: true
```

### "Package not found"

**Solution:**
The CLI automatically adds dependencies. If issues persist:
```bash
flutter clean
flutter pub get
```

### Environment issues

**Solution:**
```bash
flux_wireframe doctor
```

This will diagnose:
- ✓ Flutter installation
- ✓ Dart SDK
- ✓ Project validity
- ✓ Dependencies

### Backup files cluttering project

**Solution:**
Delete `.bak` files manually:
```bash
# Unix/Mac
find lib -name "*.bak" -delete

# Windows
del /s lib\*.bak
```

## 💡 Pro Tips

1. **🔄 Start Fresh** - Run on a new `flutter create` project for best results
2. **📝 Git First** - Commit before running to easily revert changes
3. **🏥 Use Doctor** - Run `flux_wireframe doctor` to check environment
4. **📊 Check Status** - Use `flux_wireframe status` for project overview
5. **🎨 Experiment** - Try different layouts - backups protect you
6. **📱 Mobile First** - Bottom nav is most mobile-friendly
7. **🎯 Menu Mode** - Use `flux_wireframe` (no args) for guided experience

## 🔗 Links

- 📦 [wireframe_theme package](https://pub.dev/packages/wireframe_theme) - The theme package
- 🛠️ [GitHub Repository](https://github.com/GLLB-Apps/flux_wireframe-tool-CLI) - Source code
- 🐛 [Issue Tracker](https://github.com/GLLB-Apps/flux_wireframe-tool-CLI/issues) - Report bugs
- 📚 [Flutter Docs](https://flutter.dev) - Flutter framework
- 🎨 [Material Design](https://m3.material.io) - Design system
- 🎯 [Remix Icon](https://remixicon.com) - Icon library

## 📄 License

MIT License - see [LICENSE](LICENSE) file for details.

## 🤝 Contributing

Contributions are welcome! Areas for improvement:

- [ ] More layout options (drawer, tabs, etc.)
- [ ] Additional theme variants
- [ ] Color scheme customization
- [ ] Animation presets
- [ ] Custom component library
- [ ] Testing suite
- [ ] Video tutorials

**How to contribute:**
1. Fork the repository
2. Create a feature branch
3. Make your changes
4. Submit a pull request

## 📞 Support

Need help?

- 🐛 [Report a bug](https://github.com/GLLB-Apps/flux_wireframe-tool-CLI/issues)
- 💬 [Start a discussion](https://github.com/GLLB-Apps/flux_wireframe-tool-CLI/discussions)
- 📦 [View on pub.dev](https://pub.dev/packages/flux_wireframe_theme_cli)
- ⭐ [Star on GitHub](https://github.com/GLLB-Apps/flux_wireframe-tool-CLI)

## 🎯 Philosophy

FLUX Wireframe CLI embraces:

- ✨ **Minimalism** - Clean, focused interfaces
- 🎯 **Consistency** - Predictable patterns across layouts
- 📖 **Readability** - Monospace typography for clarity
- 🔧 **Flexibility** - Easy to customize and extend
- ⚡ **Speed** - Get productive in seconds, not hours

---

**Built with ❤️ for the Flutter community**

*Scaffold smarter, build faster.* 🚀

**FLUX** - Flutter UI Experience CLI