# Mejores Prácticas

Esta guía contiene las mejores prácticas y convenciones para el desarrollo en este proyecto.

## 📋 Tabla de Contenidos

- [Estructura de Código](#estructura-de-código)
- [Nombrado](#nombrado)
- [Estado y BLoC](#estado-y-bloc)
- [Dependency Injection](#dependency-injection)
- [Error Handling](#error-handling)
- [Performance](#performance)
- [Testing](#testing)
- [Git](#git)

## Estructura de Código

### Organización de Archivos

**✅ Hacer:**
```
lib/feature/user/
├── data/
├── domain/
└── presentation/
```

**❌ Evitar:**
```
lib/
├── blocs/
├── models/
└── screens/
```

### Imports

**✅ Hacer:**
```dart
// Dart SDK
import 'dart:async';

// Flutter
import 'package:flutter/material.dart';

// Paquetes externos
import 'package:bloc/bloc.dart';
import 'package:get_it/get_it.dart';

// Imports internos
import 'package:flutter_clean_architecture/core/di/injector.dart';
import 'package:flutter_clean_architecture/feature/user/domain/entities/user.dart';
```

**❌ Evitar:**
```dart
import 'package:flutter_clean_architecture/feature/user/domain/entities/user.dart';
import 'package:flutter/material.dart';
import 'package:bloc/bloc.dart';
import 'dart:async';
```

### Tamaño de Archivos

- **Máximo 300 líneas** por archivo
- Si es más grande, considera dividirlo
- Una clase por archivo (generalmente)

## Nombrado

### Archivos

**✅ Hacer:**
```
user_repository.dart
get_user_use_case.dart
user_detail_page.dart
```

**❌ Evitar:**
```
UserRepository.dart
getUserUseCase.dart
user-detail-page.dart
```

### Clases

**✅ Hacer:**
```dart
class UserRepository { }
class GetUserUseCase { }
class UserDetailPage extends StatelessWidget { }
```

**❌ Evitar:**
```dart
class userRepository { }
class get_user_use_case { }
class User_Detail_Page extends StatelessWidget { }
```

### Variables y Funciones

**✅ Hacer:**
```dart
final userName = 'John';
void getUserData() { }
bool isUserActive = true;
```

**❌ Evitar:**
```dart
final UserName = 'John';
void get_user_data() { }
bool is_user_active = true;
```

### Constantes

**✅ Hacer:**
```dart
const String API_BASE_URL = 'https://api.example.com';
const int MAX_RETRY_COUNT = 3;
```

**❌ Evitar:**
```dart
const String apiBaseUrl = 'https://api.example.com';
const int maxRetryCount = 3;
```

### BLoCs y Cubits

**✅ Hacer:**
```dart
class UserCubit extends Cubit<UserState> { }
class AuthenticationBloc extends Bloc<AuthEvent, AuthState> { }
```

**Nombrado de Estados:**
```dart
// Estados
class UserInitial extends UserState { }
class UserLoading extends UserState { }
class UserSuccess extends UserState { }
class UserError extends UserState { }

// Eventos (para BLoC)
class UserRequested extends UserEvent { }
class UserRefreshed extends UserEvent { }
```

## Estado y BLoC

### Cuándo Usar Cubit vs BLoC

**Usa Cubit cuando:**
- El estado es simple
- No necesitas rastrear eventos
- Las transiciones son directas

```dart
class CounterCubit extends Cubit<int> {
  CounterCubit() : super(0);
  
  void increment() => emit(state + 1);
}
```

**Usa BLoC cuando:**
- Necesitas historial de eventos
- Lógica compleja de transiciones
- Múltiples fuentes de eventos

```dart
class UserBloc extends Bloc<UserEvent, UserState> {
  UserBloc() : super(UserInitial()) {
    on<UserRequested>(_onUserRequested);
    on<UserRefreshed>(_onUserRefreshed);
  }
}
```

### Estados Inmutables

**✅ Hacer:**
```dart
class UserState extends Equatable {
  final User? user;
  final bool isLoading;
  
  const UserState({this.user, this.isLoading = false});
  
  UserState copyWith({User? user, bool? isLoading}) {
    return UserState(
      user: user ?? this.user,
      isLoading: isLoading ?? this.isLoading,
    );
  }
  
  @override
  List<Object?> get props => [user, isLoading];
}
```

**❌ Evitar:**
```dart
class UserState {
  User? user;
  bool isLoading;
  
  UserState({this.user, this.isLoading = false});
}
```

### BlocProvider

**✅ Hacer:**
```dart
class UserPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => getIt<UserCubit>()..loadUser(),
      child: UserView(),
    );
  }
}
```

**❌ Evitar:**
```dart
class UserPage extends StatefulWidget {
  @override
  _UserPageState createState() => _UserPageState();
}

class _UserPageState extends State<UserPage> {
  late UserCubit cubit;
  
  @override
  void initState() {
    super.initState();
    cubit = UserCubit(); // ❌ No usar new
  }
}
```

### BlocBuilder vs BlocListener

**BlocBuilder** - Para reconstruir UI:
```dart
BlocBuilder<UserCubit, UserState>(
  builder: (context, state) {
    if (state is UserLoading) {
      return CircularProgressIndicator();
    }
    return UserWidget(state.user);
  },
)
```

**BlocListener** - Para efectos secundarios:
```dart
BlocListener<UserCubit, UserState>(
  listener: (context, state) {
    if (state is UserError) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(state.message)),
      );
    }
  },
  child: UserWidget(),
)
```

**BlocConsumer** - Para ambos:
```dart
BlocConsumer<UserCubit, UserState>(
  listener: (context, state) {
    // Efectos secundarios
  },
  builder: (context, state) {
    // Reconstruir UI
  },
)
```

## Dependency Injection

### Registro

**✅ Hacer:**
```dart
@module
abstract class NetworkModule {
  @lazySingleton
  Dio get dio => Dio();
}

@Injectable(as: UserRepository)
class UserRepositoryImpl implements UserRepository {
  final UserRemoteDataSource remoteDataSource;
  
  UserRepositoryImpl(this.remoteDataSource);
}
```

**❌ Evitar:**
```dart
// No hacer new manualmente
final repository = UserRepositoryImpl(
  UserRemoteDataSourceImpl(Dio()),
);
```

### Uso

**✅ Hacer:**
```dart
class UserPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => getIt<UserCubit>(),
      child: UserView(),
    );
  }
}
```

**❌ Evitar:**
```dart
class UserPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => UserCubit(
        GetUserUseCase(
          UserRepositoryImpl(
            UserRemoteDataSourceImpl(Dio()),
          ),
        ),
      ),
      child: UserView(),
    );
  }
}
```

## Error Handling

### Failures y Exceptions

**Domain Layer** - Usa Failures:
```dart
abstract class Failure {
  final String message;
  const Failure(this.message);
}

class ServerFailure extends Failure {
  const ServerFailure([String message = 'Server error']) : super(message);
}

class NetworkFailure extends Failure {
  const NetworkFailure([String message = 'Network error']) : super(message);
}
```

**Data Layer** - Usa Exceptions:
```dart
class ServerException implements Exception {
  final String message;
  const ServerException([this.message = 'Server error']);
}

class NetworkException implements Exception {
  final String message;
  const NetworkException([this.message = 'Network error']);
}
```

### Either Pattern

**✅ Hacer:**
```dart
Future<Either<Failure, User>> getUser(String id) async {
  try {
    final user = await remoteDataSource.getUser(id);
    return Right(user);
  } on ServerException catch (e) {
    return Left(ServerFailure(e.message));
  } on NetworkException catch (e) {
    return Left(NetworkFailure(e.message));
  }
}
```

### En el BLoC

**✅ Hacer:**
```dart
void loadUser(String id) async {
  emit(UserLoading());
  
  final result = await getUserUseCase(id);
  
  result.fold(
    (failure) => emit(UserError(failure.message)),
    (user) => emit(UserSuccess(user)),
  );
}
```

## Performance

### Const Constructors

**✅ Hacer:**
```dart
class UserWidget extends StatelessWidget {
  const UserWidget({Key? key}) : super(key: key);
  
  @override
  Widget build(BuildContext context) {
    return const Text('Hello');
  }
}
```

### ListView.builder

**✅ Hacer:**
```dart
ListView.builder(
  itemCount: users.length,
  itemBuilder: (context, index) {
    return UserTile(user: users[index]);
  },
)
```

**❌ Evitar:**
```dart
ListView(
  children: users.map((user) => UserTile(user: user)).toList(),
)
```

### Keys

**✅ Usar keys cuando:**
- Items pueden reordenarse
- Items pueden añadirse/eliminarse
- Necesitas preservar estado

```dart
ListView.builder(
  itemBuilder: (context, index) {
    return UserTile(
      key: ValueKey(users[index].id),
      user: users[index],
    );
  },
)
```

### Avoid Rebuilds

**✅ Hacer:**
```dart
BlocBuilder<UserCubit, UserState>(
  buildWhen: (previous, current) => previous.user != current.user,
  builder: (context, state) {
    return UserWidget(state.user);
  },
)
```

## Testing

### Estructura de Tests

```dart
void main() {
  group('GetUserUseCase', () {
    late GetUserUseCase useCase;
    late MockUserRepository mockRepository;
    
    setUp(() {
      mockRepository = MockUserRepository();
      useCase = GetUserUseCase(mockRepository);
    });
    
    test('should return User when repository call is successful', () async {
      // Arrange
      final expectedUser = User(id: '1', name: 'John');
      when(() => mockRepository.getUser('1'))
          .thenAnswer((_) async => Right(expectedUser));
      
      // Act
      final result = await useCase('1');
      
      // Assert
      expect(result, Right(expectedUser));
      verify(() => mockRepository.getUser('1')).called(1);
    });
  });
}
```

### Nombrado de Tests

**✅ Hacer:**
```dart
test('should return User when repository call is successful', () {});
test('should return ServerFailure when repository throws ServerException', () {});
test('should emit [Loading, Success] when data is fetched successfully', () {});
```

**❌ Evitar:**
```dart
test('test 1', () {});
test('getUserSuccess', () {});
```

### Mocks

**✅ Hacer:**
```dart
@GenerateMocks([UserRepository])
void main() {
  late MockUserRepository mockRepository;
  
  setUp(() {
    mockRepository = MockUserRepository();
  });
}
```

### Widget Tests

**✅ Hacer:**
```dart
testWidgets('should display loading indicator when state is loading', (tester) async {
  // Arrange
  when(() => mockCubit.state).thenReturn(UserLoading());
  
  // Act
  await tester.pumpWidget(
    MaterialApp(
      home: BlocProvider<UserCubit>.value(
        value: mockCubit,
        child: UserPage(),
      ),
    ),
  );
  
  // Assert
  expect(find.byType(CircularProgressIndicator), findsOneWidget);
});
```

## Git

### Commits

**✅ Hacer:**
```bash
git commit -m "feat(auth): add Google login"
git commit -m "fix(user): correct profile image loading"
git commit -m "docs(readme): update installation steps"
```

**❌ Evitar:**
```bash
git commit -m "changes"
git commit -m "fix bug"
git commit -m "WIP"
```

### Branches

**✅ Hacer:**
```bash
feature/user-authentication
fix/profile-image-crash
docs/api-documentation
refactor/user-repository
```

**❌ Evitar:**
```bash
my-branch
fix
feature
```

### Pull Requests

**✅ Checklist antes de crear PR:**
- [ ] Todos los tests pasan
- [ ] Código analizado (`flutter analyze`)
- [ ] Código formateado (`dart format`)
- [ ] Commits siguen Conventional Commits
- [ ] PR tiene descripción clara
- [ ] Branch actualizada con main

---

## 📚 Recursos Adicionales

- [Effective Dart](https://dart.dev/guides/language/effective-dart)
- [Flutter Best Practices](https://flutter.dev/docs/development/best-practices)
- [BLoC Best Practices](https://bloclibrary.dev/#/coreconcepts?id=best-practices)
