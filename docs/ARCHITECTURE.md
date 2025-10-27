# Arquitectura del Proyecto

Este documento describe en detalle la arquitectura del proyecto y las decisiones de diseño.

## 📐 Principios de Clean Architecture

Clean Architecture fue propuesta por Robert C. Martin (Uncle Bob) y se centra en:

1. **Independencia de Frameworks**: La lógica de negocio no depende de frameworks externos
2. **Testabilidad**: La lógica de negocio puede probarse sin UI, base de datos, etc.
3. **Independencia de UI**: La UI puede cambiar sin afectar la lógica
4. **Independencia de Base de Datos**: Puedes cambiar la BD sin afectar la lógica
5. **Independencia de Agentes Externos**: La lógica no sabe nada sobre el mundo exterior

## 🔄 Flujo de Datos

```
┌──────────────────────────────────────────────────────────────┐
│                     PRESENTATION LAYER                       │
│  ┌──────────┐      ┌───────────┐      ┌─────────────────┐    │
│  │  Pages   │ ───> │   BLoC    │ ───> │    Widgets      │    │
│  └──────────┘      └───────────┘      └─────────────────┘    │
│                           │                                  │
└───────────────────────────┼──────────────────────────────────┘
                            │
                            ▼
┌──────────────────────────────────────────────────────────────┐
│                      DOMAIN LAYER                            │
│  ┌──────────┐      ┌───────────┐      ┌─────────────────┐    │
│  │ Entities │ <─── │ Use Cases │ <─── │  Repositories   │    │
│  │          │      │           │      │  (Interfaces)   │    │
│  └──────────┘      └───────────┘      └─────────────────┘    │
│                           │                                  │
└───────────────────────────┼──────────────────────────────────┘
                            │
                            ▼
┌──────────────────────────────────────────────────────────────┐
│                       DATA LAYER                             │
│  ┌──────────┐      ┌───────────┐      ┌─────────────────┐    │
│  │  Models  │ <─── │Repository │ <─── │  Data Sources   │    │
│  │          │      │   Impl    │      │  (Remote/Local) │    │
│  └──────────┘      └───────────┘      └─────────────────┘    │
└──────────────────────────────────────────────────────────────┘
```

## 📦 Capas en Detalle

### 1. Presentation Layer (lib/feature/*/presentation/)

**Responsabilidad**: Renderizar la UI y manejar interacciones del usuario.

#### Componentes:

**Pages (Páginas)**
- Representan pantallas completas
- Son StatefulWidget o StatelessWidget
- Utilizan BlocProvider para inyectar BLoCs
- Escuchan cambios de estado con BlocBuilder o BlocListener

```dart
class CounterPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => getIt<CounterCubit>(),
      child: CounterView(),
    );
  }
}
```

**BLoCs/Cubits**
- Manejan el estado de la UI
- Contienen la lógica de presentación (no de negocio)
- Llaman a los Use Cases del dominio
- Emiten estados inmutables

```dart
class CounterCubit extends Cubit<CounterState> {
  final IncrementCounterUseCase incrementUseCase;
  
  CounterCubit(this.incrementUseCase) : super(CounterInitial());
  
  void increment() async {
    emit(CounterLoading());
    final result = await incrementUseCase(state.count);
    result.fold(
      (failure) => emit(CounterError(failure.message)),
      (count) => emit(CounterSuccess(count)),
    );
  }
}
```

**Widgets**
- Componentes UI reutilizables
- Sin lógica de negocio
- Pueden tener lógica de presentación simple

### 2. Domain Layer (lib/feature/*/domain/)

**Responsabilidad**: Contener la lógica de negocio pura.

#### Componentes:

**Entities (Entidades)**
- Objetos de negocio puros
- Sin dependencias externas (ni siquiera Flutter)
- Inmutables
- Pueden contener lógica de negocio simple

```dart
class User {
  final String id;
  final String name;
  final String email;
  
  const User({
    required this.id,
    required this.name,
    required this.email,
  });
  
  bool get hasValidEmail => email.contains('@');
}
```

**Use Cases (Casos de Uso)**
- Encapsulan una operación de negocio específica
- Una clase = una acción
- Orquestan el flujo entre entidades y repositorios
- Independientes de la UI

```dart
class GetUserUseCase {
  final UserRepository repository;
  
  GetUserUseCase(this.repository);
  
  Future<Either<Failure, User>> call(String userId) async {
    return await repository.getUser(userId);
  }
}
```

**Repository Interfaces**
- Definen contratos para acceso a datos
- Abstracciones (interfaces/clases abstractas)
- No implementan lógica, solo definen métodos

```dart
abstract class UserRepository {
  Future<Either<Failure, User>> getUser(String id);
  Future<Either<Failure, List<User>>> getUsers();
  Future<Either<Failure, void>> saveUser(User user);
}
```

### 3. Data Layer (lib/feature/*/data/)

**Responsabilidad**: Implementar acceso a fuentes de datos.

#### Componentes:

**Models (Modelos)**
- Extensión de Entities con capacidades de serialización
- Conversión desde/hacia JSON
- Mapeo a Entities

```dart
class UserModel extends User {
  UserModel({
    required String id,
    required String name,
    required String email,
  }) : super(id: id, name: name, email: email);
  
  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'],
      name: json['name'],
      email: json['email'],
    );
  }
  
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
    };
  }
  
  User toEntity() {
    return User(id: id, name: name, email: email);
  }
}
```

**Data Sources**
- Implementaciones concretas de acceso a datos
- Remote: APIs, servicios web
- Local: Base de datos, SharedPreferences, archivos

```dart
abstract class UserRemoteDataSource {
  Future<UserModel> getUser(String id);
}

class UserRemoteDataSourceImpl implements UserRemoteDataSource {
  final http.Client client;
  
  UserRemoteDataSourceImpl(this.client);
  
  @override
  Future<UserModel> getUser(String id) async {
    final response = await client.get(
      Uri.parse('https://api.example.com/users/$id'),
    );
    
    if (response.statusCode == 200) {
      return UserModel.fromJson(json.decode(response.body));
    } else {
      throw ServerException();
    }
  }
}
```

**Repository Implementations**
- Implementan las interfaces definidas en Domain
- Coordinan entre data sources
- Manejan caché y estrategias de datos
- Convierten Models a Entities
- Manejan errores y excepciones

```dart
class UserRepositoryImpl implements UserRepository {
  final UserRemoteDataSource remoteDataSource;
  final UserLocalDataSource localDataSource;
  
  UserRepositoryImpl({
    required this.remoteDataSource,
    required this.localDataSource,
  });
  
  @override
  Future<Either<Failure, User>> getUser(String id) async {
    try {
      final userModel = await remoteDataSource.getUser(id);
      await localDataSource.cacheUser(userModel);
      return Right(userModel.toEntity());
    } on ServerException {
      return Left(ServerFailure());
    } on NetworkException {
      try {
        final cachedUser = await localDataSource.getCachedUser(id);
        return Right(cachedUser.toEntity());
      } on CacheException {
        return Left(CacheFailure());
      }
    }
  }
}
```

## 🔗 Dependency Injection

Usamos **GetIt** e **Injectable** para manejo de dependencias.

### Setup

El archivo `lib/core/di/injector.dart` configura todas las dependencias:

```dart
@InjectableInit()
void configureDependencies() {
  getIt.init();
}
```

### Registro de Dependencias

**Singleton** - Una única instancia durante toda la vida de la app:
```dart
@singleton
class ApiClient {
  // ...
}
```

**LazySingleton** - Se crea solo cuando se solicita por primera vez:
```dart
@lazySingleton
class DatabaseHelper {
  // ...
}
```

**Factory** - Nueva instancia cada vez:
```dart
@injectable
class GetUserUseCase {
  final UserRepository repository;
  GetUserUseCase(this.repository);
}
```

**Named Instances** - Múltiples implementaciones:
```dart
@Named('remote')
@injectable
class RemoteUserDataSource implements UserDataSource {
  // ...
}

@Named('local')
@injectable
class LocalUserDataSource implements UserDataSource {
  // ...
}
```

## 🧭 Routing

Usamos **GoRouter** para navegación declarativa.

### Configuración

```dart
final router = GoRouter(
  routes: [
    GoRoute(
      path: '/',
      builder: (context, state) => HomePage(),
    ),
    GoRoute(
      path: '/user/:id',
      builder: (context, state) {
        final userId = state.pathParameters['id']!;
        return UserDetailPage(userId: userId);
      },
    ),
  ],
);
```

### Navegación

```dart
// Push
context.push('/user/123');

// Go (reemplaza)
context.go('/home');

// Pop
context.pop();

// Con parámetros
context.push('/user/123', extra: {'highlight': true});
```

## 🎯 State Management

Usamos **BLoC/Cubit** para manejo de estado.

### Cubit (Recomendado para estado simple)

```dart
class CounterCubit extends Cubit<int> {
  CounterCubit() : super(0);
  
  void increment() => emit(state + 1);
  void decrement() => emit(state - 1);
}
```

### BLoC (Para flujos complejos)

```dart
// Events
abstract class CounterEvent {}
class Increment extends CounterEvent {}
class Decrement extends CounterEvent {}

// States
abstract class CounterState {}
class CounterInitial extends CounterState {}
class CounterValue extends CounterState {
  final int value;
  CounterValue(this.value);
}

// BLoC
class CounterBloc extends Bloc<CounterEvent, CounterState> {
  CounterBloc() : super(CounterInitial()) {
    on<Increment>((event, emit) {
      final current = state is CounterValue ? (state as CounterValue).value : 0;
      emit(CounterValue(current + 1));
    });
  }
}
```

### En la UI

```dart
BlocBuilder<CounterCubit, int>(
  builder: (context, count) {
    return Text('Count: $count');
  },
)

BlocListener<CounterCubit, int>(
  listener: (context, count) {
    if (count == 10) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('¡Llegaste a 10!')),
      );
    }
  },
  child: ...,
)
```

## 🌍 Internacionalización

### Archivos ARB

Localización en `lib/core/l10n/`:

```arb
{
  "@@locale": "en",
  "appTitle": "My App",
  "@appTitle": {
    "description": "The title of the application"
  },
  "hello": "Hello {name}",
  "@hello": {
    "description": "Greeting message",
    "placeholders": {
      "name": {
        "type": "String"
      }
    }
  }
}
```

### Uso

```dart
Text(AppLocalizations.of(context)!.appTitle)
Text(AppLocalizations.of(context)!.hello('Juan'))
```

## ⚡ Mejores Prácticas

### 1. Dependency Rule

Las dependencias siempre apuntan hacia adentro:
- Presentation → Domain ✅
- Data → Domain ✅
- Domain → Data ❌
- Domain → Presentation ❌

### 2. Entities vs Models

- **Entities**: Objetos de negocio puros (Domain)
- **Models**: Entities + serialización (Data)

### 3. Use Cases

- Un use case = una acción
- Nombres descriptivos: `GetUserUseCase`, `LoginUserUseCase`
- Método `call()` para ejecutar

### 4. Error Handling

Usa `Either` de `dartz` para manejar éxito/error:

```dart
Future<Either<Failure, User>> getUser(String id);
```

### 5. Testing

Cada capa debe tener tests:
- **Domain**: Unit tests (sin dependencias)
- **Data**: Unit tests (con mocks)
- **Presentation**: Widget tests + Unit tests para BLoCs

## 📚 Recursos

- [Clean Architecture - Uncle Bob](https://blog.cleancoder.com/uncle-bob/2012/08/13/the-clean-architecture.html)
- [Flutter BLoC](https://bloclibrary.dev/)
- [GetIt](https://pub.dev/packages/get_it)
- [GoRouter](https://pub.dev/packages/go_router)
