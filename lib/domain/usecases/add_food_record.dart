import 'package:dartz/dartz.dart';
import '../../core/errors/failures.dart';
import '../../core/usecases/usecase.dart';
import '../entities/food_record.dart';
import '../repositories/nutrition_repository.dart';

class AddFoodRecord extends UseCase<FoodRecord, FoodRecord> {
  final NutritionRepository repository;

  AddFoodRecord(this.repository);

  @override
  Future<Either<Failure, FoodRecord>> call(FoodRecord params) {
    return repository.addFoodRecord(params);
  }
}
