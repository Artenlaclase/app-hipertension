class ServerException implements Exception {
  final String? message;
  ServerException([this.message]);

  @override
  String toString() => message ?? 'Error del servidor';
}

class CacheException implements Exception {
  final String? message;
  CacheException([this.message]);
}

class UnauthorizedException implements Exception {
  final String message;
  UnauthorizedException([
    this.message = 'No autorizado. Inicie sesión nuevamente.',
  ]);
}

class NotFoundException implements Exception {
  final String message;
  NotFoundException([this.message = 'Recurso no encontrado.']);
}

class ValidationException implements Exception {
  final String message;
  final Map<String, dynamic> errors;

  ValidationException({
    this.message = 'Error de validación',
    this.errors = const {},
  });

  @override
  String toString() => message;
}
