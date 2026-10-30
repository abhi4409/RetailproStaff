import '../services/login_services.dart';

class LoginRepository {
  final LoginServices _services = LoginServices();

  Future<String> login(
      String email,
      String password,
      ) =>
      _services.login(
        email,
        password,
      );

  Future<void> forgotPassword(String email) => _services.forgotPassword(email);

  Future<void> createAccount(
      String name,
      String phone,
      String email,
      String password,
      ) =>
      _services.createAccount(
        name,
        phone,
        email,
        password,
      );
}