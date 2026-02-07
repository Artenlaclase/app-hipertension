import 'package:dartz/dartz.dart';
import '../../core/errors/failures.dart';
import '../../core/usecases/usecase.dart';
import '../entities/education_content.dart';
import '../repositories/education_repository.dart';

class GetEducationContents extends UseCase<List<EducationContent>, NoParams> {
  final EducationRepository repository;

  GetEducationContents(this.repository);

  @override
  Future<Either<Failure, List<EducationContent>>> call(NoParams params) {
    return repository.getContents();
  }
}
