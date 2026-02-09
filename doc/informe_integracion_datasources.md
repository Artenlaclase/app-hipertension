# Informe de Integración de DataSources — HTApp

**Fecha:** Junio 2025  
**Versión:** 3.0  
**Autor:** GitHub Copilot  

---

## 1. Resumen Ejecutivo

Se completó la integración de las pantallas de **Medicamentos** e **Hidratación** con sus respectivas fuentes de datos siguiendo la arquitectura limpia (Clean Architecture) del proyecto:

| Módulo | Fuente de datos | Estado |
|---|---|---|
| Medicamentos | API remota (`/medications`, `/medication-alarms`, `/medication-adherence`) | ✅ Conectado |
| Hidratación | SQLite local (`htapp.db`) | ✅ Conectado |

---

## 2. Arquitectura Implementada

```
Presentation → Domain (Use Cases + Repositories) → Data (Implementations + DataSources)
```

### 2.1 Capa de Dominio (contratos)

#### Medicamentos — `MedicationRepository`
- `getMedications()` → `Either<Failure, List<Medication>>`
- `createMedication(medication)` → `Either<Failure, Medication>`
- `deleteMedication(id)` → `Either<Failure, void>`
- `logDose(medicationId, scheduledTime, wasTaken)` → `Either<Failure, MedicationDose>`
- `getDoseLogs(medicationId)` → `Either<Failure, List<MedicationDose>>`
- `getAdherence(medicationId)` → `Either<Failure, double>`

#### Hidratación — `HydrationRepository`
- `getRecordsByDate(date)` → `Either<Failure, List<HydrationRecord>>`
- `addRecord(record)` → `Either<Failure, HydrationRecord>`
- `deleteRecord(id)` → `Either<Failure, void>`
- `getDailyGoal()` → `Either<Failure, int>`
- `setDailyGoal(ml)` → `Either<Failure, void>`

### 2.2 Casos de Uso Creados

| Caso de uso | Parámetro | Retorno |
|---|---|---|
| `GetMedications` | `NoParams` | `List<Medication>` |
| `CreateMedication` | `Medication` | `Medication` |
| `DeleteMedication` | `String` (id) | `void` |
| `LogMedicationDose` | `LogDoseParams` | `MedicationDose` |
| `GetHydrationRecords` | `DateTime` | `List<HydrationRecord>` |
| `AddHydrationRecord` | `HydrationRecord` | `HydrationRecord` |
| `DeleteHydrationRecord` | `String` (id) | `void` |

---

## 3. Medicamentos — Datasource Remoto (API)

### 3.1 Endpoints Utilizados

| Operación | Método | Endpoint |
|---|---|---|
| Listar medicamentos | `GET` | `/medications` |
| Crear medicamento | `POST` | `/medications` |
| Eliminar medicamento | `DELETE` | `/medications/{id}` |
| Crear alarma | `POST` | `/medication-alarms` |
| Registrar toma/omisión | `POST` | `/medication-adherence` |
| Consultar adherencia | `GET` | `/medication-adherence/{id}` |

### 3.2 Conversión Model → Entity

El `MedicationRepositoryImpl` convierte `MedicationModel` (API) → `Medication` (dominio):

- **Frecuencia:** Extrae horas del campo `instructions` mediante regex `Cada (\d+)h` (default: 8h).
- **Duración:** Analiza texto de `instructions` para mapear a `TreatmentDuration` enum (7 días, 15 días, 30 días, próximo control, crónico).
- **Hora de inicio:** Toma la hora de la primera alarma asociada al medicamento.
- **Dosis registradas:** Convierte los `logs` del modelo a `MedicationDose` entities.

### 3.3 Funcionalidad en Pantalla (`MedicationTab`)

- **Carga inicial:** `initState()` → `GetMedications` → muestra spinner mientras carga.
- **Agregar medicamento:** Diálogo → `CreateMedication` → crea alarma en API → recarga lista.
- **Registrar toma:** Toggle → `LogMedicationDose` → actualización optimista con revert en error.
- **Eliminar:** Deslizar → `DeleteMedication` → remoción optimista con revert en error.
- **Estados:** Loading spinner, estado de error con botón "Reintentar", lista vacía.

---

## 4. Hidratación — Datasource Local (SQLite)

### 4.1 Base de Datos

**Archivo:** `htapp.db` (gestionado por `DatabaseHelper` singleton)

**Tablas creadas:**

```sql
CREATE TABLE hydration_records (
  id TEXT PRIMARY KEY,
  liquid_type TEXT NOT NULL,   -- water, infusion, juice, broth, other
  amount_ml INTEGER NOT NULL,
  note TEXT,
  timestamp TEXT NOT NULL       -- ISO 8601
);

CREATE TABLE hydration_settings (
  key TEXT PRIMARY KEY,
  value TEXT NOT NULL
);
-- Insert default: daily_goal_ml = 2000
```

### 4.2 `HydrationLocalDataSourceImpl`

| Método | Descripción |
|---|---|
| `getRecordsByDate(date)` | Filtra registros del día (entre inicio y fin del día) |
| `insertRecord(model)` | Inserta con `ConflictAlgorithm.replace` |
| `deleteRecord(id)` | Elimina por ID |
| `getDailyGoal()` | Lee `daily_goal_ml` de settings |
| `setDailyGoal(ml)` | Actualiza `daily_goal_ml` en settings |

### 4.3 `HydrationRecordModel`

Conversiones disponibles:
- `fromMap(Map)` / `toMap()` — para SQLite
- `fromEntity(HydrationRecord)` / `toEntity()` — para dominio

### 4.4 Funcionalidad en Pantalla (`HydrationTab`)

- **Carga inicial:** `initState()` → `GetHydrationRecords(DateTime.now())` → spinner.
- **Registro rápido:** Botones de 1 vaso de agua (250ml), 1 taza de té (200ml), 1 jugo (200ml).
- **Registro personalizado:** FAB → `AddHydrationDialog` → `AddHydrationRecord`.
- **Eliminar:** Icono en cada registro → `DeleteHydrationRecord`.
- **Visualización:** Círculo de progreso (meta 2000ml), resumen por tipo, historial del día.

---

## 5. Inyección de Dependencias

Registros añadidos en `injection_container.dart`:

```dart
// Core / Local DB
sl.registerLazySingleton(() => DatabaseHelper());

// Data Sources
sl.registerLazySingleton<HydrationLocalDataSource>(
  () => HydrationLocalDataSourceImpl(databaseHelper: sl<DatabaseHelper>()),
);

// Repositories
sl.registerLazySingleton<MedicationRepository>(
  () => MedicationRepositoryImpl(
    remoteDataSource: sl<MedicationRemoteDataSource>(),
    networkInfo: sl<NetworkInfo>(),
  ),
);
sl.registerLazySingleton<HydrationRepository>(
  () => HydrationRepositoryImpl(localDataSource: sl<HydrationLocalDataSource>()),
);

// Use Cases (7 nuevos)
sl.registerLazySingleton(() => GetMedications(sl<MedicationRepository>()));
sl.registerLazySingleton(() => CreateMedication(sl<MedicationRepository>()));
sl.registerLazySingleton(() => DeleteMedication(sl<MedicationRepository>()));
sl.registerLazySingleton(() => LogMedicationDose(sl<MedicationRepository>()));
sl.registerLazySingleton(() => GetHydrationRecords(sl<HydrationRepository>()));
sl.registerLazySingleton(() => AddHydrationRecord(sl<HydrationRepository>()));
sl.registerLazySingleton(() => DeleteHydrationRecord(sl<HydrationRepository>()));
```

---

## 6. Archivos Creados / Modificados

### Nuevos (14 archivos)

| Capa | Archivo | Propósito |
|---|---|---|
| Core | `core/services/database_helper.dart` | Singleton SQLite |
| Domain | `domain/repositories/medication_repository.dart` | Contrato repositorio |
| Domain | `domain/repositories/hydration_repository.dart` | Contrato repositorio |
| Domain | `domain/usecases/get_medications.dart` | Caso de uso |
| Domain | `domain/usecases/create_medication.dart` | Caso de uso |
| Domain | `domain/usecases/delete_medication.dart` | Caso de uso |
| Domain | `domain/usecases/log_medication_dose.dart` | Caso de uso |
| Domain | `domain/usecases/get_hydration_records.dart` | Caso de uso |
| Domain | `domain/usecases/add_hydration_record.dart` | Caso de uso |
| Domain | `domain/usecases/delete_hydration_record.dart` | Caso de uso |
| Data | `data/repositories/medication_repository_impl.dart` | Impl → API remota |
| Data | `data/repositories/hydration_repository_impl.dart` | Impl → SQLite local |
| Data | `data/datasources/hydration_local_datasource.dart` | CRUD SQLite |
| Data | `data/models/hydration_record_model.dart` | Modelo SQLite ↔ Entity |

### Modificados (3 archivos)

| Archivo | Cambio |
|---|---|
| `injection_container.dart` | +12 registros (1 DB, 1 datasource, 2 repos, 7 use cases) |
| `presentation/screens/medication_tab.dart` | Conectado a API con estados loading/error/optimistic |
| `presentation/screens/hydration_tab.dart` | Conectado a SQLite con estados loading y async handlers |

### Corrección adicional

| Archivo | Cambio |
|---|---|
| `presentation/widgets/add_medication_dialog.dart` | Fix nullable `TreatmentDuration?` en `RadioGroup.onChanged` |

---

## 7. Resultado del Análisis

```
flutter analyze → No issues found!
```

---

## 8. Notas Técnicas

- **Medicamentos** requiere conexión a internet (API). Si la red no está disponible, se retorna `ServerFailure`.
- **Hidratación** funciona 100 % offline (SQLite local).
- Las pantallas usan **actualizaciones optimistas**: la UI se actualiza de inmediato y se revierte si la operación falla.
- La base de datos SQLite se crea automáticamente en el primer acceso gracias al patrón singleton de `DatabaseHelper`.
- La meta diaria de hidratación por defecto es **2000 ml** y es configurable vía `hydration_settings`.
