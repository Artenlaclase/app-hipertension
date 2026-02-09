import 'package:dartz/dartz.dart';
import '../../core/errors/exceptions.dart';
import '../../core/errors/failures.dart';
import '../../core/network/network_info.dart';
import '../../domain/entities/medication.dart';
import '../../domain/repositories/medication_repository.dart';
import '../datasources/medication_remote_datasource.dart';
import '../models/medication_model.dart';

class MedicationRepositoryImpl implements MedicationRepository {
  final MedicationRemoteDataSource remoteDataSource;
  final NetworkInfo networkInfo;

  MedicationRepositoryImpl({
    required this.remoteDataSource,
    required this.networkInfo,
  });

  @override
  Future<Either<Failure, List<Medication>>> getMedications() async {
    if (!await networkInfo.isConnected) {
      return const Left(NetworkFailure());
    }
    try {
      final models = await remoteDataSource.getMedications();
      final medications = models.map(_modelToEntity).toList();
      return Right(medications);
    } on UnauthorizedException {
      return const Left(AuthFailure());
    } on ServerException {
      return const Left(ServerFailure());
    }
  }

  @override
  Future<Either<Failure, Medication>> createMedication(
      Medication medication) async {
    if (!await networkInfo.isConnected) {
      return const Left(NetworkFailure());
    }
    try {
      final data = {
        'name': medication.name,
        'dosage': medication.dosage,
        'instructions':
            'Cada ${medication.frequencyHours}h | ${medication.duration.label}',
      };
      final model = await remoteDataSource.createMedication(data);

      // Crear alarma basada en la frecuencia y hora de inicio
      final alarmTime =
          '${medication.startTime.hour.toString().padLeft(2, '0')}:'
          '${medication.startTime.minute.toString().padLeft(2, '0')}';
      await remoteDataSource.createAlarm(model.id, {
        'alarm_time': alarmTime,
        'days_of_week': 'lun,mar,mie,jue,vie,sab,dom',
        'active': true,
      });

      // Re-fetch para obtener el modelo completo con alarmas
      final completeModel = await remoteDataSource.getMedication(model.id);
      return Right(_modelToEntity(completeModel));
    } on UnauthorizedException {
      return const Left(AuthFailure());
    } on ValidationException catch (e) {
      return Left(ValidationFailure(message: e.message, errors: e.errors));
    } on ServerException {
      return const Left(ServerFailure());
    }
  }

  @override
  Future<Either<Failure, void>> deleteMedication(String id) async {
    if (!await networkInfo.isConnected) {
      return const Left(NetworkFailure());
    }
    try {
      await remoteDataSource.deleteMedication(id);
      return const Right(null);
    } on UnauthorizedException {
      return const Left(AuthFailure());
    } on ServerException {
      return const Left(ServerFailure());
    }
  }

  @override
  Future<Either<Failure, MedicationDose>> logDose({
    required String medicationId,
    required DateTime scheduledTime,
    required bool wasTaken,
  }) async {
    if (!await networkInfo.isConnected) {
      return const Left(NetworkFailure());
    }
    try {
      final logModel = await remoteDataSource.createMedicationLog(
        medicationId,
        {
          'taken_at': scheduledTime.toIso8601String(),
          'status': wasTaken ? 'tomado' : 'omitido',
        },
      );
      return Right(MedicationDose(
        id: logModel.id,
        medicationId: logModel.medicationId,
        scheduledTime: scheduledTime,
        takenTime: wasTaken ? logModel.takenAt : null,
        wasTaken: logModel.status == 'tomado',
      ));
    } on UnauthorizedException {
      return const Left(AuthFailure());
    } on ServerException {
      return const Left(ServerFailure());
    }
  }

  @override
  Future<Either<Failure, List<MedicationDose>>> getDoseLogs(
      String medicationId) async {
    if (!await networkInfo.isConnected) {
      return const Left(NetworkFailure());
    }
    try {
      final logs = await remoteDataSource.getMedicationLogs(medicationId);
      final doses = logs
          .map((log) => MedicationDose(
                id: log.id,
                medicationId: log.medicationId,
                scheduledTime: log.takenAt,
                takenTime: log.status == 'tomado' ? log.takenAt : null,
                wasTaken: log.status == 'tomado',
              ))
          .toList();
      return Right(doses);
    } on UnauthorizedException {
      return const Left(AuthFailure());
    } on ServerException {
      return const Left(ServerFailure());
    }
  }

  @override
  Future<Either<Failure, Map<String, dynamic>>> getAdherence(
      {String? period}) async {
    if (!await networkInfo.isConnected) {
      return const Left(NetworkFailure());
    }
    try {
      final data = await remoteDataSource.getAdherence(period: period);
      return Right(data);
    } on UnauthorizedException {
      return const Left(AuthFailure());
    } on ServerException {
      return const Left(ServerFailure());
    }
  }

  /// Convierte MedicationModel (API) → Medication (entidad de dominio)
  Medication _modelToEntity(MedicationModel model) {
    // Extraer frecuencia de las instrucciones o usar default
    int frequencyHours = 8;
    TreatmentDuration duration = TreatmentDuration.chronic;

    if (model.instructions != null) {
      final freqMatch = RegExp(r'Cada (\d+)h').firstMatch(model.instructions!);
      if (freqMatch != null) {
        frequencyHours = int.tryParse(freqMatch.group(1)!) ?? 8;
      }

      if (model.instructions!.contains('7 días')) {
        duration = TreatmentDuration.days7;
      } else if (model.instructions!.contains('15 días')) {
        duration = TreatmentDuration.days15;
      } else if (model.instructions!.contains('30 días')) {
        duration = TreatmentDuration.days30;
      } else if (model.instructions!.contains('Próximo control')) {
        duration = TreatmentDuration.nextCheckup;
      }
    }

    // Calcular hora de inicio basado en la primera alarma
    DateTime startTime = model.createdAt;
    if (model.alarms.isNotEmpty) {
      final parts = model.alarms.first.alarmTime.split(':');
      final h = int.tryParse(parts[0]) ?? 8;
      final m = parts.length > 1 ? int.tryParse(parts[1]) ?? 0 : 0;
      startTime = DateTime(
        model.createdAt.year,
        model.createdAt.month,
        model.createdAt.day,
        h,
        m,
      );
    }

    final endDate = duration.endDate(startTime);

    // Convertir logs a doses
    final doses = model.logs
        .map((log) => MedicationDose(
              id: log.id,
              medicationId: log.medicationId,
              scheduledTime: log.takenAt,
              takenTime: log.status == 'tomado' ? log.takenAt : null,
              wasTaken: log.status == 'tomado',
            ))
        .toList();

    return Medication(
      id: model.id,
      name: model.name,
      dosage: model.dosage,
      frequencyHours: frequencyHours,
      startTime: startTime,
      duration: duration,
      endDate: endDate,
      isActive: endDate == null || DateTime.now().isBefore(endDate),
      createdAt: model.createdAt,
      doses: doses,
    );
  }
}
