import 'package:dartz/dartz.dart';
import '../../core/errors/failures.dart';
import '../entities/user_profile.dart';

abstract class UserRepository {
  Future<Either<Failure, UserProfile>> createProfile(UserProfile profile);
  Future<Either<Failure, UserProfile>> getProfile(String userId);
  Future<Either<Failure, UserProfile>> updateProfile(UserProfile profile);
  Future<Either<Failure, bool>> acceptDisclaimer(String userId);
  Future<Either<Failure, bool>> hasCompletedOnboarding();
}
