class AppConstants {
  // Presión arterial - rangos (mmHg)
  static const double systolicNormalMax = 120;
  static const double systolicElevatedMax = 129;
  static const double systolicHighMax = 139;
  static const double systolicCrisis = 180;

  static const double diastolicNormalMax = 80;
  static const double diastolicElevatedMax = 80;
  static const double diastolicHighMax = 89;
  static const double diastolicCrisis = 120;

  // Nutrición DASH - límites diarios recomendados
  static const double maxDailySodiumMg = 1500; // mg para HTA
  static const double minDailyPotassiumMg = 4700; // mg
  static const double maxDailySaturatedFatG = 13; // g (6% de 2000 kcal)

  // App
  static const String appName = 'HTApp';
  static const String appVersion = '1.0.0';

  // Disclaimer
  static const String disclaimerText =
      'Esta aplicación es una herramienta de apoyo educativo y de seguimiento '
      'de hábitos. NO reemplaza el diagnóstico ni el tratamiento médico. '
      'Consulte siempre a su médico antes de realizar cambios en su dieta '
      'o medicación. La información proporcionada se basa en guías '
      'internacionales como la dieta DASH (Dietary Approaches to Stop '
      'Hypertension) de la OMS y el NIH.';
}
