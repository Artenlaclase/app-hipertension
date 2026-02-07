# Informe de Arquitectura - HTApp

**Fecha:** 7 de febrero de 2026  
**Proyecto:** HTApp - Aplicación Móvil Flutter

---

## 1. Resumen

Se implementó la arquitectura base del proyecto HTApp siguiendo los principios de **Clean Architecture (Arquitectura Limpia)**. Esta arquitectura separa las responsabilidades en capas independientes, lo que facilita el mantenimiento, la escalabilidad y las pruebas del código.

---

## 2. Diagrama de Capas

```
┌──────────────────────────────────────────────┐
│              Presentation Layer               │
│  (screens, widgets, bloc/state management)    │
├──────────────────────────────────────────────┤
│                Domain Layer                   │
│    (entities, usecases, repositories)         │
├──────────────────────────────────────────────┤
│                 Data Layer                    │
│  (models, datasources, repository impl)       │
├──────────────────────────────────────────────┤
│                 Core Layer                    │
│  (errors, network, routes, usecases base)     │
└──────────────────────────────────────────────┘
```

---

## 3. Estructura de Carpetas Creada

```
lib/
├── main.dart                    # Punto de entrada de la aplicación
├── injection_container.dart     # Inyección de dependencias (GetIt)
│
├── core/                        # Utilidades y componentes compartidos
│   ├── errors/
│   │   ├── exceptions.dart      # Excepciones personalizadas (ServerException, CacheException)
│   │   └── failures.dart        # Clases de fallo (ServerFailure, CacheFailure)
│   ├── network/
│   │   └── network_info.dart    # Verificación de conectividad a internet
│   ├── routes/
│   │   └── app_router.dart      # Gestión centralizada de rutas/navegación
│   ├── services/                # Servicios compartidos (pendiente de implementar)
│   └── usecases/
│       └── usecase.dart         # Clase base abstracta UseCase<Type, Params>
│
├── data/                        # Capa de datos
│   ├── datasources/             # Fuentes de datos (API remota, base de datos local)
│   ├── models/                  # Modelos de datos con serialización (fromJson/toJson)
│   └── repositories/            # Implementación concreta de repositorios
│
├── domain/                      # Capa de dominio (lógica de negocio pura)
│   ├── entities/                # Entidades del negocio (sin dependencias externas)
│   ├── repositories/            # Contratos/interfaces abstractas de repositorios
│   └── usecases/                # Casos de uso del negocio
│
└── presentation/                # Capa de presentación (UI)
    ├── bloc/                    # Gestión de estado (BLoC/Cubit)
    ├── screens/                 # Pantallas de la aplicación
    └── widgets/                 # Widgets reutilizables
```

---

## 4. Descripción de Capas

### 4.1 Core
Utilidades transversales compartidas por todas las capas:

| Carpeta | Descripción |
|---|---|
| `errors/` | Define `Failure` (errores controlados) y `Exception` (excepciones) personalizados |
| `network/` | Clase `NetworkInfo` que verifica conectividad usando `connectivity_plus` |
| `routes/` | `AppRouter` centraliza la generación de rutas con `onGenerateRoute` |
| `services/` | Servicios compartidos (autenticación, almacenamiento, etc.) |
| `usecases/` | Clase abstracta `UseCase<Type, Params>` que retorna `Future<Either<Failure, Type>>` |

### 4.2 Domain
Núcleo de la aplicación. **No depende de ningún framework externo** (solo Dart puro):

| Carpeta | Descripción |
|---|---|
| `entities/` | Objetos de negocio puros, representan conceptos del dominio |
| `repositories/` | Interfaces abstractas que definen contratos de acceso a datos |
| `usecases/` | Cada caso de uso encapsula una acción específica del negocio |

### 4.3 Data
Implementa los contratos del dominio y gestiona el acceso a datos:

| Carpeta | Descripción |
|---|---|
| `models/` | Extienden entidades con métodos de serialización (`fromJson`, `toJson`) |
| `datasources/` | Fuentes concretas: API remota (`RemoteDataSource`) y caché local (`LocalDataSource`) |
| `repositories/` | Coordinan datasources, manejan errores y verifican conectividad |

### 4.4 Presentation
Interfaz de usuario y gestión de estado:

| Carpeta | Descripción |
|---|---|
| `bloc/` | BLoC/Cubit para gestión de estado reactiva |
| `screens/` | Pantallas completas de la aplicación |
| `widgets/` | Componentes de UI reutilizables entre pantallas |

---

## 5. Archivos Creados

| Archivo | Descripción |
|---|---|
| `lib/injection_container.dart` | Configuración de inyección de dependencias con GetIt |
| `lib/core/usecases/usecase.dart` | Clase abstracta base para todos los casos de uso |
| `lib/core/errors/failures.dart` | Clases `ServerFailure` y `CacheFailure` basadas en `Equatable` |
| `lib/core/errors/exceptions.dart` | Excepciones `ServerException` y `CacheException` |
| `lib/core/network/network_info.dart` | Implementación de verificación de conectividad |
| `lib/core/routes/app_router.dart` | Router centralizado con `generateRoute` |

---

## 6. Dependencias Instaladas

| Paquete | Versión | Propósito |
|---|---|---|
| `dartz` | 0.10.1 | Programación funcional (`Either`, `Option`) para manejo de errores |
| `equatable` | 2.0.8 | Simplifica la comparación de igualdad entre objetos |
| `get_it` | 9.2.0 | Service Locator para inyección de dependencias |
| `connectivity_plus` | 7.0.0 | Verificación del estado de conectividad de red |

---

## 7. Flujo de Datos

```
UI (Screen) → BLoC/Cubit → UseCase → Repository (interfaz) → Repository (impl) → DataSource
```

1. La **pantalla** dispara un evento al **BLoC/Cubit**.
2. El **BLoC** ejecuta un **caso de uso** del dominio.
3. El **caso de uso** llama al **repositorio** (interfaz abstracta).
4. La **implementación del repositorio** decide la fuente de datos:
   - Si hay conexión → **DataSource remoto** (API)
   - Si no hay conexión → **DataSource local** (caché)
5. Los datos fluyen de vuelta como `Either<Failure, Entity>`.

---

## 8. Próximos Pasos

- [ ] Definir las **entidades** del dominio según los casos de uso del sistema
- [ ] Implementar los **casos de uso** específicos
- [ ] Crear los **modelos de datos** con serialización JSON
- [ ] Configurar las **fuentes de datos** (API REST, base de datos local)
- [ ] Implementar los **BLoCs/Cubits** para gestión de estado
- [ ] Diseñar e implementar las **pantallas** de la aplicación
- [ ] Completar el **injection_container.dart** con todas las dependencias
- [ ] Agregar pruebas unitarias para cada capa
