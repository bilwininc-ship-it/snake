import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import '../errors/exceptions.dart';

/// API Client for HTTP requests
/// HTTP istekleri için API istemcisi

class ApiClient {
  final http.Client client;
  final String baseUrl;

  ApiClient({
    required this.client,
    required this.baseUrl,
  });

  /// GET request
  Future<Map<String, dynamic>> get(
    String endpoint, {
    Map<String, String>? headers,
    Map<String, dynamic>? queryParameters,
  }) async {
    try {
      final uri = _buildUri(endpoint, queryParameters);
      final response = await client.get(
        uri,
        headers: _buildHeaders(headers),
      ).timeout(const Duration(seconds: 30));

      return _handleResponse(response);
    } on SocketException {
      throw NetworkException(message: 'No internet connection');
    } on HttpException {
      throw NetworkException(message: 'HTTP error occurred');
    } on FormatException {
      throw ServerException(message: 'Bad response format');
    }
  }

  /// POST request
  Future<Map<String, dynamic>> post(
    String endpoint, {
    Map<String, String>? headers,
    Map<String, dynamic>? body,
  }) async {
    try {
      final uri = _buildUri(endpoint);
      final response = await client.post(
        uri,
        headers: _buildHeaders(headers),
        body: body != null ? jsonEncode(body) : null,
      ).timeout(const Duration(seconds: 30));

      return _handleResponse(response);
    } on SocketException {
      throw NetworkException(message: 'No internet connection');
    } on HttpException {
      throw NetworkException(message: 'HTTP error occurred');
    } on FormatException {
      throw ServerException(message: 'Bad response format');
    }
  }

  /// PUT request
  Future<Map<String, dynamic>> put(
    String endpoint, {
    Map<String, String>? headers,
    Map<String, dynamic>? body,
  }) async {
    try {
      final uri = _buildUri(endpoint);
      final response = await client.put(
        uri,
        headers: _buildHeaders(headers),
        body: body != null ? jsonEncode(body) : null,
      ).timeout(const Duration(seconds: 30));

      return _handleResponse(response);
    } on SocketException {
      throw NetworkException(message: 'No internet connection');
    } on HttpException {
      throw NetworkException(message: 'HTTP error occurred');
    } on FormatException {
      throw ServerException(message: 'Bad response format');
    }
  }

  /// DELETE request
  Future<Map<String, dynamic>> delete(
    String endpoint, {
    Map<String, String>? headers,
  }) async {
    try {
      final uri = _buildUri(endpoint);
      final response = await client.delete(
        uri,
        headers: _buildHeaders(headers),
      ).timeout(const Duration(seconds: 30));

      return _handleResponse(response);
    } on SocketException {
      throw NetworkException(message: 'No internet connection');
    } on HttpException {
      throw NetworkException(message: 'HTTP error occurred');
    } on FormatException {
      throw ServerException(message: 'Bad response format');
    }
  }

  /// Build URI with query parameters
  Uri _buildUri(String endpoint, [Map<String, dynamic>? queryParameters]) {
    final uri = Uri.parse('$baseUrl$endpoint');
    if (queryParameters != null && queryParameters.isNotEmpty) {
      return uri.replace(queryParameters: queryParameters);
    }
    return uri;
  }

  /// Build headers
  Map<String, String> _buildHeaders(Map<String, String>? customHeaders) {
    final headers = <String, String>{
      'Content-Type': 'application/json',
      'Accept': 'application/json',
    };

    if (customHeaders != null) {
      headers.addAll(customHeaders);
    }

    return headers;
  }

  /// Handle HTTP response
  Map<String, dynamic> _handleResponse(http.Response response) {
    if (response.statusCode >= 200 && response.statusCode < 300) {
      if (response.body.isEmpty) {
        return {};
      }
      return jsonDecode(response.body) as Map<String, dynamic>;
    } else if (response.statusCode == 401) {
      throw AuthenticationException(message: 'Unauthorized');
    } else if (response.statusCode == 404) {
      throw ServerException(
        message: 'Resource not found',
        statusCode: 404,
      );
    } else if (response.statusCode >= 500) {
      throw ServerException(
        message: 'Server error',
        statusCode: response.statusCode,
      );
    } else {
      throw ServerException(
        message: 'Request failed',
        statusCode: response.statusCode,
      );
    }
  }
}
