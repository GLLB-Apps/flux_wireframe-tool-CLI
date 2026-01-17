# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [0.1.0] - 2025-01-18

### Added
- Initial release of FLUX Wireframe CLI Tool
- Interactive project setup wizard (`flux_wireframe_tour`)
- Multiple layout options:
  - Sidebar navigation
  - Bottom navigation bar
  - Grid layout
  - Split view (master-detail)
- Icon set selection (Material Icons or Remix Icons)
- Automatic dependency management:
  - `wireframe_theme` integration
  - `provider` for state management
  - `shared_preferences` for theme persistence
- Project management commands:
  - `flux_wireframe` - Main interactive menu
  - `flux_wireframe_tour` - Setup wizard
  - `flux_wireframe_status` - Project status checker
  - `flux_wireframe_doctor` - Environment diagnostics
  - `flux_wireframe_clear` - Reset to clean Flutter project
- Automatic backup of overwritten files (.bak)
- Exit functionality at any prompt (type "0")
- Dark/light theme toggle in generated apps
- IBM Plex Mono typography via wireframe_theme

### Features
- Generates complete Flutter app structure
- Creates custom icon abstractions
- Configurable app title and theme storage key
- Responsive layouts with breakpoints
- Material Design compliance
- iOS compatibility with Cupertino icons

[0.1.0]: https://github.com/GLLB-Apps/flux_wireframe-tool-CLI/releases/tag/v0.1.0