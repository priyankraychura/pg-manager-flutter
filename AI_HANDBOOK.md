# PG Manager - AI & Developer Handbook

Welcome! This document outlines the architecture, patterns, design guidelines, and rules established for the **PG Manager Tenant App** (Flutter/Dart). Refer to this guide to maintain consistency, avoid regression, and ensure your contributions align with the project design system.

---

## 1. Project Specifications & Decisions

- **Platforms:** Android & iOS only (no Web, macOS, Windows, or Linux targets).
- **Primary Language:** English only (no localization support needed).
- **Default Theme:** **Light Mode** is the default theme. Dark Mode is supported and toggled via the settings screen using a Riverpod state provider.
- **State Management:** Flutter Riverpod.
- **Routing:** Declarative routing using GoRouter (`lib/core/router/app_router.dart`).
- **Dependency Injection:** Service Locator pattern using `GetIt` (`lib/injection/service_locator.dart`).

---

## 2. Architecture: Feature-First Clean Architecture

Each folder in `lib/features/` is organized into clean architectural layers, keeping file sizes small (typically under 200 lines) and splitting logic from presentation.

```
lib/
├── core/                              # Shared code across all features
│   ├── theme/                         # App colors, text styles, spacings, and theme data
│   ├── router/                        # GoRouter configuration
│   ├── widgets/                       # Reusable UI components (GlassContainer, GlassButton, etc.)
│   ├── extensions/                    # Context, string, and date utility extensions
│   ├── utils/                         # Validators, formatters, and helpers
│   └── network/                       # Dio api_client and custom exceptions
│
├── features/                          # Independent business modules
│   ├── <feature_name>/
│   │   ├── domain/                    # Enterprise & Application rules (Pure Dart)
│   │   │   ├── entities/              # Data structures (immutable)
│   │   │   └── repositories/          # Repository contracts (interfaces)
│   │   │
│   │   ├── data/                      # Data implementation layer
│   │   │   ├── models/                # Serialization/deserialization classes
│   │   │   └── datasources/           # Mock or API datasources (implementing domain contracts)
│   │   │
│   │   └── presentation/              # Presentation layer
│   │       ├── providers/             # Riverpod state providers
│   │       ├── pages/                 # Full-screen widgets
│   │       └── widgets/               # Module-specific widgets
│   │
│   └── ...                            # Auth, dashboard, complaints, menu, profile, rent, room, wifi, notices, leave_notice, settings
│
└── injection/
    └── service_locator.dart           # GetIt dependency injection setup
```

---

## 3. Mock-to-Backend Strategy (NestJS Ready)

To make future integration with a NestJS backend seamless without rewriting the UI layer:
1. **Domain Interfaces:** Pages and Providers depend on abstract repository contracts (e.g., `AuthRepository` or `RentRepository`) located in the feature's `domain/repositories/` folder.
2. **Mock Datasources:** All currently registered implementations are Mock Datasources (e.g., `AuthMockDatasource`) that simulate network latency (using `Future.delayed`) and return realistic mock datasets.
3. **Registration:** Registrations are managed in `lib/injection/service_locator.dart`.
4. **Backend Switch:** When the NestJS backend is ready:
   - Implement `api_datasource.dart` inside `data/datasources/` using Dio (`apiClient`).
   - Swap the registration binding in `service_locator.dart` to register the new api datasource.
   - **Do not modify presentation page or widget code.**

---

## 4. UI Guidelines & Aesthetics (Glassmorphic & Premium)

The app features a premium, modern design with subtle micro-animations and vibrant gradients.
- **Glassmorphism:**
  - Wrap cards, app bars, and bottom navigation bars in the shared custom `GlassContainer` or `GlassCard` widgets.
  - Utilize `BackdropFilter` with `ImageFilter.blur(sigmaX: 20, sigmaY: 20)`.
  - Border thickness should be 1px with transparent white overlays (`Colors.white.withOpacity(0.12)` for dark mode and `Colors.white.withOpacity(0.6)` for light mode).
- **Color Gradients:**
  - Backgrounds must use `GradientBackground` (a slow animated gradient mesh).
  - Use `AppColors.primaryGradient` or `AppColors.accentGradient` for buttons and highlights.
- **Typography:**
  - Use Google Fonts **Outfit** for all textual elements.
  - Apply standard typographical styles defined in `lib/core/theme/app_text_styles.dart` (`h1`, `h2`, `body`, `caption`, `display`, etc.).
- **Spacing:**
  - Never hardcode margins or padding values. Use spacing tokens defined in `lib/core/theme/app_spacing.dart` (e.g., `AppSpacing.md`, `AppSpacing.screenPadding`).

---

## 5. Development Rules & Code Hygiene

1. **Static Analysis Compliance:**
   - Keep `flutter analyze` completely clean (0 warnings, 0 errors, 0 infos).
   - Use Dart 3+ features:
     - **Super Parameters:** Declare constructors using `super.parameter` syntax (e.g. `const NetworkException([super.message]);`).
     - **Null-Aware Elements:** When adding conditional widgets/elements inside list collections, use the prefix null-aware operator `?` (e.g. `?trailing,` inside a list) instead of `if (trailing != null) trailing,`.
2. **Relative Imports:**
   - Avoid package-level imports inside `lib/` for files within the same workspace. Use relative imports (e.g. `import '../../domain/entities/user_entity.dart';`).
   - Ensure imports navigating across feature boundaries go up to the common root properly (e.g. `import '../../../rent/domain/entities/rent_entity.dart';` when importing from another feature).
3. **Clean Architecture Dependencies:**
   - Presentation code must never import `data/` classes directly (such as models or mock datasources). They must only communicate with `domain/` classes (entities and repositories) or presentation providers.
4. **Form Handling:**
   - Always implement form validation (such as name, email, phone) using validators located in `lib/core/utils/validators.dart`.
   - Forward actions using the `onFieldSubmitted` callback inside custom input fields.
