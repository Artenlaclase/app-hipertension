import 'package:equatable/equatable.dart';

/// Tipo de líquido consumido
enum LiquidType { water, infusion, juice, broth, other }

extension LiquidTypeX on LiquidType {
  String get label {
    switch (this) {
      case LiquidType.water:
        return 'Agua';
      case LiquidType.infusion:
        return 'Infusión / Té';
      case LiquidType.juice:
        return 'Jugo natural';
      case LiquidType.broth:
        return 'Caldo';
      case LiquidType.other:
        return 'Otro';
    }
  }

  String get icon {
    switch (this) {
      case LiquidType.water:
        return '💧';
      case LiquidType.infusion:
        return '🍵';
      case LiquidType.juice:
        return '🧃';
      case LiquidType.broth:
        return '🍲';
      case LiquidType.other:
        return '🥤';
    }
  }
}

class HydrationRecord extends Equatable {
  final String id;
  final LiquidType liquidType;
  final int amountMl;
  final String? note;
  final DateTime timestamp;

  const HydrationRecord({
    required this.id,
    required this.liquidType,
    required this.amountMl,
    this.note,
    required this.timestamp,
  });

  @override
  List<Object?> get props => [id, liquidType, amountMl, note, timestamp];
}

class DailyHydration extends Equatable {
  final DateTime date;
  final List<HydrationRecord> records;
  final int goalMl;

  const DailyHydration({
    required this.date,
    required this.records,
    this.goalMl = 2000,
  });

  int get totalMl => records.fold(0, (sum, r) => sum + r.amountMl);
  double get progress => totalMl / goalMl;
  bool get goalReached => totalMl >= goalMl;
  int get glassesCount => (totalMl / 250).floor(); // 1 vaso ≈ 250ml

  @override
  List<Object?> get props => [date, records, goalMl];
}
