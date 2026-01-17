# FLUX_WIREFRAME – Starter Tour

A powerful CLI tool for scaffolding Flutter applications with a beautiful wireframe aesthetic. Get a production-ready app with dark mode, custom layouts, and professional theming in seconds.

## ✨ Features

- 🎨 **4 Professional Layouts**: Sidebar, Bottom Navigation, Grid, and Split View
- 🌓 **Dark Mode**: Built-in theme switching with persistent state
- 🔤 **IBM Plex Mono**: Optional Google Fonts integration for that authentic wireframe look
- 🎯 **Icon Sets**: Choose between Material Icons or Remix Icons
- 📱 **Responsive Design**: Adaptive layouts with smart breakpoints
- 🔒 **Safe**: Automatic backups of existing files
- ⚡ **Fast**: Complete project setup in ~30 seconds

## 🚀 Quick Start

### Prerequisites

- Flutter SDK (latest stable)
- Dart SDK
- A Flutter project initialized with `flutter create`

### Installation

1. Copy `tour.dart` to your Flutter project root
2. Run the tool:
```bash
dart run tour.dart
```

### Interactive Setup

The tool will guide you through configuration:
```
FLUX_WIREFRAME – Starter Tour
This will overwrite lib/main.dart and create screens.

Choose layout:
  a) Sidebar
  b) Bottom navbar
  c) Grid
  d) Split view
Select (a/b/c/d): b

Icon set:
  m) Material (default)
  r) Remix
Select (m/r): m

Use monospace typography? [Y/n]: Y

App title (shown in AppBar) [FLUX_WIREFRAME]: MyApp

Theme storageKey (SharedPreferences) [myapp_isDarkMode]: 

Selected layout: bottomNav
Icon set: material
Monospace: ON
Title: MyApp
storageKey: myapp_isDarkMode

Proceed and overwrite files? [Y/n]: Y
```

### Finish Setup
```bash
flutter pub get
flutter run
```

## 📐 Layouts

### Sidebar
Desktop-first layout with NavigationRail and multiple content pages.
- **Best for**: Admin dashboards, content management systems
- **Breakpoint**: Always displays sidebar

### Bottom Navigation
Mobile-friendly layout with BottomNavigationBar.
- **Best for**: Mobile apps, social media, e-commerce
- **Features**: IndexedStack for state preservation

### Grid
Responsive grid layout with automatic column adjustment.
- **Best for**: Portfolios, product catalogs, image galleries
- **Breakpoints**: 
  - 1100px+ → 4 columns
  - 800px+ → 3 columns
  - 520px+ → 2 columns
  - <520px → 1 column

### Split View
Master-detail layout with adaptive behavior.
- **Best for**: Email clients, file browsers, settings panels
- **Breakpoint**: 840px
  - Wide screens: Side-by-side view
  - Narrow screens: Navigation with detail push

## 🎨 Theming

### WireframeTheme Package

The tool uses the `wireframe_theme_flutter` package which provides:

- Monochromatic color scheme (black/white)
- 2px borders on all components
- Zero elevation/shadows
- Sharp corners (no border radius)
- Clean, minimal aesthetic

### Dark Mode

Toggle between light and dark themes with persistent state:
```dart
IconButton(
  icon: Icon(theme.isDarkMode ? AppIcons.lightMode : AppIcons.darkMode),
  onPressed: () => context.read<ThemeController>().toggle(),
)
```

State persists across app restarts via SharedPreferences.

### IBM Plex Mono (Optional)

When enabled, applies Google Fonts IBM Plex Mono globally:
```dart
ThemeData _applyMonospace(ThemeData t) {
  return t.copyWith(
    textTheme: GoogleFonts.ibmPlexMonoTextTheme(t.textTheme),
    primaryTextTheme: GoogleFonts.ibmPlexMonoTextTheme(t.primaryTextTheme),
  );
}
```

## 📦 Generated Files
```
lib/
├── main.dart                    # App entry point with theme setup
├── icons/
│   └── app_icons.dart          # Icon abstraction layer
└── screens/
    ├── home_screen.dart        # Layout-specific home screen
    └── detail_screen.dart      # (Split view only)
```

### Backup System

Before overwriting, the tool creates `.bak` files:
```
lib/main.dart      → lib/main.dart.bak
lib/screens/...    → lib/screens/....bak
```

Restore with: `mv lib/main.dart.bak lib/main.dart`

## 🔧 Dependencies

### Automatically Added

The tool patches `pubspec.yaml` with required dependencies:
```yaml
dependencies:
  flutter:
    sdk: flutter
  
  provider: ^6.0.0
  shared_preferences: ^2.0.0
  wireframe_theme_flutter: ^1.0.0
  
  # Optional (if Remix icons selected)
  remixicon: ^1.0.0
  
  # Optional (if monospace selected)
  google_fonts: ^6.2.1

flutter:
  uses-material-design: true
```

## 🎯 Icon Sets

### Material Icons (Default)
```dart
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

### Remix Icons
```dart
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

## 🏗️ Project Structure

### main.dart
```dart
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  final theme = ThemeController(storageKey: 'app_isDarkMode');
  await theme.init();
  
  runApp(
    ChangeNotifierProvider.value(
      value: theme,
      child: const App(),
    ),
  );
}
```

### State Management
Uses Provider for theme state management:
```dart
// Access theme state
final theme = context.watch<ThemeController>();

// Toggle dark mode
context.read<ThemeController>().toggle();

// Check current mode
if (theme.isDarkMode) { ... }
```

## 🎨 Customization

### Changing Colors
Edit `wireframe_theme_flutter` package or override in your app:
```dart
ThemeData customTheme = WireframeTheme.getTheme(false).copyWith(
  primaryColor: Colors.blue,
  scaffoldBackgroundColor: Color(0xFFF5F5F5),
);
```

### Adding More Layouts
Add new enum values and templates:
```dart
enum LayoutChoice { sidebar, bottomNav, grid, splitView, custom }

String _customHomeTemplate({required String appTitle}) {
  return '''
  // Your custom layout here
  ''';
}
```

### Custom Icons
Extend `AppIcons` class:
```dart
class AppIcons {
  // ... existing icons
  static const IconData custom = Icons.star;
}
```

## 📱 Responsive Breakpoints

| Layout | Breakpoint | Behavior |
|--------|-----------|----------|
| Sidebar | N/A | Always shows sidebar |
| Bottom Nav | N/A | Always shows bottom nav |
| Grid | 1100px | 4 → 3 → 2 → 1 columns |
| Split View | 840px | Side-by-side ↔ Stack |

## 🐛 Troubleshooting

### "Uses-material-design not found"
Run: `flutter pub get`

### "Package not found"
Ensure dependencies are added to `pubspec.yaml`:
```bash
flutter pub add provider shared_preferences wireframe_theme_flutter
```

### Font not applying
1. Check `google_fonts` is in `pubspec.yaml`
2. Run `flutter clean && flutter pub get`
3. Restart app completely

### Icons showing as squares
1. Verify `uses-material-design: true` in `pubspec.yaml`
2. For Remix: Verify `remixicon` dependency
3. Run `flutter pub get`

## 🔄 Version History

### v1.0.0 (Current)
- ✅ Initial release
- ✅ 4 layout options
- ✅ Dark mode support
- ✅ IBM Plex Mono integration
- ✅ Material & Remix icon sets
- ✅ Automatic pubspec patching
- ✅ File backup system

## 📄 License

MIT License - feel free to use in personal and commercial projects.

## 🤝 Contributing

Contributions welcome! Areas for improvement:

- [ ] More layout options
- [ ] Additional font choices
- [ ] Color scheme variants
- [ ] Animation presets
- [ ] CLI flags for non-interactive mode
- [ ] Testing suite

## 💡 Tips

1. **Start Fresh**: Run on a new `flutter create` project for best results
2. **Git First**: Commit before running to easily revert changes
3. **Experiment**: Try different layouts and themes - backups protect you
4. **Customize**: Use generated code as a starting point, not final product
5. **Mobile First**: Bottom nav layout is most mobile-friendly

## 🔗 Related Projects

- [wireframe_theme_flutter](https://github.com/GLLB-Apps/wireframe_theme_flutter) - The theme package
- [Flutter](https://flutter.dev) - The framework
- [Material Design](https://m3.material.io) - Design system
- [Remix Icon](https://remixicon.com) - Icon library

## 📞 Support

Found a bug? Have a feature request?

- Open an issue on GitHub
- Contribute a pull request
- Share your projects built with this tool!

---

**Built with ❤️ for the Flutter community**

*Scaffold smarter, build faster.* 🚀