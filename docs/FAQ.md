# Preguntas Frecuentes (FAQ)

Respuestas a preguntas comunes sobre este proyecto.

## 📋 Tabla de Contenidos

- [General](#general)
- [Arquitectura](#arquitectura)
- [Dependency Injection](#dependency-injection)
- [State Management](#state-management)
- [Testing](#testing)
- [Desarrollo](#desarrollo)
- [Deployment](#deployment)

## General

### ¿Qué es Clean Architecture?

Clean Architecture es un patrón de diseño propuesto por Robert C. Martin que separa el código en capas con responsabilidades específicas. El objetivo es hacer el código más mantenible, testeable e independiente de frameworks y herramientas externas.

### ¿Por qué usar este template?

Este template te ahorra tiempo configurando:
- Estructura de carpetas siguiendo Clean Architecture
- State management con BLoC
- Dependency injection automática
- Routing declarativo
- CI/CD con GitHub Actions
- Mejores prácticas de Flutter

### ¿Es este template adecuado para mi proyecto?

**Sí, si:**
- Estás construyendo una app mediana/grande
- Necesitas un código escalable y mantenible
- Trabajas en equipo
- Quieres seguir mejores prácticas

**Considera otras opciones si:**
- Es un proyecto muy pequeño/POC
- Necesitas entregar algo muy rápido
- No estás familiarizado con Clean Architecture (aprende primero)

## Arquitectura

### ¿Debo seguir estrictamente las 3 capas?

Para features complejas, sí. Para features muy simples (como una página estática), puedes omitir Domain/Data y solo usar Presentation. Pero en general, seguir la estructura es recomendado.

### ¿Dónde pongo utilidades y helpers?

```
lib/core/
├── constants/      # Constantes globales
├── utils/          # Utilidades generales
├── extensions/     # Extensiones de Dart/Flutter
└── errors/         # Failures y exceptions base
```

### ¿Dónde van los widgets compartidos?

```
lib/core/
└── widgets/        # Widgets usados en múltiples features
    ├── buttons/
    ├── cards/
    └── dialogs/
```

### ¿Cuándo crear una nueva feature?

Crea una nueva feature cuando:
- Representa una funcionalidad de negocio distinta
- Tiene sus propias entidades y lógica
- Puede desarrollarse/testearse independientemente

Ejemplos: `auth`, `user`, `products`, `cart`, `orders`

### ¿Entities vs Models, cuál es la diferencia?

**Entity (Domain)**:
```dart
class User {
  final String id;
  final String name;
  
  const User({required this.id, required this.name});
}
```

**Model (Data)**:
```dart
class UserModel extends User {
  UserModel({required String id, required String name}) 
    : super(id: id, name: name);
  
  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(id: json['id'], name: json['name']);
  }
  
  Map<String, dynamic> toJson() => {'id': id, 'name': name};
}
```

- **Entity**: Objeto de negocio puro, sin dependencias
- **Model**: Entity + capacidades de serialización/deserialización

## Dependency Injection

### ¿Por qué usar GetIt e Injectable?

- **GetIt**: Service locator simple y eficiente
- **Injectable**: Genera código automáticamente, evita errores manuales
- **Combinados**: Dependency injection declarativa y type-safe

### ¿Cómo registro una nueva dependencia?

1. Agrega la anotación:
```dart
@injectable
class MyService {
  final MyDependency dependency;
  MyService(this.dependency);
}
```

2. Regenera el código:
```bash
flutter pub run build_runner build --delete-conflicting-outputs
```

### ¿Cuándo usar @singleton vs @lazySingleton vs @injectable?

- **@singleton**: Instancia creada inmediatamente al iniciar la app
- **@lazySingleton**: Instancia creada la primera vez que se solicita
- **@injectable**: Nueva instancia cada vez (factory)

```dart
@singleton      // Creado al inicio
class AppConfig {}

@lazySingleton  // Creado cuando se usa
class DatabaseHelper {}

@injectable     // Nuevo cada vez
class GetUserUseCase {}
```

### ¿Cómo registro interfaces?

```dart
@Injectable(as: UserRepository)
class UserRepositoryImpl implements UserRepository {
  // ...
}
```

Ahora cuando pidas `UserRepository`, recibirás `UserRepositoryImpl`.

### ¿Cómo manejo múltiples implementaciones?

Usa `@Named`:

```dart
@Named('remote')
@Injectable(as: UserDataSource)
class RemoteUserDataSource implements UserDataSource {}

@Named('local')
@Injectable(as: UserDataSource)
class LocalUserDataSource implements UserDataSource {}

// Uso
@injectable
class UserRepository {
  UserRepository(
    @Named('remote') this.remoteDataSource,
    @Named('local') this.localDataSource,
  );
}
```

## State Management

### ¿Cuándo usar Cubit vs BLoC?

**Cubit** - Para la mayoría de casos:
- Más simple
- Menos boilerplate
- Suficiente para 90% de casos

**BLoC** - Cuando necesitas:
- Historial de eventos
- Debugging avanzado
- Transformaciones de eventos (debounce, throttle)

### ¿Cómo comparto estado entre pantallas?

**Opción 1: BlocProvider alto en el árbol**
```dart
MaterialApp(
  home: BlocProvider(
    create: (_) => getIt<AuthCubit>(),
    child: AppNavigator(),
  ),
)
```

**Opción 2: Acceso directo vía GetIt**
```dart
// Solo para leer, no escuchar cambios
final authCubit = getIt<AuthCubit>();
```

### ¿Debo crear un Cubit para cada pantalla?

No necesariamente. Crea un Cubit cuando:
- La pantalla tiene estado complejo
- Necesitas separar lógica de UI
- El estado cambia frecuentemente

Pantallas simples (estáticas) no necesitan Cubit.

### ¿Cómo evito rebuilds innecesarios?

**Usa buildWhen**:
```dart
BlocBuilder<UserCubit, UserState>(
  buildWhen: (previous, current) => previous.user != current.user,
  builder: (context, state) => UserWidget(state.user),
)
```

**Usa const**:
```dart
const UserWidget(user: user)
```

**Usa Keys**:
```dart
ListView.builder(
  itemBuilder: (_, index) => UserTile(
    key: ValueKey(users[index].id),
    user: users[index],
  ),
)
```

## Testing

### ¿Qué debo testear?

**Prioridad Alta:**
- Use Cases (lógica de negocio)
- Repositories (manejo de datos)
- BLoCs/Cubits (lógica de presentación)

**Prioridad Media:**
- Widgets complejos
- Utilities y helpers

**Prioridad Baja:**
- Widgets simples
- Models (si solo son serialización)

### ¿Cómo mockeo dependencias?

Usa `mockito`:

```dart
@GenerateMocks([UserRepository])
void main() {
  late MockUserRepository mockRepository;
  late GetUserUseCase useCase;
  
  setUp(() {
    mockRepository = MockUserRepository();
    useCase = GetUserUseCase(mockRepository);
  });
  
  test('should return user', () async {
    // Arrange
    when(() => mockRepository.getUser('1'))
        .thenAnswer((_) async => Right(User(id: '1', name: 'John')));
    
    // Act
    final result = await useCase('1');
    
    // Assert
    expect(result.isRight(), true);
  });
}
```

### ¿Cómo testeo BLoCs?

Usa `bloc_test`:

```dart
blocTest<CounterCubit, int>(
  'emits [1] when increment is called',
  build: () => CounterCubit(),
  act: (cubit) => cubit.increment(),
  expect: () => [1],
);
```

### ¿Cómo ejecuto tests con coverage?

```bash
# Ejecutar tests con coverage
flutter test --coverage

# Ver reporte HTML (requiere lcov)
genhtml coverage/lcov.info -o coverage/html
open coverage/html/index.html
```

## Desarrollo

### ¿Cómo agrego una nueva pantalla?

1. Crea la estructura:
```
lib/feature/mi_feature/presentation/
├── pages/
│   └── mi_page.dart
└── blocs/
    ├── mi_cubit.dart
    └── mi_state.dart
```

2. Agrega la ruta en `app_router.dart`:
```dart
GoRoute(
  path: '/mi-ruta',
  builder: (_, __) => MiPage(),
)
```

### ¿Cómo integro una API?

1. Define la Entity en Domain
2. Crea el Model en Data
3. Crea el RemoteDataSource
4. Implementa el Repository
5. Crea el UseCase
6. Úsalo en el BLoC

Ver [ARCHITECTURE.md](./ARCHITECTURE.md) para ejemplos completos.

### ¿Cómo manejo tokens de autenticación?

**Opción 1: Interceptor de Dio**
```dart
@module
abstract class NetworkModule {
  @lazySingleton
  Dio get dio {
    final dio = Dio();
    dio.interceptors.add(AuthInterceptor());
    return dio;
  }
}

class AuthInterceptor extends Interceptor {
  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    final token = getIt<AuthCubit>().state.token;
    if (token != null) {
      options.headers['Authorization'] = 'Bearer $token';
    }
    handler.next(options);
  }
}
```

### ¿Cómo manejo diferentes ambientes (dev/prod)?

**Opción 1: Flavors de Flutter**
```bash
flutter run --flavor dev
flutter run --flavor prod
```

**Opción 2: Variables de entorno**
```dart
const apiUrl = String.fromEnvironment('API_URL', defaultValue: 'http://localhost');
```

```bash
flutter run --dart-define=API_URL=https://api.production.com
```

### ¿Cómo agrego soporte para otro idioma?

1. Crea el archivo ARB:
```
lib/core/l10n/app_es.arb
```

2. Agrega traducciones:
```json
{
  "@@locale": "es",
  "appTitle": "Mi Aplicación"
}
```

3. Genera código:
```bash
flutter gen-l10n
```

4. Actualiza `supportedLocales` en `MaterialApp`:
```dart
MaterialApp(
  localizationsDelegates: AppLocalizations.localizationsDelegates,
  supportedLocales: AppLocalizations.supportedLocales,
)
```

## Deployment

### ¿Cómo genero un build de release?

**Android:**
```bash
flutter build apk --release          # APK
flutter build appbundle --release    # App Bundle (recomendado)
```

**iOS:**
```bash
flutter build ios --release
```

**Web:**
```bash
flutter build web --release
```

### ¿Cómo configuro el CI/CD?

El proyecto incluye GitHub Actions preconfigurado. Ver `.github/workflows/cli.yml`.

Para otros servicios (GitLab CI, Bitbucket, etc.), adapta el workflow existente.

### ¿Cómo firmo mi app Android?

1. Crea un keystore:
```bash
keytool -genkey -v -keystore ~/key.jks -keyalg RSA -keysize 2048 -validity 10000 -alias key
```

2. Crea `android/key.properties`:
```properties
storePassword=tu-password
keyPassword=tu-password
keyAlias=key
storeFile=/ruta/al/key.jks
```

3. Actualiza `android/app/build.gradle`:
```gradle
def keystoreProperties = new Properties()
def keystorePropertiesFile = rootProject.file('key.properties')
if (keystorePropertiesFile.exists()) {
    keystoreProperties.load(new FileInputStream(keystorePropertiesFile))
}

android {
    signingConfigs {
        release {
            keyAlias keystoreProperties['keyAlias']
            keyPassword keystoreProperties['keyPassword']
            storeFile keystoreProperties['storeFile'] ? file(keystoreProperties['storeFile']) : null
            storePassword keystoreProperties['storePassword']
        }
    }
    buildTypes {
        release {
            signingConfig signingConfigs.release
        }
    }
}
```

### ¿Cómo optimizo el tamaño de la app?

**Android:**
```bash
flutter build appbundle --release --obfuscate --split-debug-info=build/debug-info
```

**iOS:**
```bash
flutter build ios --release --obfuscate --split-debug-info=build/debug-info
```

**Habilita code shrinking en Android:**
```gradle
// android/app/build.gradle
buildTypes {
    release {
        minifyEnabled true
        shrinkResources true
    }
}
```

---

## 🤔 ¿Más preguntas?

Si tu pregunta no está aquí:

1. Revisa la [documentación](../README.md)
2. Busca en [issues cerrados](https://github.com/MiguelHG2351/flutter-clean-architecture/issues?q=is%3Aissue+is%3Aclosed)
3. Abre un [nuevo issue](https://github.com/MiguelHG2351/flutter-clean-architecture/issues/new) con la etiqueta `question`
