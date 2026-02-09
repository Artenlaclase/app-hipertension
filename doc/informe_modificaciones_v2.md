# Informe de Modificaciones realizadas a HTApp

**Fecha:** 8 de febrero de 2026  
**Proyecto:** HTApp - Aplicación de salud para hipertensión  
**Arquitectura:** Clean Architecture (Domain, Data, Presentation)

---

## Resumen de Cambios

Se realizaron **4 grupos principales de cambios** para cubrir las necesidades reportadas:

1. Actualización de dependencias críticas en `pubspec.yaml`
2. Nueva sección **Medicamentos** con alertas y control de toma
3. Nueva sección **Hidratación** con registro de líquidos
4. Corrección del bug de **nombre duplicado** en registro/onboarding

---

## 1. Dependencias Actualizadas (`pubspec.yaml`)

Se agregaron las librerías críticas faltantes para cumplir con los requerimientos del SRS:

| Dependencia | Versión | Propósito | Requerimiento |
|---|---|---|---|
| `sqflite` | ^2.3.0 | Base de datos local SQLite | RF-10, RNF-02 |
| `path` | ^1.9.0 | Manejo de rutas para SQLite | RF-10 |
| `fl_chart` | ^0.66.0 | Gráficos (presión, etc.) | RF-02 |
| `flutter_local_notifications` | ^18.0.0 | Notificaciones/alarmas locales | RF-09 |
| `timezone` | ^0.9.2 | Zonas horarias para alarmas | RF-09 |
| `image_picker` | ^1.0.7 | Cámara/galería para fotos | RF-06 |
| `flutter_bloc` | ^8.1.3 | Gestión de estado (BLoC) | Arquitectura |

### Notas sobre gestión de estado
- Se detectó que el proyecto ya usa `equatable` y `dartz`, patrón típico de BLoC.
- Se añadió `flutter_bloc` como gestor de estado oficial.
- Se puede migrar progresivamente de StatefulWidget a Cubit/BLoC por pantalla.

---

## 2. Sección de Medicamentos (Alertas)

### Archivos creados:

#### `lib/domain/entities/medication.dart`
- **Entidad `Medication`:** Nombre, dosis, frecuencia en horas, hora de inicio, duración del tratamiento, fecha fin, estado activo.
- **Entidad `MedicationDose`:** Representa una dosis individual con hora programada y si fue tomada.
- **Enum `TreatmentDuration`:** 7 días, 15 días, 30 días, próximo control médico, crónico.
- **Cálculo automático** de `nextDoseTime` (próxima dosis) y `endDate` según duración.

#### `lib/presentation/screens/medication_tab.dart`
- Pestaña completa de medicamentos con:
  - **Tarjeta de adherencia del día:** Muestra porcentaje de dosis tomadas vs programadas.
  - **Lista de medicamentos** con nombre, dosis, frecuencia e indicador de duración.
  - **Dosis de hoy por medicamento:** Chips interactivos para marcar si se tomó cada dosis.
  - **Código de colores:** ✅ Verde = tomado, 🔴 Rojo = hora pasada sin tomar, ⚪ Gris = pendiente.
  - **Menú de eliminación** por medicamento.
  - **Estado vacío** informativo cuando no hay medicamentos.
  - **Diálogo informativo** de cómo funciona el sistema.

#### `lib/presentation/widgets/add_medication_dialog.dart`
- Diálogo completo para agregar un nuevo medicamento:
  - Campo de **nombre** del medicamento.
  - Campo de **dosis** (ej: 50mg, 1 tableta).
  - **Frecuencia** con chips (cada 4h, 6h, 8h, 12h, 24h).
  - **Selector de hora de inicio** con TimePicker nativo.
  - **Duración** del tratamiento con RadioListTile (7 días, 15 días, 30 días, próximo control, crónico).

### Funcionalidad de control de toma:
- El usuario puede **tocar cada chip de hora** para marcar que tomó la dosis.
- El sistema muestra visualmente si una dosis fue:
  - **Tomada** (verde con checkmark)
  - **Olvidada** (rojo, hora ya pasada sin marcar)
  - **Pendiente** (gris, próxima hora)
- Esto resuelve el requerimiento de "a veces uno no se acuerda si se lo tomó o no".

---

## 3. Sección de Hidratación

### Archivos creados:

#### `lib/domain/entities/hydration.dart`
- **Entidad `HydrationRecord`:** Tipo de líquido, cantidad en ml, nota opcional, timestamp.
- **Entidad `DailyHydration`:** Agrupación diaria con meta, progreso y conteo de vasos.
- **Enum `LiquidType`:** Agua, infusión/té, jugo natural, caldo, otro — cada uno con emoji y etiqueta.

#### `lib/presentation/screens/hydration_tab.dart`
- Pestaña completa de hidratación con:
  - **Círculo de progreso:** Meta diaria (2000ml), cantidad consumida, porcentaje, conteo de vasos.
  - **Registro rápido:** Botones de 1 toque para "1 vaso de agua (250ml)", "1 taza de té (200ml)", "1 jugo (200ml)".
  - **Resumen por tipo:** Chips que muestran cuántos ml de cada tipo se consumió hoy.
  - **Historial del día:** Lista cronológica de cada registro con tipo, cantidad, hora y opción de eliminar.
  - **Indicador de meta alcanzada** (badge verde "¡Meta alcanzada!").

#### `lib/presentation/widgets/add_hydration_dialog.dart`
- Diálogo para registro personalizado:
  - **Tipo de líquido** con ChoiceChips y emojis.
  - **Cantidad** con chips rápidos (100, 200, 250, 330, 500ml) + slider para personalizar (50-1000ml).
  - **Nota opcional** (ej: "Agua con limón", "Manzanilla").

---

## 4. Corrección del Nombre Duplicado en Registro/Onboarding

### Problema detectado:
La pantalla de registro (`RegisterScreen`) pedía nombre y correo. Luego, al navegar al onboarding (`OnboardingScreen`), se volvía a pedir el nombre sin pre-llenar el dato ya ingresado.

### Solución implementada:

#### `lib/presentation/screens/register_screen.dart`
- Se modificó la navegación para pasar `arguments` con el nombre y correo:
```dart
Navigator.of(context).pushReplacementNamed(
  '/onboarding',
  arguments: {
    'name': _nameController.text.trim(),
    'email': _emailController.text.trim(),
  },
);
```

#### `lib/presentation/screens/onboarding_screen.dart`
- Se agregaron parámetros opcionales `initialName` e `initialEmail` al widget.
- Se agregó `initState()` para pre-llenar el `_nameController`:
```dart
@override
void initState() {
  super.initState();
  if (widget.initialName != null && widget.initialName!.isNotEmpty) {
    _nameController.text = widget.initialName!;
  }
}
```

#### `lib/core/routes/app_router.dart`
- Se modificó la ruta `/onboarding` para extraer los argumentos y pasarlos al widget:
```dart
case AppRoutes.onboarding:
  final args = settings.arguments as Map<String, dynamic>?;
  return MaterialPageRoute(
    builder: (context) => OnboardingScreen(
      initialName: args?['name'] as String?,
      initialEmail: args?['email'] as String?,
      onCompleted: (profile) { ... },
    ),
  );
```

---

## 5. Actualización de Pantalla de Inicio (`HomeTab` y `HomeScreen`)

### `lib/presentation/screens/home_screen.dart`
- Se agregaron las pestañas de **Medicamentos** (`MedicationTab`) e **Hidratación** (`HydrationTab`) al `BottomNavigationBar`.
- La barra de navegación inferior ahora tiene 7 secciones: Inicio, Presión, Medicamentos, Hidratación, Nutrición, Educación, Hábitos.

### `lib/presentation/screens/home_tab.dart`
- Se agregaron dos nuevas tarjetas resumen en la página de inicio:
  - **Medicamentos** (icono de pastilla, color púrpura): "Controla tus dosis" / "Ver alertas".
  - **Hidratación** (icono de gota, color azul): "Registra tu consumo de líquidos" / "Registrar".

---

## Archivos Modificados

| Archivo | Tipo de cambio |
|---|---|
| `pubspec.yaml` | Nuevas dependencias |
| `lib/presentation/screens/home_screen.dart` | Nuevas pestañas en BottomNavigationBar |
| `lib/presentation/screens/home_tab.dart` | Nuevas tarjetas resumen |
| `lib/presentation/screens/register_screen.dart` | Pasar argumentos al onboarding |
| `lib/presentation/screens/onboarding_screen.dart` | Recibir y pre-llenar nombre |
| `lib/core/routes/app_router.dart` | Extraer argumentos en ruta onboarding |

## Archivos Creados

| Archivo | Descripción |
|---|---|
| `lib/domain/entities/medication.dart` | Entidades Medication y MedicationDose |
| `lib/domain/entities/hydration.dart` | Entidades HydrationRecord y DailyHydration |
| `lib/presentation/screens/medication_tab.dart` | Pantalla completa de medicamentos |
| `lib/presentation/screens/hydration_tab.dart` | Pantalla completa de hidratación |
| `lib/presentation/widgets/add_medication_dialog.dart` | Diálogo para agregar medicamento |
| `lib/presentation/widgets/add_hydration_dialog.dart` | Diálogo para registrar líquido |
| `doc/informe_modificaciones_v2.md` | Este documento |

---

## Próximos Pasos Recomendados

1. **Persistencia con SQLite:** Conectar las entidades de Medication e Hydration a `sqflite` para que los datos sobrevivan al cierre de la app.
2. **Notificaciones locales:** Implementar `flutter_local_notifications` + `timezone` para generar alarmas recurrentes de medicamentos.
3. **BLoC/Cubit:** Migrar el estado de MedicationTab y HydrationTab a Cubits para mejor separación y testabilidad.
4. **Gráficos:** Usar `fl_chart` para visualizar la evolución de presión arterial y adherencia al tratamiento.
5. **Cámara:** Implementar `image_picker` en la sección de nutrición para registro fotográfico de alimentos.
6. **Tests:** Crear tests unitarios para las entidades y los cálculos (nextDoseTime, progress de hidratación, etc.).
