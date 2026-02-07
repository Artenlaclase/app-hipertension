import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import '../../core/errors/failures.dart';
import '../../core/usecases/usecase.dart';
import '../repositories/user_repository.dart';

class AcceptDisclaimer extends UseCase<bool, DisclaimerParams> {
  final UserRepository repository;

  AcceptDisclaimer(this.repository);

  @override
  Future<Either<Failure, bool>> call(DisclaimerParams params) {
    return repository.acceptDisclaimer(params.userId);
  }
}

class DisclaimerParams extends Equatable {
  final String userId;

  const DisclaimerParams({required this.userId});

  @override
  List<Object> get props => [userId];
}
