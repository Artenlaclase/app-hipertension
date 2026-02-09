import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:get_it/get_it.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import 'core/network/api_client.dart';
import 'core/network/network_info.dart';
import 'core/services/auth_token_service.dart';
import 'core/services/database_helper.dart';

import 'data/datasources/auth_remote_datasource.dart';
import 'data/datasources/blood_pressure_remote_datasource.dart';
import 'data/datasources/education_remote_datasource.dart';
import 'data/datasources/habit_remote_datasource.dart';
import 'data/datasources/hydration_local_datasource.dart';
import 'data/datasources/medication_remote_datasource.dart';
import 'data/datasources/nutrition_remote_datasource.dart';

import 'data/repositories/blood_pressure_repository_impl.dart';
import 'data/repositories/education_repository_impl.dart';
import 'data/repositories/habit_repository_impl.dart';
import 'data/repositories/hydration_repository_impl.dart';
import 'data/repositories/medication_repository_impl.dart';
import 'data/repositories/nutrition_repository_impl.dart';
import 'data/repositories/user_repository_impl.dart';

import 'domain/repositories/blood_pressure_repository.dart';
import 'domain/repositories/education_repository.dart';
import 'domain/repositories/habit_repository.dart';
import 'domain/repositories/hydration_repository.dart';
import 'domain/repositories/medication_repository.dart';
import 'domain/repositories/nutrition_repository.dart';
import 'domain/repositories/user_repository.dart';

import 'domain/usecases/accept_disclaimer.dart';
import 'domain/usecases/add_blood_pressure.dart';
import 'domain/usecases/add_food_record.dart';
import 'domain/usecases/add_hydration_record.dart';
import 'domain/usecases/create_medication.dart';
import 'domain/usecases/create_user_profile.dart';
import 'domain/usecases/delete_hydration_record.dart';
import 'domain/usecases/delete_medication.dart';
import 'domain/usecases/get_blood_pressure_history.dart';
import 'domain/usecases/get_education_contents.dart';
import 'domain/usecases/get_hydration_records.dart';
import 'domain/usecases/get_meal_plan.dart';
import 'domain/usecases/get_medications.dart';
import 'domain/usecases/get_user_profile.dart';
import 'domain/usecases/log_medication_dose.dart';

final sl = GetIt.instance;

Future<void> init() async {
  //============================================================
  // External
  //============================================================
  final sharedPreferences = await SharedPreferences.getInstance();
  sl.registerLazySingleton(() => sharedPreferences);
  sl.registerLazySingleton(() => http.Client());
  sl.registerLazySingleton(() => Connectivity());

  //============================================================
  // Core
  //============================================================
  sl.registerLazySingleton<NetworkInfo>(
    () => NetworkInfoImpl(sl<Connectivity>()),
  );
  sl.registerLazySingleton<AuthTokenService>(
    () => AuthTokenService(sl<SharedPreferences>()),
  );
  sl.registerLazySingleton<ApiClient>(
    () => ApiClient(
      httpClient: sl<http.Client>(),
      authTokenService: sl<AuthTokenService>(),
    ),
  );

  //============================================================
  // Data Sources
  //============================================================
  sl.registerLazySingleton<AuthRemoteDataSource>(
    () => AuthRemoteDataSourceImpl(
      apiClient: sl<ApiClient>(),
      authTokenService: sl<AuthTokenService>(),
    ),
  );
  sl.registerLazySingleton<BloodPressureRemoteDataSource>(
    () => BloodPressureRemoteDataSourceImpl(apiClient: sl<ApiClient>()),
  );
  sl.registerLazySingleton<NutritionRemoteDataSource>(
    () => NutritionRemoteDataSourceImpl(apiClient: sl<ApiClient>()),
  );
  sl.registerLazySingleton<EducationRemoteDataSource>(
    () => EducationRemoteDataSourceImpl(apiClient: sl<ApiClient>()),
  );
  sl.registerLazySingleton<HabitRemoteDataSource>(
    () => HabitRemoteDataSourceImpl(apiClient: sl<ApiClient>()),
  );
  sl.registerLazySingleton<MedicationRemoteDataSource>(
    () => MedicationRemoteDataSourceImpl(apiClient: sl<ApiClient>()),
  );
  sl.registerLazySingleton(() => DatabaseHelper());
  sl.registerLazySingleton<HydrationLocalDataSource>(
    () => HydrationLocalDataSourceImpl(databaseHelper: sl<DatabaseHelper>()),
  );

  //============================================================
  // Repositories
  //============================================================
  sl.registerLazySingleton<UserRepository>(
    () => UserRepositoryImpl(
      remoteDataSource: sl<AuthRemoteDataSource>(),
      networkInfo: sl<NetworkInfo>(),
      authTokenService: sl<AuthTokenService>(),
    ),
  );
  sl.registerLazySingleton<BloodPressureRepository>(
    () => BloodPressureRepositoryImpl(
      remoteDataSource: sl<BloodPressureRemoteDataSource>(),
      networkInfo: sl<NetworkInfo>(),
    ),
  );
  sl.registerLazySingleton<NutritionRepository>(
    () => NutritionRepositoryImpl(
      remoteDataSource: sl<NutritionRemoteDataSource>(),
      networkInfo: sl<NetworkInfo>(),
    ),
  );
  sl.registerLazySingleton<EducationRepository>(
    () => EducationRepositoryImpl(
      remoteDataSource: sl<EducationRemoteDataSource>(),
      networkInfo: sl<NetworkInfo>(),
    ),
  );
  sl.registerLazySingleton<HabitRepository>(
    () => HabitRepositoryImpl(
      remoteDataSource: sl<HabitRemoteDataSource>(),
      networkInfo: sl<NetworkInfo>(),
    ),
  );
  sl.registerLazySingleton<MedicationRepository>(
    () => MedicationRepositoryImpl(
      remoteDataSource: sl<MedicationRemoteDataSource>(),
      networkInfo: sl<NetworkInfo>(),
    ),
  );
  sl.registerLazySingleton<HydrationRepository>(
    () => HydrationRepositoryImpl(
      localDataSource: sl<HydrationLocalDataSource>(),
    ),
  );

  //============================================================
  // Use Cases
  //============================================================
  sl.registerLazySingleton(() => CreateUserProfile(sl<UserRepository>()));
  sl.registerLazySingleton(() => GetUserProfile(sl<UserRepository>()));
  sl.registerLazySingleton(() => AcceptDisclaimer(sl<UserRepository>()));
  sl.registerLazySingleton(
    () => AddBloodPressureRecord(sl<BloodPressureRepository>()),
  );
  sl.registerLazySingleton(
    () => GetBloodPressureHistory(sl<BloodPressureRepository>()),
  );
  sl.registerLazySingleton(() => AddFoodRecord(sl<NutritionRepository>()));
  sl.registerLazySingleton(() => GetMealPlan(sl<NutritionRepository>()));
  sl.registerLazySingleton(
    () => GetEducationContents(sl<EducationRepository>()),
  );

  // Medication Use Cases
  sl.registerLazySingleton(() => GetMedications(sl<MedicationRepository>()));
  sl.registerLazySingleton(() => CreateMedication(sl<MedicationRepository>()));
  sl.registerLazySingleton(() => DeleteMedication(sl<MedicationRepository>()));
  sl.registerLazySingleton(() => LogMedicationDose(sl<MedicationRepository>()));

  // Hydration Use Cases
  sl.registerLazySingleton(
    () => GetHydrationRecords(sl<HydrationRepository>()),
  );
  sl.registerLazySingleton(() => AddHydrationRecord(sl<HydrationRepository>()));
  sl.registerLazySingleton(
    () => DeleteHydrationRecord(sl<HydrationRepository>()),
  );
}
