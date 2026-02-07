import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import '../../core/errors/failures.dart';
import '../../core/usecases/usecase.dart';
import '../entities/user_profile.dart';
import '../repositories/user_repository.dart';

class GetUserProfile extends UseCase<UserProfile, UserProfileParams> {
  final UserRepository repository;

  GetUserProfile(this.repository);

  @override
  Future<Either<Failure, UserProfile>> call(UserProfileParams params) {
    return repository.getProfile(params.userId);
  }
}

class UserProfileParams extends Equatable {
  final String userId;

  const UserProfileParams({required this.userId});

  @override
  List<Object> get props => [userId];
}
