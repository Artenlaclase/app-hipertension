import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import '../../core/errors/failures.dart';
import '../../core/usecases/usecase.dart';
import '../entities/meal_plan.dart';
import '../repositories/nutrition_repository.dart';

class GetMealPlan extends UseCase<MealPlan, MealPlanParams> {
  final NutritionRepository repository;

  GetMealPlan(this.repository);

  @override
  Future<Either<Failure, MealPlan>> call(MealPlanParams params) {
    return repository.getMealPlan(params.userId, params.date);
  }
}

class MealPlanParams extends Equatable {
  final String userId;
  final DateTime date;

  const MealPlanParams({required this.userId, required this.date});

  @override
  List<Object> get props => [userId, date];
}
