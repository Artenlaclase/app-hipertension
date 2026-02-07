import 'package:equatable/equatable.dart';
import 'food.dart';

class MealPlan extends Equatable {
  final String id;
  final String userId;
  final String title;
  final String description;
  final List<MealPlanItem> breakfast;
  final List<MealPlanItem> lunch;
  final List<MealPlanItem> dinner;
  final List<MealPlanItem> snacks;
  final double totalSodiumMg;
  final double totalPotassiumMg;
  final double totalCalories;
  final DateTime date;

  const MealPlan({
    required this.id,
    required this.userId,
    required this.title,
    required this.description,
    required this.breakfast,
    required this.lunch,
    required this.dinner,
    required this.snacks,
    required this.totalSodiumMg,
    required this.totalPotassiumMg,
    required this.totalCalories,
    required this.date,
  });

  @override
  List<Object?> get props => [
        id,
        userId,
        title,
        description,
        breakfast,
        lunch,
        dinner,
        snacks,
        totalSodiumMg,
        totalPotassiumMg,
        totalCalories,
        date,
      ];
}

class MealPlanItem extends Equatable {
  final Food food;
  final double portions;
  final String? note;

  const MealPlanItem({
    required this.food,
    this.portions = 1.0,
    this.note,
  });

  @override
  List<Object?> get props => [food, portions, note];
}
