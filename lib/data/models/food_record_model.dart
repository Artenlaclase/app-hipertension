import '../../domain/entities/food.dart';
import '../../domain/entities/food_record.dart';
import 'food_model.dart';

class FoodRecordModel extends FoodRecord {
  const FoodRecordModel({
    required super.id,
    required super.userId,
    required super.food,
    required super.mealType,
    super.portions,
    required super.recordedAt,
  });

  factory FoodRecordModel.fromJson(Map<String, dynamic> json) {
    Food food;
    if (json['food'] != null) {
      food = FoodModel.fromJson(json['food']);
    } else {
      food = Food(
        id: (json['food_id'] ?? '').toString(),
        name: '',
        category: '',
        sodiumLevel: SodiumLevel.medium,
        sodiumMg: 0,
        potassiumMg: 0,
        calories: 0,
        saturatedFatG: 0,
        isRecommendedForHTA: false,
      );
    }

    return FoodRecordModel(
      id: json['id'].toString(),
      userId: json['user_id'].toString(),
      food: food,
      mealType: json['portion'] ?? 'snack',
      portions: 1.0,
      recordedAt: json['consumed_at'] != null
          ? DateTime.parse(json['consumed_at'])
          : DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'food_id': int.tryParse(food.id) ?? food.id,
      'portion': mealType,
      'consumed_at': recordedAt.toIso8601String(),
    };
  }

  factory FoodRecordModel.fromEntity(FoodRecord entity) {
    return FoodRecordModel(
      id: entity.id,
      userId: entity.userId,
      food: entity.food,
      mealType: entity.mealType,
      portions: entity.portions,
      recordedAt: entity.recordedAt,
    );
  }
}
