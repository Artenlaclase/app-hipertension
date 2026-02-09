import '../../domain/entities/food.dart';

class FoodModel extends Food {
  const FoodModel({
    required super.id,
    required super.name,
    required super.category,
    required super.sodiumLevel,
    required super.sodiumMg,
    required super.potassiumMg,
    required super.calories,
    required super.saturatedFatG,
    required super.isRecommendedForHTA,
    super.imageUrl,
  });

  factory FoodModel.fromJson(Map<String, dynamic> json) {
    final sodiumLvl = _parseSodiumLevel(json['sodium_level']);
    return FoodModel(
      id: json['id'].toString(),
      name: json['name'] ?? '',
      category: json['category'] ?? '',
      sodiumLevel: sodiumLvl,
      sodiumMg: _parseDouble(json['sodium_mg']),
      potassiumMg: _parseDouble(json['potassium_mg']),
      calories: _parseDouble(json['calories']),
      saturatedFatG: _parseDouble(json['saturated_fat_g']),
      isRecommendedForHTA: sodiumLvl == SodiumLevel.low,
      imageUrl: json['image_url'],
    );
  }

  static SodiumLevel _parseSodiumLevel(String? value) {
    switch (value) {
      case 'bajo':
        return SodiumLevel.low;
      case 'alto':
        return SodiumLevel.high;
      case 'medio':
      default:
        return SodiumLevel.medium;
    }
  }

  static double _parseDouble(dynamic value) {
    if (value == null) return 0.0;
    if (value is double) return value;
    if (value is int) return value.toDouble();
    if (value is String) return double.tryParse(value) ?? 0.0;
    return 0.0;
  }
}
