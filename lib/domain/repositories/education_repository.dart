import 'package:dartz/dartz.dart';
import '../../core/errors/failures.dart';
import '../entities/education_content.dart';

abstract class EducationRepository {
  Future<Either<Failure, List<EducationContent>>> getContents();
  Future<Either<Failure, List<EducationContent>>> getContentsByCategory(
    String category,
  );
  Future<Either<Failure, EducationContent>> getContentById(String id);
  Future<Either<Failure, void>> markAsRead(String contentId);
}
