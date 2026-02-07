import 'package:equatable/equatable.dart';

enum SodiumLevel { low, medium, high }

class Food extends Equatable {
  final String id;
  final String name;
  final String category;
  final SodiumLevel sodiumLevel;
  final double sodiumMg; // mg por porción
  final double potassiumMg; // mg por porción
  final double calories;
  final double saturatedFatG;
  final bool isRecommendedForHTA;
  final String? imageUrl;

  const Food({
    required this.id,
    required this.name,
    required this.category,
    required this.sodiumLevel,
    required this.sodiumMg,
    required this.potassiumMg,
    required this.calories,
    required this.saturatedFatG,
    required this.isRecommendedForHTA,
    this.imageUrl,
  });

  @override
  List<Object?> get props => [
    id,
    name,
    category,
    sodiumLevel,
    sodiumMg,
    potassiumMg,
    calories,
    saturatedFatG,
    isRecommendedForHTA,
    imageUrl,
  ];
}
