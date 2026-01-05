import 'package:doaniot/features/auth/domain/entities/user.dart';
import 'package:doaniot/features/auth/domain/repositories/auth_repository.dart';

class MockAuthRepository implements AuthRepository {
  @override
  Future<User> login(String email, String password) async {
    // Simulate Network Delay
    await Future.delayed(const Duration(seconds: 2));

    // Simulate API Check
    if (email == 'error@test.com') {
      throw Exception('Invalid Credentials');
    }

    // Return dummy user
    return User(
      id: '123',
      email: email,
      name: 'Test User',
      token: 'fake_jwt_token',
    );
  }

  @override
  Future<void> logout() async {
    await Future.delayed(const Duration(milliseconds: 500));
  }

  @override
  Future<User> register(String name, String email, String password) async {
    await Future.delayed(const Duration(seconds: 2));
    return User(
      id: '456',
      email: email,
      name: name,
      token: 'fake_jwt_token',
    );
  }

  @override
  Future<User?> getCurrentUser() async {
    return null;
  }
}
