# Guía de Contribución

¡Gracias por tu interés en contribuir a este proyecto! Este documento proporciona pautas para contribuir de manera efectiva.

## 📋 Tabla de Contenidos

- [Código de Conducta](#código-de-conducta)
- [Cómo Contribuir](#cómo-contribuir)
- [Proceso de Desarrollo](#proceso-de-desarrollo)
- [Estándares de Código](#estándares-de-código)
- [Guía de Commits](#guía-de-commits)
- [Pull Requests](#pull-requests)
- [Reportar Bugs](#reportar-bugs)
- [Solicitar Features](#solicitar-features)

## Código de Conducta

Este proyecto se adhiere a un código de conducta. Al participar, se espera que mantengas este código. Por favor reporta comportamiento inaceptable.

## Cómo Contribuir

### 1. Fork el Repositorio

```bash
# Fork vía GitHub UI, luego clona tu fork
git clone https://github.com/TU_USUARIO/flutter-clean-architecture.git
cd flutter-clean-architecture
```

### 2. Configura el Repositorio Upstream

```bash
git remote add upstream https://github.com/MiguelHG2351/flutter-clean-architecture.git
```

### 3. Crea una Rama

```bash
# Actualiza tu main
git checkout main
git pull upstream main

# Crea una nueva rama
git checkout -b feature/mi-nueva-feature
# o
git checkout -b fix/mi-fix
```

### 4. Realiza tus Cambios

Asegúrate de seguir los [Estándares de Código](#estándares-de-código).

### 5. Ejecuta Tests

```bash
# Ejecuta todos los tests
flutter test

# Verifica el análisis
flutter analyze

# Formatea el código
dart format lib/ test/
```

### 6. Commit tus Cambios

Sigue la [Guía de Commits](#guía-de-commits).

```bash
git add .
git commit -m "feat: agrega nueva funcionalidad"
```

### 7. Push a tu Fork

```bash
git push origin feature/mi-nueva-feature
```

### 8. Abre un Pull Request

Ve a GitHub y abre un Pull Request desde tu rama hacia `main`.

## Proceso de Desarrollo

### Setup Local

1. **Instala Flutter**
   
   Asegúrate de tener Flutter ^3.7.2 instalado:
   ```bash
   flutter doctor
   ```

2. **Instala Dependencias**
   
   ```bash
   flutter pub get
   ```

3. **Genera Código**
   
   ```bash
   flutter pub run build_runner build --delete-conflicting-outputs
   ```

4. **Ejecuta la App**
   
   ```bash
   flutter run
   ```

### Workflow de Desarrollo

1. **Siempre trabaja en una rama nueva**
   - `feature/` para nuevas características
   - `fix/` para correcciones
   - `docs/` para documentación
   - `refactor/` para refactorización
   - `test/` para tests

2. **Mantén tu rama actualizada**
   
   ```bash
   git fetch upstream
   git rebase upstream/main
   ```

3. **Prueba todo antes de hacer commit**
   
   ```bash
   flutter test
   flutter analyze
   ```

## Estándares de Código

### Arquitectura

Este proyecto sigue **Clean Architecture**. Asegúrate de:

- **Separar las capas**: Domain, Data, Presentation
- **Dependency Rule**: Las dependencias apuntan hacia adentro
- **Single Responsibility**: Una clase, una responsabilidad
- **Usar interfaces**: Para abstraer implementaciones

### Estructura de Features

Todas las features deben seguir esta estructura:

```
lib/feature/mi_feature/
├── data/
│   ├── datasources/
│   │   └── mi_remote_datasource.dart
│   ├── models/
│   │   └── mi_model.dart
│   └── repositories/
│       └── mi_repository_impl.dart
├── domain/
│   ├── entities/
│   │   └── mi_entidad.dart
│   ├── repositories/
│   │   └── mi_repository.dart
│   └── usecases/
│       └── get_mi_data.dart
└── presentation/
    ├── blocs/
    │   ├── mi_cubit.dart
    │   └── mi_state.dart
    ├── pages/
    │   └── mi_page.dart
    └── widgets/
        └── mi_widget.dart
```

### Estilo de Código

1. **Usa `flutter_lints`**
   
   El proyecto ya está configurado. Asegúrate de que `flutter analyze` no muestre errores.

2. **Formatea el código**
   
   ```bash
   dart format lib/ test/
   ```

3. **Nombrado**
   
   - **Archivos**: `snake_case.dart`
   - **Clases**: `PascalCase`
   - **Variables/Funciones**: `camelCase`
   - **Constantes**: `SCREAMING_SNAKE_CASE`

4. **Comentarios**
   
   ```dart
   /// Documentación de la clase o función.
   ///
   /// Descripción más detallada si es necesario.
   class MiClase {
     // Comentario de implementación
     void miMetodo() {}
   }
   ```

### Testing

1. **Tests Obligatorios**
   
   - Unit tests para casos de uso
   - Tests para repositorios
   - Widget tests para widgets complejos

2. **Cobertura**
   
   - Mantén la cobertura alta (objetivo: >80%)
   - Verifica con:
     ```bash
     flutter test --coverage
     ```

3. **Nombrado de Tests**
   
   ```dart
   void main() {
     group('MiUseCase', () {
       test('debería retornar datos cuando todo es exitoso', () {
         // Arrange
         // Act
         // Assert
       });
       
       test('debería lanzar excepción cuando hay error', () {
         // Arrange
         // Act
         // Assert
       });
     });
   }
   ```

## Guía de Commits

Usamos [Conventional Commits](https://www.conventionalcommits.org/):

### Formato

```
<tipo>(<scope>): <descripción>

[cuerpo opcional]

[footer opcional]
```

### Tipos

- **feat**: Nueva característica
- **fix**: Corrección de bug
- **docs**: Cambios en documentación
- **style**: Cambios de formato (no afectan el código)
- **refactor**: Refactorización de código
- **test**: Agregar o modificar tests
- **chore**: Cambios en el build o herramientas

### Ejemplos

```bash
feat(auth): agrega login con Google
fix(counter): corrige incremento doble
docs(readme): actualiza guía de instalación
refactor(user): mejora estructura de repositorio
test(auth): agrega tests para login
```

### Mejores Prácticas

- **Commits atómicos**: Un commit = un cambio lógico
- **Descripción clara**: Explica qué y por qué, no cómo
- **Presente simple**: "agrega" no "agregado"
- **Máximo 72 caracteres** en la primera línea

## Pull Requests

### Antes de Crear el PR

✅ **Checklist:**

- [ ] El código compila sin errores
- [ ] Todos los tests pasan (`flutter test`)
- [ ] El análisis no muestra errores (`flutter analyze`)
- [ ] El código está formateado (`dart format`)
- [ ] Se agregaron tests para nueva funcionalidad
- [ ] La documentación está actualizada
- [ ] Los commits siguen Conventional Commits

### Título del PR

Usa el mismo formato que los commits:

```
feat(auth): implementa login con Google
```

### Descripción del PR

Usa esta plantilla:

```markdown
## Descripción
[Descripción clara de los cambios]

## Tipo de Cambio
- [ ] Bug fix (cambio que corrige un issue)
- [ ] Nueva feature (cambio que agrega funcionalidad)
- [ ] Breaking change (fix o feature que causa que funcionalidad existente no funcione como antes)
- [ ] Documentación

## ¿Cómo se ha probado?
[Describe las pruebas realizadas]

## Checklist
- [ ] Mi código sigue el estilo del proyecto
- [ ] He realizado auto-review de mi código
- [ ] He comentado mi código en áreas difíciles
- [ ] He actualizado la documentación
- [ ] Mis cambios no generan warnings
- [ ] He agregado tests que prueban mi fix/feature
- [ ] Todos los tests pasan localmente

## Screenshots (si aplica)
[Agregar screenshots si hay cambios visuales]
```

### Proceso de Review

1. **CI debe pasar**: GitHub Actions debe completarse exitosamente
2. **Review de código**: Al menos un mantenedor debe aprobar
3. **Resuelve comentarios**: Atiende todo el feedback
4. **Squash commits**: Si hay muchos commits pequeños

## Reportar Bugs

### Antes de Reportar

1. **Busca issues existentes**: Quizá ya fue reportado
2. **Usa la última versión**: Asegúrate de estar actualizado
3. **Reproduce el bug**: Confirma que es reproducible

### Template de Bug Report

```markdown
## Descripción del Bug
[Descripción clara del bug]

## Para Reproducir
Pasos para reproducir:
1. Ve a '...'
2. Click en '...'
3. Scroll hasta '...'
4. Ver error

## Comportamiento Esperado
[Qué esperabas que pasara]

## Comportamiento Actual
[Qué está pasando realmente]

## Screenshots
[Si aplica, agrega screenshots]

## Entorno
- OS: [ej. iOS, Android, Web]
- Flutter version: [ej. 3.7.2]
- Device: [ej. iPhone 14, Pixel 7]

## Contexto Adicional
[Cualquier información adicional]
```

## Solicitar Features

### Template de Feature Request

```markdown
## Descripción de la Feature
[Descripción clara de la feature]

## Problema que Resuelve
[Explica el problema que esta feature resolvería]

## Solución Propuesta
[Describe cómo imaginas la solución]

## Alternativas Consideradas
[Otras soluciones que consideraste]

## Contexto Adicional
[Información adicional, mockups, etc.]
```

---

## 💡 Preguntas

Si tienes preguntas, puedes:

1. Abrir un issue con la etiqueta `question`
2. Buscar en issues cerrados
3. Revisar la documentación existente

---

**¡Gracias por contribuir! 🎉**
