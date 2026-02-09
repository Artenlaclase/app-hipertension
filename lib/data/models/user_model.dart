import '../../domain/entities/user_profile.dart';

class UserModel extends UserProfile {
  const UserModel({
    required super.id,
    required super.name,
    required super.age,
    required super.gender,
    required super.weight,
    required super.height,
    required super.activityLevel,
    required super.hypertensionLevel,
    required super.initialSystolic,
    required super.initialDiastolic,
    required super.createdAt,
    super.hasAcceptedDisclaimer,
    this.email,
  });

  final String? email;

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'].toString(),
      name: json['name'] ?? '',
      email: json['email'],
      age: json['age'] ?? 0,
      gender: _parseGender(json['gender']),
      weight: _parseDouble(json['weight']),
      height: _parseDouble(json['height']),
      activityLevel: _parseActivityLevel(json['activity_level']),
      hypertensionLevel: _parseHtaLevel(json['hta_level']),
      initialSystolic: _parseDouble(json['initial_systolic']),
      initialDiastolic: _parseDouble(json['initial_diastolic']),
      createdAt: json['created_at'] != null
          ? DateTime.parse(json['created_at'])
          : DateTime.now(),
      hasAcceptedDisclaimer:
          json['onboarding_completed'] == true ||
          json['onboarding_completed'] == 1,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      if (email != null) 'email': email,
      'age': age,
      'gender': _genderToString(gender),
      'weight': weight,
      'height': height,
      'activity_level': _activityLevelToString(activityLevel),
      'hta_level': _htaLevelToString(hypertensionLevel),
    };
  }

  Map<String, dynamic> toRegisterJson(String email, String password) {
    return {
      'name': name,
      'email': email,
      'password': password,
      'password_confirmation': password,
      'age': age,
      'gender': _genderToString(gender),
      'weight': weight,
      'height': height,
      'activity_level': _activityLevelToString(activityLevel),
      'hta_level': _htaLevelToString(hypertensionLevel),
    };
  }

  Map<String, dynamic> toOnboardingJson() {
    return {
      'initial_systolic': initialSystolic.toInt(),
      'initial_diastolic': initialDiastolic.toInt(),
      'food_restrictions': '',
    };
  }

  static Gender _parseGender(String? value) {
    switch (value) {
      case 'femenino':
        return Gender.female;
      case 'masculino':
      default:
        return Gender.male;
    }
  }

  static String _genderToString(Gender gender) {
    switch (gender) {
      case Gender.male:
        return 'masculino';
      case Gender.female:
        return 'femenino';
    }
  }

  static ActivityLevel _parseActivityLevel(String? value) {
    switch (value) {
      case 'leve':
        return ActivityLevel.light;
      case 'moderado':
        return ActivityLevel.moderate;
      case 'activo':
        return ActivityLevel.active;
      case 'muy_activo':
        return ActivityLevel.veryActive;
      case 'sedentario':
      default:
        return ActivityLevel.sedentary;
    }
  }

  static String _activityLevelToString(ActivityLevel level) {
    switch (level) {
      case ActivityLevel.sedentary:
        return 'sedentario';
      case ActivityLevel.light:
        return 'leve';
      case ActivityLevel.moderate:
        return 'moderado';
      case ActivityLevel.active:
        return 'activo';
      case ActivityLevel.veryActive:
        return 'muy_activo';
    }
  }

  static HypertensionLevel _parseHtaLevel(String? value) {
    switch (value) {
      case 'moderada':
        return HypertensionLevel.moderate;
      case 'severa':
        return HypertensionLevel.severe;
      case 'leve':
      default:
        return HypertensionLevel.mild;
    }
  }

  static String _htaLevelToString(HypertensionLevel level) {
    switch (level) {
      case HypertensionLevel.mild:
        return 'leve';
      case HypertensionLevel.moderate:
        return 'moderada';
      case HypertensionLevel.severe:
        return 'severa';
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
