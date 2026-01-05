import 'package:doaniot/features/auth/domain/entities/user.dart';

/// This is the CONTRACT for the Backend Developer.
/// They must implement these methods in the data layer.
abstract class AuthRepository {
  /// Logs in a user with email and password.
  /// Returns a [User] if successful, throws an Exception otherwise.
  Future<User> login(String email, String password);

  /// Registers a new user.
  Future<User> register(String name, String email, String password);

  /// Signs out the current user.
  Future<void> logout();
  
  /// Helper to get current logged in user (if any)
  Future<User?> getCurrentUser();
}
