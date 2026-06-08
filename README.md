# Country Explorer App

A beautiful, performant, and fully featured Flutter application that acts as a comprehensive guide for countries around the world, integrating REST Countries API, maps, localizations, and comparison tools.

---

## ✨ Features

- **🌐 Live REST Countries API Integration**: Pulls accurate and up-to-date data dynamically. Grouped, parallel endpoint queries are processed concurrently for optimal loading performance.
- **🔍 Smart Search & Filtering**: Fast search-by-name synced instantly to the state. Filter by region (Africa, Americas, Asia, Europe, etc.) or sort by population size, area size, or alphabetically.
- **📊 Country Comparison**: Choose any two countries side-by-side to compare their flags, capitals, regions, populations, area sizes, and timezones.
- **🗺️ Interactive Map View**: Explore coordinates using OpenStreetMap integration (`flutter_map`) with modern custom marker pins.
- **❤️ Favorites System**: Bookmark countries. User favorites are stored locally on-device (`get_storage`) and persisted across app restarts.
- **🎲 Random Country Picker**: Shake up your exploration with a random country card generator.
- **🌐 Azerbaijani & English Localization**: Custom lightweight localizations delegate (`AppLocalizations`) dynamically adapts the user interface to system locales.
- **🔢 Beautiful Number Formatting**: Large numbers like area ($km^2$) and population are beautifully formatted using thousands separators (e.g. `1,234,567`).

---

## 🛠️ Tech Stack & Architecture

- **State Management**: [BLoC / Cubit](https://pub.dev/packages/flutter_bloc) pattern for reactive, clean, and testable state architecture.
- **HTTP client**: [Dio](https://pub.dev/packages/dio) with custom retry policies, base option header configuration, and robust network/server exception parsing.
- **Local Storage**: [GetStorage](https://pub.dev/packages/get_storage) for lightweight and fast key-value persistence.
- **Caching**: [CachedNetworkImage](https://pub.dev/packages/cached_network_image) for lightning-fast flag image rendering and offline cache capabilities.
- **Maps**: [Flutter Map](https://pub.dev/packages/flutter_map) with OpenStreetMap tile provider.
- **Theme**: Premium Material 3 config (`AppTheme`) with a cohesive indigo and red accent palette.
- **Design Patterns**: Adheres strictly to **SOLID** design principles. Parsing logic is isolated from models in `CountryMapper` (SRP violation fixed), screens are modularized (Home screen god-widget refactored), and type checking is strictly safe.

---

## 🚀 Getting Started

### Prerequisites

- Flutter SDK: `^3.11.5` or later.
- Dart SDK: `^3.11.5` or later.

### Installation

1. Clone this repository:
   ```bash
   git clone <repository_url>
   cd country_app
   ```

2. Fetch all dependencies:
   ```bash
   flutter pub get
   ```

3. Run the application locally:
   ```bash
   flutter run
   ```

---

## 📂 Project Structure

```
lib/
├── cubit/
│   ├── country_cubit.dart       # Manages business logic
│   └── country_state.dart       # Defines app state variables
├── l10n/
│   └── app_localizations.dart   # EN/AZ localized string mappings
├── models/
│   ├── country_mapper.dart      # Safe JSON parser (SRP)
│   └── country_model.dart       # Pure country data container
├── screens/
│   ├── compare_screen.dart      # Country comparison page
│   ├── detail_screen.dart       # In-depth country info and map
│   ├── favorites_screen.dart    #persisted bookmarks list
│   └── home_screen.dart         # Main listing dashboard
├── services/
│   ├── api_service.dart         # Handles Dio REST API requests
│   └── storage_service.dart     # Key-value storage manager
├── theme/
│   └── app_theme.dart           # Cohesive design tokens and theme settings
├── utils/
│   └── number_formatter.dart    # Thousands separator utility
└── widgets/
    ├── country_card.dart        # Reusable country item widget
    ├── country_flag.dart        # Reusable cached flag image component
    ├── filter_sort_sheet.dart   # Custom bottom sheet filter/sort
    └── home_search_bar.dart     # Custom search bar component
```
