# Flutter Clean Architecture Template

This is a Flutter template project that follows the principles of Clean Architecture and comes pre-configured with a set of modern and robust features to kickstart your development.

## Features

This template includes the following features out-of-the-box:

- **State Management**: Uses [`flutter_bloc`](https://pub.dev/packages/flutter_bloc) for predictable and scalable state management, separating UI from business logic effectively.

- **Dependency Injection**: Implemented with [`get_it`](https://pub.dev/packages/get_it) and [`injectable`](https://pub.dev/packages/injectable) for a clean and maintainable dependency resolution system.

- **Routing**: Handled by [`go_router`](https://pub.dev/packages/go_router) for a declarative, URL-based navigation system that simplifies complex navigation scenarios.

- **Internationalization (i18n)**: Supports multiple languages using the `intl` package. Localization files are managed via `l10n.yaml`.

- **Continuous Integration (CI)**: Includes a pre-configured GitHub Actions workflow (`.github/workflows/cli.yml`) that:
  - Runs `flutter analyze` and `flutter test` on every pull request to the `main` branch.
  - Builds release versions for both Android (`appbundle`) and iOS.

- **Clean Architecture**: The project structure is organized to enforce a separation of concerns between layers (Domain, Data, and Presentation), making the codebase modular, testable, and easier to maintain.

- **Code Quality**: Enforces code quality and style using [`flutter_lints`](https://pub.dev/packages/flutter_lints).
