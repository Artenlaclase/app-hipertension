import 'package:equatable/equatable.dart';
import 'food.dart';

class FoodRecord extends Equatable {
  final String id;
  final String userId;
  final Food food;
  final String mealType; // desayuno, almuerzo, cena, snack
  final double portions;
  final DateTime recordedAt;

  const FoodRecord({
    required this.id,
    required this.userId,
    required this.food,
    required this.mealType,
    this.portions = 1.0,
    required this.recordedAt,
  });

  @override
  List<Object?> get props => [id, userId, food, mealType, portions, recordedAt];
}
