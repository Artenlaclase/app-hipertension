import 'package:dartz/dartz.dart';
import '../../core/errors/failures.dart';
import '../entities/food.dart';
import '../entities/food_record.dart';
import '../entities/meal_plan.dart';

abstract class NutritionRepository {
  // Alimentos
  Future<Either<Failure, List<Food>>> getFoods();
  Future<Either<Failure, List<Food>>> searchFoods(String query);
  Future<Either<Failure, List<Food>>> getFoodsByCategory(String category);

  // Registro de alimentos
  Future<Either<Failure, FoodRecord>> addFoodRecord(FoodRecord record);
  Future<Either<Failure, List<FoodRecord>>> getFoodRecordsByDate(
    String userId,
    DateTime date,
  );
  Future<Either<Failure, void>> deleteFoodRecord(String recordId);

  // Plan alimenticio
  Future<Either<Failure, MealPlan>> getMealPlan(String userId, DateTime date);
  Future<Either<Failure, MealPlan>> generateMealPlan(
    String userId,
    DateTime date,
  );
}
