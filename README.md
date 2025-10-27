# Flutter Clean Architecture Template

[![CI](https://github.com/MiguelHG2351/flutter-clean-architecture/workflows/CI/badge.svg)](https://github.com/MiguelHG2351/flutter-clean-architecture/actions)
[![License: MIT](https://img.shields.io/badge/License-MIT-blue.svg)](LICENSE)

Un template de Flutter que implementa los principios de Clean Architecture, preconfigurado con herramientas modernas y robustas para acelerar el desarrollo de aplicaciones escalables y mantenibles.

## 📋 Tabla de Contenidos

- [Características](#-características)
- [Requisitos Previos](#-requisitos-previos)
- [Instalación](#-instalación)
- [Estructura del Proyecto](#-estructura-del-proyecto)
- [Arquitectura](#-arquitectura)
- [Uso](#-uso)
- [Comandos Útiles](#-comandos-útiles)
- [Testing](#-testing)
- [CI/CD](#-cicd)
- [Contribución](#-contribución)
- [Licencia](#-licencia)

## ✨ Características

Este template incluye las siguientes características listas para usar:

- **🎯 State Management**: Usa [`flutter_bloc`](https://pub.dev/packages/flutter_bloc) para un manejo de estado predecible y escalable, separando efectivamente la UI de la lógica de negocio.

- **💉 Dependency Injection**: Implementado con [`get_it`](https://pub.dev/packages/get_it) e [`injectable`](https://pub.dev/packages/injectable) para un sistema de resolución de dependencias limpio y mantenible.

- **🧭 Routing**: Manejado por [`go_router`](https://pub.dev/packages/go_router) para un sistema de navegación declarativo basado en URLs que simplifica escenarios de navegación complejos.

- **🌍 Internacionalización (i18n)**: Soporte para múltiples idiomas usando el paquete `intl`. Los archivos de localización se gestionan vía `l10n.yaml`.

- **🔄 Continuous Integration (CI)**: Incluye un workflow de GitHub Actions preconfigurado (`.github/workflows/cli.yml`) que:
  - Ejecuta `flutter analyze` y `flutter test` en cada pull request a la rama `main`.
  - Genera builds de release para Android (`appbundle`) e iOS.

- **🏗️ Clean Architecture**: La estructura del proyecto está organizada para aplicar separación de responsabilidades entre capas (Domain, Data y Presentation), haciendo el código modular, testeable y fácil de mantener.

- **✅ Code Quality**: Aplica calidad y estilo de código usando [`flutter_lints`](https://pub.dev/packages/flutter_lints).

## 📦 Requisitos Previos

Antes de comenzar, asegúrate de tener instalado:

- **Flutter SDK**: ^3.7.2 o superior
- **Dart SDK**: Incluido con Flutter
- **Android Studio** o **Xcode** (según la plataforma objetivo)
- **Git**

Verifica tu instalación de Flutter:

```bash
flutter doctor
```

## 🚀 Instalación

1. **Clona este repositorio**

```bash
git clone https://github.com/MiguelHG2351/flutter-clean-architecture.git
cd flutter-clean-architecture
```

2. **Instala las dependencias**

```bash
flutter pub get
```

3. **Genera código necesario** (para dependency injection y localization)

```bash
flutter pub run build_runner build --delete-conflicting-outputs
```

4. **Ejecuta la aplicación**

```bash
flutter run
```

## 📁 Estructura del Proyecto

```
lib/
├── core/                      # Funcionalidades centrales y compartidas
│   ├── di/                    # Configuración de Dependency Injection
│   │   ├── injector.dart      # Setup de GetIt e Injectable
│   │   └── injector.config.dart
│   ├── l10n/                  # Archivos de localización
│   │   ├── app_en.arb         # Traducciones en inglés
│   │   └── app_localizations.dart
│   └── router/                # Configuración de rutas
│       └── app_router.dart    # Definición de rutas con GoRouter
│
├── feature/                   # Módulos por funcionalidad (Clean Architecture)
│   └── counter/               # Ejemplo: Feature de contador
│       ├── data/              # Capa de Datos
│       │   ├── datasources/   # Fuentes de datos (API, local DB, etc.)
│       │   ├── models/        # Modelos de datos
│       │   └── repositories/  # Implementaciones de repositorios
│       │
│       ├── domain/            # Capa de Dominio
│       │   ├── entities/      # Entidades de negocio
│       │   ├── repositories/  # Interfaces de repositorios
│       │   └── usecases/      # Casos de uso
│       │
│       └── presentation/      # Capa de Presentación
│           ├── blocs/         # BLoCs/Cubits para estado
│           ├── pages/         # Páginas/Pantallas
│           └── widgets/       # Widgets reutilizables
│
├── bootstrap.dart             # Inicialización de la app
└── main.dart                  # Punto de entrada
```

## 🏗️ Arquitectura

Este proyecto sigue **Clean Architecture** con tres capas principales:

### 1. Presentation Layer (Capa de Presentación)

- **Responsabilidad**: Maneja la UI y las interacciones del usuario
- **Componentes**:
  - **Pages**: Pantallas completas de la aplicación
  - **Widgets**: Componentes UI reutilizables
  - **BLoCs/Cubits**: Manejo de estado usando flutter_bloc

### 2. Domain Layer (Capa de Dominio)

- **Responsabilidad**: Contiene la lógica de negocio de la aplicación
- **Componentes**:
  - **Entities**: Objetos de negocio puros sin dependencias
  - **Use Cases**: Operaciones de negocio específicas
  - **Repository Interfaces**: Contratos para acceso a datos

### 3. Data Layer (Capa de Datos)

- **Responsabilidad**: Implementa el acceso a fuentes de datos
- **Componentes**:
  - **Models**: Representaciones de datos con serialización
  - **Data Sources**: APIs, bases de datos locales, caché
  - **Repository Implementations**: Implementaciones concretas de los repositorios

### Flujo de Datos

```
UI (Pages/Widgets) ←→ BLoC/Cubit ←→ Use Case ←→ Repository Interface
                                                        ↕
                                            Repository Implementation
                                                        ↕
                                                  Data Sources
```

### Principios Aplicados

- **Dependency Rule**: Las dependencias apuntan hacia adentro. Las capas internas no conocen las externas.
- **Single Responsibility**: Cada clase tiene una única responsabilidad.
- **Dependency Inversion**: Se depende de abstracciones, no de implementaciones concretas.

## 💻 Uso

### Agregar una Nueva Feature

1. **Crea la estructura de carpetas**

```bash
lib/feature/mi_feature/
├── data/
│   ├── datasources/
│   ├── models/
│   └── repositories/
├── domain/
│   ├── entities/
│   ├── repositories/
│   └── usecases/
└── presentation/
    ├── blocs/
    ├── pages/
    └── widgets/
```

2. **Define la entidad en Domain**

```dart
// lib/feature/mi_feature/domain/entities/mi_entidad.dart
class MiEntidad {
  final String id;
  final String nombre;

  const MiEntidad({required this.id, required this.nombre});
}
```

3. **Crea el Repository Interface**

```dart
// lib/feature/mi_feature/domain/repositories/mi_repository.dart
abstract class MiRepository {
  Future<MiEntidad> obtenerDatos();
}
```

4. **Implementa el Repository en Data**

```dart
// lib/feature/mi_feature/data/repositories/mi_repository_impl.dart
@Injectable(as: MiRepository)
class MiRepositoryImpl implements MiRepository {
  @override
  Future<MiEntidad> obtenerDatos() async {
    // Implementación
  }
}
```

5. **Registra las dependencias**

Asegúrate de ejecutar el generador de código después de agregar dependencias:

```bash
flutter pub run build_runner build --delete-conflicting-outputs
```

### Agregar Traducciones

1. Edita el archivo ARB correspondiente en `lib/core/l10n/`
2. Ejecuta:

```bash
flutter gen-l10n
```

## 🔧 Comandos Útiles

### Desarrollo

```bash
# Ejecutar la app en modo debug
flutter run

# Ejecutar con hot reload
flutter run --hot

# Ejecutar en un dispositivo específico
flutter run -d <device_id>
```

### Generación de Código

```bash
# Generar código de injectable y build_runner
flutter pub run build_runner build --delete-conflicting-outputs

# Modo watch (regenera automáticamente)
flutter pub run build_runner watch --delete-conflicting-outputs

# Generar localizaciones
flutter gen-l10n
```

### Testing

```bash
# Ejecutar todos los tests
flutter test

# Ejecutar tests con coverage
flutter test --coverage

# Ver reporte de coverage
genhtml coverage/lcov.info -o coverage/html
open coverage/html/index.html
```

### Análisis de Código

```bash
# Analizar el código
flutter analyze

# Formatear el código
dart format lib/ test/

# Verificar formato sin modificar
dart format --output=none --set-exit-if-changed lib/ test/
```

### Build

```bash
# Build APK (Android)
flutter build apk --release

# Build App Bundle (Android)
flutter build appbundle --release

# Build iOS
flutter build ios --release

# Build Web
flutter build web --release
```

## 🧪 Testing

El proyecto está configurado para diferentes tipos de tests:

### Unit Tests

```dart
// test/feature/counter/domain/usecases/increment_counter_test.dart
void main() {
  test('debería incrementar el contador', () {
    // Arrange
    final useCase = IncrementCounterUseCase();
    
    // Act
    final result = useCase.call(5);
    
    // Assert
    expect(result, 6);
  });
}
```

### Widget Tests

```dart
testWidgets('CounterPage muestra el contador', (tester) async {
  await tester.pumpWidget(MyApp());
  
  expect(find.text('0'), findsOneWidget);
  expect(find.byIcon(Icons.add), findsOneWidget);
});
```

## 🔄 CI/CD

El proyecto incluye un workflow de GitHub Actions que:

1. **Análisis de Código**: Ejecuta `flutter analyze`
2. **Tests**: Ejecuta `flutter test`
3. **Build Android**: Genera App Bundle
4. **Build iOS**: Genera archivo IPA

El workflow se ejecuta automáticamente en:
- Pull requests a la rama `main`
- Pushes a la rama `main`

Consulta `.github/workflows/cli.yml` para más detalles.

## 🤝 Contribución

Las contribuciones son bienvenidas. Por favor:

1. Fork el proyecto
2. Crea una rama para tu feature (`git checkout -b feature/amazing-feature`)
3. Commit tus cambios (`git commit -m 'Add some amazing feature'`)
4. Push a la rama (`git push origin feature/amazing-feature`)
5. Abre un Pull Request

### Guidelines

- Sigue la estructura de Clean Architecture
- Escribe tests para nuevas features
- Mantén la cobertura de tests alta
- Usa `flutter_lints` para estilo de código
- Documenta funciones y clases complejas

## 📄 Licencia

Este proyecto está bajo la Licencia MIT. Ver el archivo [LICENSE](LICENSE) para más detalles.

---

**Desarrollado con ❤️ usando Flutter**
