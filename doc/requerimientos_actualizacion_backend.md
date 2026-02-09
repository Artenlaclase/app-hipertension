# Requerimientos de Actualización — Backend Laravel

**API:** `https://api-htapp.terapiatarot.com/api`  
**Fecha:** Febrero 2026  
**Versión:** 1.0  

---

## Índice

1. [Módulo de Hidratación (NUEVO)](#1-módulo-de-hidratación-nuevo)
2. [Sistema de Verificación de Email al Registrarse](#2-sistema-de-verificación-de-email-al-registrarse)
3. [Sistema de Recuperación de Contraseña](#3-sistema-de-recuperación-de-contraseña)
4. [Estado Actual del Backend](#4-estado-actual-del-backend)

---

## 1. Módulo de Hidratación (NUEVO)

Actualmente la hidratación se almacena **solo en SQLite local** del dispositivo. Se requiere crear el módulo completo en el backend Laravel para sincronización y persistencia en la nube.

### 1.1 Migración — Tabla `hydration_records`

```php
Schema::create('hydration_records', function (Blueprint $table) {
    $table->uuid('id')->primary();
    $table->foreignUuid('user_id')->constrained()->onDelete('cascade');
    $table->enum('liquid_type', ['water', 'infusion', 'juice', 'broth', 'other']);
    $table->unsignedInteger('amount_ml');
    $table->text('note')->nullable();
    $table->timestamp('recorded_at');  // momento en que se consumió
    $table->timestamps();              // created_at, updated_at

    $table->index(['user_id', 'recorded_at']);
});
```

### 1.2 Migración — Tabla `hydration_goals`

```php
Schema::create('hydration_goals', function (Blueprint $table) {
    $table->uuid('id')->primary();
    $table->foreignUuid('user_id')->constrained()->onDelete('cascade');
    $table->unsignedInteger('goal_ml')->default(2000);
    $table->date('effective_date');   // desde cuándo aplica esta meta
    $table->timestamps();

    $table->unique(['user_id', 'effective_date']);
});
```

### 1.3 Modelo Eloquent — `HydrationRecord`

```php
class HydrationRecord extends Model
{
    use HasUuids;

    protected $fillable = [
        'user_id', 'liquid_type', 'amount_ml', 'note', 'recorded_at',
    ];

    protected $casts = [
        'recorded_at' => 'datetime',
        'amount_ml' => 'integer',
    ];

    public function user(): BelongsTo
    {
        return $this->belongsTo(User::class);
    }
}
```

### 1.4 Modelo Eloquent — `HydrationGoal`

```php
class HydrationGoal extends Model
{
    use HasUuids;

    protected $fillable = [
        'user_id', 'goal_ml', 'effective_date',
    ];

    protected $casts = [
        'effective_date' => 'date',
        'goal_ml' => 'integer',
    ];

    public function user(): BelongsTo
    {
        return $this->belongsTo(User::class);
    }
}
```

### 1.5 Endpoints Requeridos

| Método | Endpoint | Descripción | Auth |
|--------|----------|-------------|------|
| `GET` | `/hydration-records` | Listar registros del usuario (con filtro `?date=YYYY-MM-DD`) | Bearer |
| `POST` | `/hydration-records` | Crear nuevo registro de hidratación | Bearer |
| `GET` | `/hydration-records/{id}` | Obtener registro específico | Bearer |
| `PUT` | `/hydration-records/{id}` | Actualizar registro | Bearer |
| `DELETE` | `/hydration-records/{id}` | Eliminar registro | Bearer |
| `GET` | `/hydration-goals` | Obtener meta diaria actual del usuario | Bearer |
| `POST` | `/hydration-goals` | Crear/actualizar meta diaria | Bearer |
| `GET` | `/hydration-stats` | Estadísticas de hidratación (semanal/mensual) | Bearer |

### 1.6 Detalle de Request/Response

#### `POST /hydration-records`

**Request:**
```json
{
    "liquid_type": "water",
    "amount_ml": 250,
    "note": "Después del ejercicio",
    "recorded_at": "2026-02-09T14:30:00Z"
}
```

**Response (201):**
```json
{
    "data": {
        "id": "uuid-aquí",
        "user_id": "uuid-usuario",
        "liquid_type": "water",
        "amount_ml": 250,
        "note": "Después del ejercicio",
        "recorded_at": "2026-02-09T14:30:00Z",
        "created_at": "2026-02-09T14:30:05Z",
        "updated_at": "2026-02-09T14:30:05Z"
    }
}
```

#### `GET /hydration-records?date=2026-02-09`

**Response (200):**
```json
{
    "data": [
        {
            "id": "uuid-1",
            "user_id": "uuid-usuario",
            "liquid_type": "water",
            "amount_ml": 250,
            "note": null,
            "recorded_at": "2026-02-09T08:00:00Z",
            "created_at": "...",
            "updated_at": "..."
        }
    ],
    "meta": {
        "total_ml": 1750,
        "goal_ml": 2000,
        "progress": 0.875,
        "records_count": 7
    }
}
```

#### `GET /hydration-stats?period=week`

**Response (200):**
```json
{
    "data": {
        "period": "week",
        "daily_average_ml": 1850,
        "goal_ml": 2000,
        "days_goal_reached": 4,
        "total_days": 7,
        "by_type": {
            "water": 8500,
            "infusion": 2400,
            "juice": 800,
            "broth": 600,
            "other": 200
        },
        "daily": [
            { "date": "2026-02-03", "total_ml": 2100 },
            { "date": "2026-02-04", "total_ml": 1600 }
        ]
    }
}
```

### 1.7 Controlador — `HydrationRecordController`

```php
class HydrationRecordController extends Controller
{
    public function index(Request $request)
    {
        $query = $request->user()->hydrationRecords()->orderByDesc('recorded_at');

        if ($request->has('date')) {
            $date = Carbon::parse($request->date);
            $query->whereDate('recorded_at', $date);
        }

        $records = $query->get();
        $goal = $request->user()->hydrationGoals()
            ->where('effective_date', '<=', now()->toDateString())
            ->orderByDesc('effective_date')
            ->first();

        return response()->json([
            'data' => HydrationRecordResource::collection($records),
            'meta' => [
                'total_ml' => $records->sum('amount_ml'),
                'goal_ml' => $goal?->goal_ml ?? 2000,
                'progress' => $records->sum('amount_ml') / ($goal?->goal_ml ?? 2000),
                'records_count' => $records->count(),
            ],
        ]);
    }

    public function store(Request $request)
    {
        $validated = $request->validate([
            'liquid_type' => 'required|in:water,infusion,juice,broth,other',
            'amount_ml' => 'required|integer|min:1|max:5000',
            'note' => 'nullable|string|max:500',
            'recorded_at' => 'required|date',
        ]);

        $record = $request->user()->hydrationRecords()->create($validated);

        return new HydrationRecordResource($record);
    }

    public function show(HydrationRecord $hydrationRecord)
    {
        $this->authorize('view', $hydrationRecord);
        return new HydrationRecordResource($hydrationRecord);
    }

    public function update(Request $request, HydrationRecord $hydrationRecord)
    {
        $this->authorize('update', $hydrationRecord);

        $validated = $request->validate([
            'liquid_type' => 'in:water,infusion,juice,broth,other',
            'amount_ml' => 'integer|min:1|max:5000',
            'note' => 'nullable|string|max:500',
            'recorded_at' => 'date',
        ]);

        $hydrationRecord->update($validated);
        return new HydrationRecordResource($hydrationRecord);
    }

    public function destroy(HydrationRecord $hydrationRecord)
    {
        $this->authorize('delete', $hydrationRecord);
        $hydrationRecord->delete();
        return response()->json(null, 204);
    }
}
```

### 1.8 Rutas — `routes/api.php`

```php
Route::middleware('auth:sanctum')->group(function () {
    // ... rutas existentes ...

    // Hidratación
    Route::apiResource('hydration-records', HydrationRecordController::class);
    Route::get('hydration-goals', [HydrationGoalController::class, 'show']);
    Route::post('hydration-goals', [HydrationGoalController::class, 'store']);
    Route::get('hydration-stats', [HydrationStatsController::class, 'index']);
});
```

### 1.9 Validación de Tipos (Enum)

```php
// app/Enums/LiquidType.php
enum LiquidType: string
{
    case Water = 'water';
    case Infusion = 'infusion';
    case Juice = 'juice';
    case Broth = 'broth';
    case Other = 'other';
}
```

---

## 2. Sistema de Verificación de Email al Registrarse

### Estado actual: ❌ NO IMPLEMENTADO

El registro actual **no envía ningún correo de verificación**. El flujo actual es:

```
RegisterScreen → (navega a onboarding sin registrar en API) → OnboardingScreen → Home
```

El método `register()` existe en `UserRepositoryImpl` pero **nunca se invoca** desde la UI.

### 2.1 Requerimientos Backend

#### Configuración de Email

```php
// .env
MAIL_MAILER=smtp
MAIL_HOST=smtp.ejemplo.com
MAIL_PORT=587
MAIL_USERNAME=noreply@terapiatarot.com
MAIL_ENCRYPTION=tls
MAIL_FROM_ADDRESS=noreply@terapiatarot.com
MAIL_FROM_NAME="HTApp - Salud Cardiovascular"
```

#### Modificar Modelo `User`

```php
use Illuminate\Contracts\Auth\MustVerifyEmail;

class User extends Authenticatable implements MustVerifyEmail
{
    // ... campos existentes ...
}
```

#### Migración — Agregar campo `email_verified_at` (si no existe)

```php
Schema::table('users', function (Blueprint $table) {
    $table->timestamp('email_verified_at')->nullable()->after('email');
});
```

#### Endpoints Requeridos

| Método | Endpoint | Descripción | Auth |
|--------|----------|-------------|------|
| `POST` | `/email/verification-notification` | Reenviar correo de verificación | Bearer |
| `GET` | `/email/verify/{id}/{hash}` | Verificar email (link del correo) | Signed URL |

#### Flujo Propuesto

```
1. Usuario se registra    → POST /register
2. Backend crea usuario   → email_verified_at = NULL
3. Envía correo           → Link: /email/verify/{id}/{hash}
4. Usuario abre link      → Se marca email_verified_at = now()
5. App puede consultar    → GET /me → "email_verified": true/false
```

#### Mailable — `VerifyEmailNotification`

```php
// Personalizar la plantilla de verificación
class VerifyEmailNotification extends Notification
{
    public function toMail($notifiable)
    {
        $url = $this->verificationUrl($notifiable);

        return (new MailMessage)
            ->subject('Verifica tu cuenta — HTApp')
            ->greeting("¡Hola {$notifiable->name}!")
            ->line('Gracias por registrarte en HTApp para el control de tu salud cardiovascular.')
            ->action('Verificar Email', $url)
            ->line('Si no creaste esta cuenta, ignora este correo.')
            ->salutation('Equipo HTApp');
    }
}
```

#### Rutas

```php
// routes/api.php
Route::middleware('auth:sanctum')->group(function () {
    Route::post('/email/verification-notification', function (Request $request) {
        $request->user()->sendEmailVerificationNotification();
        return response()->json(['message' => 'Correo de verificación enviado.']);
    })->middleware('throttle:6,1');
});

Route::get('/email/verify/{id}/{hash}', function (EmailVerificationRequest $request) {
    $request->fulfill();
    return response()->json(['message' => 'Email verificado correctamente.']);
})->middleware(['auth:sanctum', 'signed'])->name('verification.verify');
```

#### Respuesta de `/register` actualizada

```json
{
    "data": {
        "id": "uuid",
        "name": "Juan",
        "email": "juan@ejemplo.com",
        "email_verified": false
    },
    "token": "jwt-token-aquí",
    "message": "Registro exitoso. Se envió un correo de verificación."
}
```

#### Respuesta de `GET /me` actualizada

```json
{
    "data": {
        "id": "uuid",
        "name": "Juan",
        "email": "juan@ejemplo.com",
        "email_verified": true,
        "email_verified_at": "2026-02-09T10:30:00Z"
    }
}
```

---

## 3. Sistema de Recuperación de Contraseña

### Estado actual: ❌ NO IMPLEMENTADO

No existe ninguna funcionalidad de "Olvidé mi contraseña" en la app ni en la API. La pantalla de login no tiene enlace para recuperación.

### 3.1 Requerimientos Backend

#### Migración — Tabla `password_reset_tokens` (Laravel default)

```php
// Normalmente ya existe si se usó el scaffolding de Laravel
Schema::create('password_reset_tokens', function (Blueprint $table) {
    $table->string('email')->primary();
    $table->string('token');
    $table->timestamp('created_at')->nullable();
});
```

#### Endpoints Requeridos

| Método | Endpoint | Descripción | Auth |
|--------|----------|-------------|------|
| `POST` | `/forgot-password` | Enviar email con código/link de reset | Público |
| `POST` | `/reset-password` | Restablecer contraseña con token | Público |
| `POST` | `/validate-reset-token` | Validar que el token sea vigente | Público |

#### `POST /forgot-password`

**Request:**
```json
{
    "email": "usuario@ejemplo.com"
}
```

**Response (200):**
```json
{
    "message": "Se envió un enlace de recuperación a tu correo electrónico."
}
```

> **Nota de seguridad:** Siempre retornar 200 aunque el email no exista, para no revelar si un email está registrado.

#### `POST /reset-password`

**Request:**
```json
{
    "email": "usuario@ejemplo.com",
    "token": "token-del-correo",
    "password": "NuevaContraseña123",
    "password_confirmation": "NuevaContraseña123"
}
```

**Response (200):**
```json
{
    "message": "Contraseña restablecida correctamente."
}
```

**Response (422 — Token inválido/expirado):**
```json
{
    "message": "El enlace de recuperación es inválido o ha expirado.",
    "errors": {
        "email": ["El enlace de recuperación es inválido o ha expirado."]
    }
}
```

#### Controlador — `PasswordResetController`

```php
class PasswordResetController extends Controller
{
    public function forgotPassword(Request $request)
    {
        $request->validate(['email' => 'required|email']);

        $status = Password::sendResetLink($request->only('email'));

        // Siempre retorna 200 por seguridad
        return response()->json([
            'message' => 'Se envió un enlace de recuperación a tu correo electrónico.',
        ]);
    }

    public function resetPassword(Request $request)
    {
        $request->validate([
            'token' => 'required',
            'email' => 'required|email',
            'password' => 'required|min:8|confirmed',
        ]);

        $status = Password::reset(
            $request->only('email', 'token', 'password', 'password_confirmation'),
            function ($user, $password) {
                $user->forceFill([
                    'password' => Hash::make($password),
                ])->save();
            }
        );

        if ($status === Password::PASSWORD_RESET) {
            return response()->json(['message' => 'Contraseña restablecida correctamente.']);
        }

        throw ValidationException::withMessages([
            'email' => [__($status)],
        ]);
    }

    public function validateToken(Request $request)
    {
        $request->validate([
            'email' => 'required|email',
            'token' => 'required',
        ]);

        $user = User::where('email', $request->email)->first();

        if (!$user || !Password::tokenExists($user, $request->token)) {
            return response()->json(['valid' => false], 200);
        }

        return response()->json(['valid' => true], 200);
    }
}
```

#### Mailable — Personalizar plantilla

```php
// app/Notifications/ResetPasswordNotification.php
class ResetPasswordNotification extends Notification
{
    public function toMail($notifiable)
    {
        $url = url("/reset-password?token={$this->token}&email={$notifiable->email}");

        return (new MailMessage)
            ->subject('Recuperar contraseña — HTApp')
            ->greeting("¡Hola {$notifiable->name}!")
            ->line('Recibimos una solicitud para restablecer tu contraseña.')
            ->action('Restablecer Contraseña', $url)
            ->line('Este enlace expira en 60 minutos.')
            ->line('Si no solicitaste este cambio, ignora este correo.')
            ->salutation('Equipo HTApp');
    }
}
```

#### Rutas

```php
// routes/api.php (públicas, sin auth)
Route::post('/forgot-password', [PasswordResetController::class, 'forgotPassword'])
    ->middleware('throttle:5,1');

Route::post('/reset-password', [PasswordResetController::class, 'resetPassword']);

Route::post('/validate-reset-token', [PasswordResetController::class, 'validateToken']);
```

#### Configuración — Expiración de tokens

```php
// config/auth.php
'passwords' => [
    'users' => [
        'provider' => 'users',
        'table' => 'password_reset_tokens',
        'expire' => 60,        // minutos
        'throttle' => 60,      // segundos entre reenvíos
    ],
],
```

---

## 4. Estado Actual del Backend

### 4.1 Endpoints Existentes (funcionando)

| Módulo | Endpoints | Estado |
|--------|-----------|--------|
| Autenticación | `/register`, `/login`, `/logout`, `/refresh`, `/me`, `/profile` | ✅ Operativo |
| Onboarding | `/onboarding`, `/disclaimer` | ✅ Operativo |
| Presión Arterial | `/blood-pressure`, `/blood-pressure-stats` | ✅ Operativo |
| Nutrición | `/foods`, `/food-logs`, `/meal-plans`, `/nutritional-recommendations` | ✅ Operativo |
| Medicamentos | `/medications`, `/medication-alarms`, `/medication-adherence` | ✅ Operativo |
| Educación | `/educational-contents` | ✅ Operativo |
| Hábitos | `/habits`, `/habit-logs`, `/habit-streaks` | ✅ Operativo |
| Dashboard | `/dashboard`, `/history` | ✅ Operativo |

### 4.2 Funcionalidades que NO existen

| Funcionalidad | Estado | Prioridad |
|---|---|---|
| Hidratación (CRUD + stats) | ❌ No existe | Alta |
| Verificación de email | ❌ No existe | Alta |
| Recuperación de contraseña | ❌ No existe | **Crítica** |
| Registro desde la app (wiring) | ⚠️ Backend listo, app no conectada | Alta |

### 4.3 Problema en la App: Registro no conectado

El `RegisterScreen` actual **no llama a la API**. Solo navega al onboarding pasando nombre y email. El método `register()` existe en `UserRepositoryImpl` pero nunca se invoca. Esto debe corregirse para que el flujo completo funcione:

```
Register → POST /register → Email verification → Onboarding → Home
```

---

## 5. Resumen de Tareas para el Backend

### Prioridad Crítica
- [ ] Implementar `POST /forgot-password` y `POST /reset-password`
- [ ] Configurar SMTP para envío de correos

### Prioridad Alta
- [ ] Crear migraciones: `hydration_records`, `hydration_goals`
- [ ] Crear modelos: `HydrationRecord`, `HydrationGoal`
- [ ] Implementar `HydrationRecordController` (CRUD completo)
- [ ] Implementar `HydrationGoalController`
- [ ] Implementar `HydrationStatsController`
- [ ] Implementar `MustVerifyEmail` en modelo `User`
- [ ] Crear endpoint `POST /email/verification-notification`
- [ ] Crear endpoint `GET /email/verify/{id}/{hash}`
- [ ] Agregar `email_verified_at` a la respuesta de `GET /me`

### Prioridad Media
- [ ] Crear `LiquidType` enum en PHP
- [ ] Crear `HydrationRecordResource` (API Resource)
- [ ] Crear `HydrationRecordPolicy` (autorización)
- [ ] Personalizar plantillas de email (verificación + reset)
- [ ] Configurar throttle en endpoints públicos

### Prioridad Baja
- [ ] Endpoint `POST /validate-reset-token` (opcional)
- [ ] Seeder para datos de ejemplo de hidratación
- [ ] Tests de los nuevos endpoints
