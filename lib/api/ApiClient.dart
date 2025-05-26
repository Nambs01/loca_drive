import 'dart:convert';

import 'package:http/http.dart' as http;

class ApiClient {
  static const String _baseUrl = 'http://192.168.100.157:8080';

  final http.Client _client;

  ApiClient({http.Client? client}) : _client = client ?? http.Client();

  Uri _buildUri(String endpoint, [Map<String, dynamic>? queryParams]) {
    return Uri.parse('$_baseUrl$endpoint').replace(queryParameters: queryParams);
  }

  Future<http.Response> get(String endpoint, {Map<String, dynamic>? params}) async {
    final uri = _buildUri(endpoint, params);
    return await _client.get(uri, headers: _headers());
  }

  Future<http.Response> post(String endpoint, {Object? body}) async {
    final uri = _buildUri(endpoint);
    return await
      _client.post(
        uri,
        headers: _headers(),
        body: body != null ? jsonEncode(body) : null,
    );
  }

  Future<http.Response> delete(String endpoint) async {
    final uri = _buildUri(endpoint);
    return await _client.delete(uri, headers: _headers());
  }

  Future<http.Response> put(String endpoint, {Object? body}) async {
    final uri = _buildUri(endpoint);
    return await _client.put(
      uri,
      headers: _headers(),
      body: body != null ? jsonEncode(body) : null,
    );
  }

  Map<String, String> _headers() {
    return {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
    };
  }
}