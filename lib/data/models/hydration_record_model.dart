import '../../domain/entities/hydration.dart';

class HydrationRecordModel {
  final String id;
  final String liquidType;
  final int amountMl;
  final String? note;
  final DateTime timestamp;

  const HydrationRecordModel({
    required this.id,
    required this.liquidType,
    required this.amountMl,
    this.note,
    required this.timestamp,
  });

  /// Desde un Map de SQLite
  factory HydrationRecordModel.fromMap(Map<String, dynamic> map) {
    return HydrationRecordModel(
      id: map['id'] as String,
      liquidType: map['liquid_type'] as String,
      amountMl: map['amount_ml'] as int,
      note: map['note'] as String?,
      timestamp: DateTime.parse(map['timestamp'] as String),
    );
  }

  /// A Map para SQLite
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'liquid_type': liquidType,
      'amount_ml': amountMl,
      'note': note,
      'timestamp': timestamp.toIso8601String(),
    };
  }

  /// Desde entidad de dominio
  factory HydrationRecordModel.fromEntity(HydrationRecord entity) {
    return HydrationRecordModel(
      id: entity.id,
      liquidType: entity.liquidType.name,
      amountMl: entity.amountMl,
      note: entity.note,
      timestamp: entity.timestamp,
    );
  }

  /// A entidad de dominio
  HydrationRecord toEntity() {
    return HydrationRecord(
      id: id,
      liquidType: _parseLiquidType(liquidType),
      amountMl: amountMl,
      note: note,
      timestamp: timestamp,
    );
  }

  static LiquidType _parseLiquidType(String type) {
    switch (type) {
      case 'water':
        return LiquidType.water;
      case 'infusion':
        return LiquidType.infusion;
      case 'juice':
        return LiquidType.juice;
      case 'broth':
        return LiquidType.broth;
      default:
        return LiquidType.other;
    }
  }
}
