// lib/services/auth_service.dart
import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:crypto/crypto.dart';

import '../models/user.dart';
import 'api_client.dart';

class AuthService {
  final FlutterSecureStorage _storage = FlutterSecureStorage();
  late ApiClient _apiClient;

  AuthService() {
    _apiClient = ApiClient(authService: this);
  }

  // Salvează datele de autentificare
  Future<void> saveAuthData(
    String accessToken,
    String refreshToken,
    User? user,
  ) async {
    await _storage.write(key: 'accessToken', value: accessToken);
    await _storage.write(key: 'refreshToken', value: refreshToken);

    // Salvează userul doar dacă există
    if (user != null) {
      await _storage.write(key: 'user', value: jsonEncode(user.toJson()));
    }
  }

  Future<User?> getCurrentUser() async {
    final userJson = await _storage.read(key: 'user');
    if (userJson == null) return null;
    return User.fromJson(jsonDecode(userJson));
  }

  Future<String?> getAccessToken() async {
    return await _storage.read(key: 'accessToken');
  }

  Future<String?> getRefreshToken() async {
    return await _storage.read(key: 'refreshToken');
  }

  // Login
  Future<void> login(String email, String password) async {
    final hashedPassword = md5.convert(utf8.encode(password)).toString();

    try {
      final response = await _apiClient.post('auth/login', {
        'email': email,
        'password': hashedPassword,
      });

      // Extrage doar tokenurile
      final accessToken = response['accessToken'].toString();
      final refreshToken = response['refreshToken'].toString();

      // Salvează doar tokenurile
      await _storage.write(key: 'accessToken', value: accessToken);
      await _storage.write(key: 'refreshToken', value: refreshToken);
    } catch (e) {
      print('Login error: $e');
      rethrow;
    }
  }

  Future<User> fetchCurrentUser() async {
    try {
      final response = await _apiClient.get('auth/user');
      return User.fromJson(response);
    } catch (e) {
      print('Fetch user error: $e');
      rethrow;
    }
  }

  // Reîmprospătare token
  Future<void> refreshToken() async {
    final refreshToken = await getRefreshToken();

    if (refreshToken == null) {
      throw Exception('No refresh token found');
    }

    try {
      final response = await _apiClient.post('auth/refresh', {
        'refreshToken': refreshToken,
      });

      final accessToken = response['accessToken'];
      final newRefreshToken = response['refreshToken'];

      // Nu mai încerca să salvezi userul la refresh token
      await _storage.write(key: 'accessToken', value: accessToken);
      await _storage.write(key: 'refreshToken', value: newRefreshToken);
    } catch (e) {
      await logout();
      throw Exception('Failed to refresh token');
    }
  }

  // Logout
  Future<void> logout() async {
    try {
      final accessToken = await getAccessToken();
      final refreshToken = await getRefreshToken();

      // Notifică serverul despre logout pentru a invalida token-urile
      if (accessToken != null && refreshToken != null) {
        await _apiClient.post('auth/logout', {'refreshToken': refreshToken});
      }
    } catch (e) {
      print('Failed to notify server about logout: $e');
    } finally {
      // Șterge datele din storage local
      await _storage.delete(key: 'user');
      await _storage.delete(key: 'accessToken');
      await _storage.delete(key: 'refreshToken');
    }
  }

  // Metodă pentru înregistrare
  Future<User> register(
    String name,
    String email,
    String password,
    String phone,
  ) async {
    try {
      final response = await _apiClient.post('auth/register', {
        'name': name,
        'email': email,
        'password': password, // Backend-ul ar trebui să hasheze parola
        'phone': phone,
      });

      final user = User.fromJson(response['user']);
      final accessToken = response['accessToken'];
      final refreshToken = response['refreshToken'];

      // Salvează tokenurile și userul
      await saveAuthData(accessToken, refreshToken, user);

      return user;
    } catch (e) {
      throw Exception('Registration failed: $e');
    }
  }
}
