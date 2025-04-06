// lib/services/api_client.dart
import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;

import 'auth_service.dart';

class ApiClient {
  final String baseUrl =
      dotenv.env['API_URL'] ??
      'http://localhost:3000/api'; // Schimbă cu URL-ul real al API-ului tău
  final AuthService authService;

  ApiClient({required this.authService});

  // GET request cu token
  Future<dynamic> get(String endpoint) async {
    return _requestWithAuth(
      () async =>
          http.get(Uri.parse('$baseUrl/$endpoint'), headers: await _headers()),
    );
  }

  // POST request cu token
  Future<dynamic> post(String endpoint, dynamic data) async {
    return _requestWithAuth(
      () async => http.post(
        Uri.parse('$baseUrl/$endpoint'),
        headers: await _headers(),
        body: jsonEncode(data),
      ),
    );
  }

  // PUT request cu token
  Future<dynamic> put(String endpoint, dynamic data) async {
    return _requestWithAuth(
      () async => http.put(
        Uri.parse('$baseUrl/$endpoint'),
        headers: await _headers(),
        body: jsonEncode(data),
      ),
    );
  }

  // PATCH request cu token
  Future<dynamic> patch(String endpoint, dynamic data) async {
    return _requestWithAuth(
      () async => http.patch(
        Uri.parse('$baseUrl/$endpoint'),
        headers: await _headers(),
        body: jsonEncode(data),
      ),
    );
  }

  // DELETE request cu token
  Future<dynamic> delete(String endpoint) async {
    return _requestWithAuth(
      () async => http.delete(
        Uri.parse('$baseUrl/$endpoint'),
        headers: await _headers(),
      ),
    );
  }

  // Funcție pentru a adăuga token-ul la headers
  Future<Map<String, String>> _headers() async {
    final token = await authService.getAccessToken();
    return {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      if (token != null) 'Authorization': 'Bearer $token',
    };
  }

  // Wrapper pentru a gestiona reîmprospătarea token-ului
  Future<dynamic> _requestWithAuth(
    Future<http.Response> Function() requestFunc,
  ) async {
    try {
      final response = await requestFunc();

      // Verifică dacă răspunsul e autorizat
      if (response.statusCode == 401) {
        // Încearcă să reîmprospătezi token-ul
        try {
          await authService.refreshToken();
          // Încearcă din nou cererea
          final retryResponse = await requestFunc();
          return _processResponse(retryResponse);
        } catch (e) {
          // Dacă refresh token eșuează, delogăm utilizatorul
          await authService.logout();
          throw Exception('Session expired. Please login again.');
        }
      }

      return _processResponse(response);
    } catch (e) {
      throw Exception('Request failed: $e');
    }
  }

  // Procesează răspunsul API
  dynamic _processResponse(http.Response response) {
    if (response.statusCode >= 200 && response.statusCode < 300) {
      // Verifică dacă răspunsul conține conținut
      if (response.body.isEmpty) {
        return null;
      }

      final jsonData = jsonDecode(response.body);
      return jsonData;
    } else {
      // Încearcă să parseze și să returneze eroarea de la API dacă există
      try {
        final errorData = jsonDecode(response.body);
        final errorMessage =
            errorData['message'] ?? errorData['error'] ?? 'Unknown error';
        throw Exception('API Error (${response.statusCode}): $errorMessage');
      } catch (e) {
        // Dacă nu se poate parsa JSON-ul, aruncă o eroare generică
        throw Exception('Request failed with status: ${response.statusCode}');
      }
    }
  }

  // Metodă pentru upload de fișiere
  Future<dynamic> uploadFile(
    String endpoint,
    String filePath,
    String fileField, {
    Map<String, String>? fields,
  }) async {
    try {
      final token = await authService.getAccessToken();
      final uri = Uri.parse('$baseUrl/$endpoint');

      var request = http.MultipartRequest('POST', uri);

      // Adaugă headers
      request.headers.addAll({
        'Authorization': token != null ? 'Bearer $token' : '',
        'Accept': 'application/json',
      });

      // Adaugă câmpuri suplimentare dacă există
      if (fields != null) {
        request.fields.addAll(fields);
      }

      // Adaugă fișierul
      request.files.add(await http.MultipartFile.fromPath(fileField, filePath));

      // Trimite cererea
      final streamedResponse = await request.send();
      final response = await http.Response.fromStream(streamedResponse);

      // Dacă e 401, încearcă refresh token
      if (response.statusCode == 401) {
        try {
          await authService.refreshToken();
          // Recrează cererea după refresh token
          return await uploadFile(
            endpoint,
            filePath,
            fileField,
            fields: fields,
          );
        } catch (e) {
          await authService.logout();
          throw Exception('Session expired. Please login again.');
        }
      }

      return _processResponse(response);
    } catch (e) {
      throw Exception('File upload failed: $e');
    }
  }
}
