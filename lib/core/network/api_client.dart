import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import '../constants/api_constants.dart';
import '../errors/exceptions.dart';
import '../services/auth_token_service.dart';

/// HTTP client wrapper that handles JWT authentication and API communication.
class ApiClient {
  final http.Client httpClient;
  final AuthTokenService authTokenService;

  ApiClient({
    required this.httpClient,
    required this.authTokenService,
  });

  /// Common headers for all requests.
  Map<String, String> get _headers {
    final headers = <String, String>{
      'Content-Type': 'application/json',
      'Accept': 'application/json',
    };
    final token = authTokenService.getToken();
    if (token != null) {
      headers['Authorization'] = 'Bearer $token';
    }
    return headers;
  }

  /// GET request.
  Future<dynamic> get(
    String endpoint, {
    Map<String, String>? queryParams,
  }) async {
    final uri = Uri.parse('${ApiConstants.baseUrl}$endpoint').replace(
      queryParameters: queryParams,
    );
    try {
      final response = await httpClient.get(uri, headers: _headers);
      return _handleResponse(response);
    } on SocketException {
      throw ServerException();
    }
  }

  /// POST request.
  Future<dynamic> post(
    String endpoint, {
    Map<String, dynamic>? body,
  }) async {
    final uri = Uri.parse('${ApiConstants.baseUrl}$endpoint');
    try {
      final response = await httpClient.post(
        uri,
        headers: _headers,
        body: body != null ? json.encode(body) : null,
      );
      return _handleResponse(response);
    } on SocketException {
      throw ServerException();
    }
  }

  /// PUT request.
  Future<dynamic> put(
    String endpoint, {
    Map<String, dynamic>? body,
  }) async {
    final uri = Uri.parse('${ApiConstants.baseUrl}$endpoint');
    try {
      final response = await httpClient.put(
        uri,
        headers: _headers,
        body: body != null ? json.encode(body) : null,
      );
      return _handleResponse(response);
    } on SocketException {
      throw ServerException();
    }
  }

  /// DELETE request.
  Future<dynamic> delete(String endpoint) async {
    final uri = Uri.parse('${ApiConstants.baseUrl}$endpoint');
    try {
      final response = await httpClient.delete(uri, headers: _headers);
      return _handleResponse(response);
    } on SocketException {
      throw ServerException();
    }
  }

  /// Process the HTTP response and handle errors.
  dynamic _handleResponse(http.Response response) {
    switch (response.statusCode) {
      case 200:
      case 201:
        if (response.body.isEmpty) return null;
        return json.decode(response.body);
      case 401:
        throw UnauthorizedException();
      case 404:
        throw NotFoundException();
      case 422:
        final body = json.decode(response.body);
        throw ValidationException(
          message: body['message'] ?? 'Error de validación',
          errors: body['errors'] ?? {},
        );
      default:
        throw ServerException();
    }
  }
}
