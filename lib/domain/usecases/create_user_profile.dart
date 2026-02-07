import 'package:dartz/dartz.dart';
import '../../core/errors/failures.dart';
import '../../core/usecases/usecase.dart';
import '../entities/user_profile.dart';
import '../repositories/user_repository.dart';

class CreateUserProfile extends UseCase<UserProfile, UserProfile> {
  final UserRepository repository;

  CreateUserProfile(this.repository);

  @override
  Future<Either<Failure, UserProfile>> call(UserProfile params) {
    return repository.createProfile(params);
  }
}
