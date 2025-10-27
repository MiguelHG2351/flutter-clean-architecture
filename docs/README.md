# Documentación

Bienvenido a la documentación del proyecto Flutter Clean Architecture Template.

## 📚 Documentos Disponibles

### Guías Principales

- **[README Principal](../README.md)** - Punto de inicio, características e instalación
- **[Guía de Contribución](../CONTRIBUTING.md)** - Cómo contribuir al proyecto
- **[Arquitectura](./ARCHITECTURE.md)** - Explicación detallada de la arquitectura
- **[Mejores Prácticas](./BEST_PRACTICES.md)** - Convenciones y prácticas recomendadas
- **[FAQ](./FAQ.md)** - Preguntas frecuentes

### Referencias Rápidas

- **[CHANGELOG](../CHANGELOG.md)** - Historial de cambios del proyecto
- **[LICENSE](../LICENSE)** - Licencia del proyecto

## 🎯 Rutas de Aprendizaje

### Para Principiantes

Si eres nuevo en este proyecto o en Clean Architecture:

1. Lee el [README Principal](../README.md) para entender las características
2. Sigue la [Guía de Instalación](../README.md#-instalación)
3. Revisa la [Estructura del Proyecto](../README.md#-estructura-del-proyecto)
4. Lee la [Arquitectura básica](./ARCHITECTURE.md#-principios-de-clean-architecture)
5. Consulta las [FAQ](./FAQ.md) para dudas comunes

### Para Desarrolladores

Si ya conoces Flutter y quieres usar este template:

1. [Instalación](../README.md#-instalación)
2. [Agregar una Nueva Feature](../README.md#agregar-una-nueva-feature)
3. [Mejores Prácticas](./BEST_PRACTICES.md)
4. [Comandos Útiles](../README.md#-comandos-útiles)

### Para Contribuidores

Si quieres contribuir al proyecto:

1. [Guía de Contribución](../CONTRIBUTING.md)
2. [Estándares de Código](../CONTRIBUTING.md#estándares-de-código)
3. [Guía de Commits](../CONTRIBUTING.md#guía-de-commits)
4. [Pull Requests](../CONTRIBUTING.md#pull-requests)

## 🏗️ Conceptos Clave

### Clean Architecture

La arquitectura limpia separa el código en tres capas principales:

```
┌─────────────────────────────────────┐
│      Presentation Layer             │
│  (UI, BLoCs, Pages, Widgets)        │
└──────────────┬──────────────────────┘
               │
┌──────────────▼──────────────────────┐
│        Domain Layer                 │
│  (Entities, Use Cases, Interfaces)  │
└──────────────┬──────────────────────┘
               │
┌──────────────▼──────────────────────┐
│         Data Layer                  │
│  (Models, Repositories, Data Sources│
└─────────────────────────────────────┘
```

Ver [Arquitectura Detallada](./ARCHITECTURE.md)

### State Management

Usamos **BLoC/Cubit** para manejo de estado:

- **Cubit**: Para estado simple
- **BLoC**: Para flujos complejos con eventos

Ver [State Management en Arquitectura](./ARCHITECTURE.md#-state-management)

### Dependency Injection

Usamos **GetIt** + **Injectable** para DI automática:

```dart
@injectable
class GetUserUseCase {
  final UserRepository repository;
  GetUserUseCase(this.repository);
}

// Uso
final useCase = getIt<GetUserUseCase>();
```

Ver [Dependency Injection](./ARCHITECTURE.md#-dependency-injection)

## 🔧 Herramientas y Tecnologías

### Core

- **Flutter**: ^3.7.2
- **Dart**: ^3.7.2

### State Management

- **flutter_bloc**: ^9.1.1
- **bloc**: ^9.0.0
- **equatable**: ^2.0.7

### Dependency Injection

- **get_it**: ^8.0.3
- **injectable**: ^2.5.0

### Routing

- **go_router**: ^16.0.0

### Localization

- **intl**: any
- **flutter_localizations**: SDK

### Development

- **build_runner**: ^2.5.4
- **injectable_generator**: 2.7.0
- **flutter_lints**: ^5.0.0

## 📖 Recursos Externos

### Flutter

- [Documentación Oficial de Flutter](https://flutter.dev/docs)
- [Widget Catalog](https://flutter.dev/docs/development/ui/widgets)
- [Cookbook](https://flutter.dev/docs/cookbook)

### Clean Architecture

- [Clean Architecture - Uncle Bob](https://blog.cleancoder.com/uncle-bob/2012/08/13/the-clean-architecture.html)
- [Clean Architecture in Flutter](https://resocoder.com/flutter-clean-architecture-tdd/)

### BLoC

- [BLoC Library](https://bloclibrary.dev/)
- [BLoC Pattern](https://www.didierboelens.com/2018/08/reactive-programming-streams-bloc/)

### Dependency Injection

- [GetIt Documentation](https://pub.dev/packages/get_it)
- [Injectable Documentation](https://pub.dev/packages/injectable)

### Testing

- [Flutter Testing Guide](https://flutter.dev/docs/testing)
- [Mockito](https://pub.dev/packages/mockito)
- [bloc_test](https://pub.dev/packages/bloc_test)

## 🎓 Tutoriales y Ejemplos

### Casos de Uso Comunes

1. **[Agregar una API REST](./ARCHITECTURE.md#data-layer-libfeaturedata)**
2. **[Crear una nueva pantalla](./FAQ.md#cómo-agrego-una-nueva-pantalla)**
3. **[Implementar autenticación](./FAQ.md#cómo-manejo-tokens-de-autenticación)**
4. **[Agregar un nuevo idioma](./FAQ.md#cómo-agrego-soporte-para-otro-idioma)**

### Ejemplos de Código

- **Use Case Completo**: Ver [ARCHITECTURE.md - Use Cases](./ARCHITECTURE.md#use-cases-casos-de-uso)
- **Repository Pattern**: Ver [ARCHITECTURE.md - Repository Implementations](./ARCHITECTURE.md#repository-implementations)
- **BLoC Implementation**: Ver [BEST_PRACTICES.md - Estado y BLoC](./BEST_PRACTICES.md#estado-y-bloc)

## 🐛 Troubleshooting

### Problemas Comunes

**Error: "No implementation found"**
- Solución: Ejecuta `flutter pub run build_runner build --delete-conflicting-outputs`

**Build Runner no genera código**
- Verifica que las anotaciones estén correctas (`@injectable`, `@module`, etc.)
- Limpia y regenera: `flutter clean && flutter pub get && flutter pub run build_runner build --delete-conflicting-outputs`

**BLoC no se actualiza**
- Asegúrate de usar estados inmutables
- Usa `Equatable` para comparación de estados
- Verifica que estés usando `emit()` en Cubit

**GetIt no encuentra dependencia**
- Verifica que la dependencia esté registrada
- Regenera el código de Injectable
- Asegúrate de llamar `configureDependencies()` en `main.dart`

Ver más en [FAQ - Desarrollo](./FAQ.md#desarrollo)

## 💬 Obtener Ayuda

### Canales de Soporte

1. **[FAQ](./FAQ.md)** - Preguntas frecuentes
2. **[Issues](https://github.com/MiguelHG2351/flutter-clean-architecture/issues)** - Reportar bugs o pedir features
3. **[Discussions](https://github.com/MiguelHG2351/flutter-clean-architecture/discussions)** - Preguntas generales

### Antes de Preguntar

1. Busca en la documentación existente
2. Revisa los issues cerrados
3. Asegúrate de tener la última versión

---

## 🤝 Contribuir a la Documentación

¿Encontraste un error o quieres mejorar la documentación?

1. Fork el proyecto
2. Edita los archivos en `/docs` o `README.md`
3. Abre un Pull Request

Ver [Guía de Contribución](../CONTRIBUTING.md) para más detalles.

---

**¿Sugerencias?** Abre un [issue](https://github.com/MiguelHG2351/flutter-clean-architecture/issues/new) o [discussion](https://github.com/MiguelHG2351/flutter-clean-architecture/discussions/new)!
