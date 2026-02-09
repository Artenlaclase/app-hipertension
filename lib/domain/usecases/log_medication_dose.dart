import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import '../../core/errors/failures.dart';
import '../../core/usecases/usecase.dart';
import '../entities/medication.dart';
import '../repositories/medication_repository.dart';

class LogMedicationDose extends UseCase<MedicationDose, LogDoseParams> {
  final MedicationRepository repository;

  LogMedicationDose(this.repository);

  @override
  Future<Either<Failure, MedicationDose>> call(LogDoseParams params) {
    return repository.logDose(
      medicationId: params.medicationId,
      scheduledTime: params.scheduledTime,
      wasTaken: params.wasTaken,
    );
  }
}

class LogDoseParams extends Equatable {
  final String medicationId;
  final DateTime scheduledTime;
  final bool wasTaken;

  const LogDoseParams({
    required this.medicationId,
    required this.scheduledTime,
    required this.wasTaken,
  });

  @override
  List<Object?> get props => [medicationId, scheduledTime, wasTaken];
}
