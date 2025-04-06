// lib/providers/auth_provider.dart
import 'package:flutter/material.dart';
import 'package:pitstop_app/models/roles.dart';
import '../models/user.dart';
import '../services/auth_service.dart';

class AuthProvider with ChangeNotifier {
  final AuthService _authService;

  User? _currentUser;
  bool _isLoading = false;
  String? _error;

  AuthProvider({required AuthService authService}): _authService = authService {
    _loadUser();
  }

  User? get currentUser => _currentUser;
  bool get isLoading => _isLoading;
  bool get isAuthenticated => _currentUser != null;
  String? get error => _error;

  Future<void> _loadUser() async {
    _isLoading = true;
    notifyListeners();

    try {
      _currentUser = await _authService.getCurrentUser();
      _error = null;
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<bool> login(String email, String password) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      // Doar login, fără preluare user
      await _authService.login(email, password);

      // Dacă vrei user, fă un request separat
      _currentUser = await _authService.fetchCurrentUser();

      return true;
    } catch (e) {
      _error = 'Login failed: ${e.toString()}';
      _currentUser = null;
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<bool> register(
    String name,
    String email,
    String password,
    String phone,
  ) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      // Înregistrarea returnează deja userul
      _currentUser = await _authService.register(name, email, password, phone);
      return true;
    } catch (e) {
      _error = 'Registration failed: ${e.toString()}';
      _currentUser = null;
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> logout() async {
    _isLoading = true;
    notifyListeners();

    try {
      await _authService.logout();
      _currentUser = null;
      _error = null;
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Metodă pentru verificarea permisiunilor
  bool hasRole(Role role) {
    return _currentUser?.role == role;
  }
}
