import 'package:belajarfirebase/models/user_model.dart';
import 'package:belajarfirebase/services/auth_service.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AuthProvider {
  final _authService = AuthService();

  //provider for auth change
  Stream<User?> get authUserProvider {
    return _authService.auth.authStateChanges();
  }
}