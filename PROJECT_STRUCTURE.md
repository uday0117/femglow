# FemGlow - Period Tracking App

## Project Overview
FemGlow is a comprehensive period tracking application built with Flutter and GetX state management. The app helps users track their menstrual cycle, predict ovulation, monitor fertile days, and maintain overall reproductive health awareness.

## Package Information
- **Package Name**: `com.uksolutions.femglow`
- **App Name**: FemGlow
- **Flutter SDK**: ^3.10.4

## Features Implemented

### ✅ Phase 1 - Foundation (Completed)
1. **GetX Architecture Setup**
   - Clean folder structure with separation of concerns
   - Route management with GetX navigation
   - Dependency injection with GetX bindings
   - State management ready

2. **Theming System**
   - Light and Dark themes
   - Custom color palette matching app branding
   - Material Design 3 implementation
   - Theme switching support

3. **Splash Screen**
   - Beautiful branded splash screen
   - Auto-navigation after 3 seconds
   - Checks for onboarding completion status

4. **Welcome/Onboarding Screens**
   - 3 beautiful onboarding pages
   - Page indicators
   - Skip functionality
   - Smooth page transitions

5. **Package Configuration**
   - Android package: `com.uksolutions.femglow`
   - Updated MainActivity with correct package
   - iOS bundle identifier ready for update

## Project Structure

```
lib/
├── main.dart                          # App entry point
└── app/
    ├── core/                          # Core utilities
    │   ├── theme/
    │   │   └── app_theme.dart        # Light & Dark themes
    │   └── values/
    │       ├── app_colors.dart       # Color constants
    │       └── app_strings.dart      # String constants
    ├── routes/                        # Navigation
    │   ├── app_routes.dart           # Route constants
    │   └── app_pages.dart            # Route configuration
    └── modules/                       # Feature modules
        ├── splash/
        │   ├── controllers/
        │   │   └── splash_controller.dart
        │   ├── bindings/
        │   │   └── splash_binding.dart
        │   └── views/
        │       └── splash_view.dart
        └── welcome/
            ├── controllers/
            │   └── welcome_controller.dart
            ├── bindings/
            │   └── welcome_binding.dart
            └── views/
                └── welcome_view.dart
```

## Color Palette

### Primary Colors
- **Primary**: `#FF5C8A` - Vibrant pink for main actions
- **Secondary**: `#FFB6C1` - Soft pink for accents

### Background Colors
- **Light Background**: `#FFF5F7` - Soft pink-white
- **Dark Background**: `#1E1E1E` - Dark gray

### Feature-Specific Colors
- **Flow Intensity**:
  - Light: `#FFDDE7`
  - Medium: `#FF8BA7`
  - Heavy: `#E91E63`
- **Ovulation**: `#9C27B0` - Purple
- **Fertile**: `#BA68C8` - Light purple

## Dependencies

### State Management & Storage
- `get: ^4.6.6` - State management, routing, dependency injection
- `get_storage: ^2.1.1` - Local key-value storage
- `shared_preferences: ^2.2.3` - Additional local storage

### UI Components
- `table_calendar: ^3.1.2` - Calendar widget for cycle tracking
- `font_awesome_flutter: ^10.7.0` - Icon library
- `flutter_svg: ^2.0.10+1` - SVG support
- `lottie: ^3.1.2` - Animations

### Date & Time
- `intl: ^0.19.0` - Internationalization
- `timezone: ^0.9.4` - Timezone support

### Notifications
- `flutter_local_notifications: ^17.2.3` - Local push notifications

## How to Run

1. **Install Dependencies**
   ```bash
   flutter pub get
   ```

2. **Run on Device/Emulator**
   ```bash
   flutter run
   ```

3. **Build for Release**
   ```bash
   # Android
   flutter build apk --release
   
   # iOS
   flutter build ios --release
   ```

## Next Steps

### Phase 2 - Core Features (To Be Implemented)
1. **Home Screen**
   - Cycle overview dashboard
   - Current cycle day indicator
   - Next period countdown
   - Ovulation prediction display

2. **Period Logging**
   - Start/end date picker
   - Flow intensity tracking
   - Symptom logging

3. **Calendar View**
   - Monthly calendar with cycle overlay
   - Period days highlighted
   - Fertile window indication
   - Ovulation day marker

4. **Data Models**
   - Cycle data model
   - Period entry model
   - Mood tracking model
   - Settings model

5. **Local Storage**
   - Cycle history persistence
   - Settings storage
   - Data backup/restore

### Phase 3 - Advanced Features
1. **Mood & Symptom Tracking**
2. **Insights & Analytics**
3. **Reminder Notifications**
4. **Profile & Settings**
5. **Data Export**

## Development Guidelines

### GetX Architecture Patterns

1. **Module Structure**
   ```
   module_name/
   ├── controllers/       # Business logic
   ├── bindings/         # Dependency injection
   ├── views/            # UI components
   └── widgets/          # Reusable widgets (optional)
   ```

2. **Controller Template**
   ```dart
   class MyController extends GetxController {
     final observable = false.obs;
     
     @override
     void onInit() {
       super.onInit();
       // Initialize
     }
     
     @override
     void onClose() {
       // Cleanup
       super.onClose();
     }
   }
   ```

3. **Navigation**
   ```dart
   // Named routes
   Get.toNamed(AppRoutes.home);
   Get.offAllNamed(AppRoutes.welcome);
   ```

4. **State Management**
   ```dart
   // Observable
   final count = 0.obs;
   
   // UI Update
   Obx(() => Text('${controller.count}'))
   ```

## Testing

Run tests with:
```bash
flutter test
```

## Contributing

When adding new features:
1. Follow the GetX module structure
2. Use existing color constants from `app_colors.dart`
3. Add string constants to `app_strings.dart`
4. Update routes in `app_routes.dart` and `app_pages.dart`
5. Test on both light and dark themes

## License

Private project - All rights reserved to UK Solutions
