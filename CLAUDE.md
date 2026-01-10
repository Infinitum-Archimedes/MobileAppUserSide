# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

Student Health Tracker is a Flutter mobile application that helps students manage their health by providing location-based health analysis. The app features:
- Symptom-to-disease prediction via AI chat interface
- Google Maps integration showing health reports in a geographic area
- User authentication via Supabase (email/password, anonymous, Apple Sign In)
- Push notifications support

## Build & Run Commands

```bash
# Install dependencies
flutter pub get

# Run the app (basic)
flutter run

# Run with API keys for full functionality
flutter run --dart-define=GOOGLE_MAPS_KEY=<key> --dart-define=OTHER_VAR=<value>

# Run for web
flutter run -d chrome

# Update splash screen after changing flutter_native_splash settings
dart run flutter_native_splash:create

# Run tests
flutter test

# Analyze code
flutter analyze
```

## Google Maps Web Configuration

For Google Maps to work on web:
1. Get an API key from [Google Cloud Console](https://console.cloud.google.com/)
2. Enable "Maps JavaScript API"
3. Replace `YOUR_GOOGLE_MAPS_API_KEY` in `web/index.html` with your key
4. (Optional) For Advanced Markers: Create a Map ID and add `cloudMapId` to GoogleMap widget in `lib/map_page/map_page.dart`

## Architecture

### Entry Points
- `lib/main.dart` - App entry point, initializes Supabase and local storage, sets up StreamBuilder for dynamic theming

### Core Services (lib/globals/)
- `database.dart` - Supabase client initialization and database helpers
- `auth.dart` / `auth_service.dart` - Authentication methods (email, anonymous, Apple Sign In)
- `account_service.dart` - User profile management
- `notification_service.dart` - Push notification handling
- `stream_signal.dart` - App-wide state signaling via StreamController

### Pages Structure
- `lib/startup/` - Splash, Welcome, Login, Signup pages (auth flow)
- `lib/chat/chat.dart` - Health assistant chatbot (calls external API at symptom2disease.onrender.com)
- `lib/map_page/map_page.dart` - Google Maps with health report markers
- `lib/account/` - User profile and avatar management
- `lib/settings/settings.dart` - App settings
- `lib/notification_center/` - Notification management and preferences

### Theming System
- `lib/globals/static/custom_themes.dart` - Theme definitions (Lavender, Red, Monochrome, Dark, Aquamarine)
- Theme selection persisted to local storage, applied via StreamBuilder in main.dart
- Access theme: `Theme.of(context).colorScheme`

### Reusable Widgets
- `lib/globals/static/global_widgets.dart` - Common widgets (textBubble, progression, swipePage navigation)

## Backend

- **Database**: Supabase (PostgreSQL with Row Level Security)
- **ML Model**: External Render server at `https://symptom2disease.onrender.com/predict`
- **Auth**: Supabase Auth with support for email/password, anonymous sessions, and Apple Sign In

## Key Dependencies

- `supabase_flutter` - Backend and auth
- `google_maps_flutter` - Maps functionality
- `geolocator` - Location services
- `flutter_local_notifications` - Push notifications
- `http` - API calls to prediction service
- `provider` - State management
- `localstorage` - Persistent local settings
