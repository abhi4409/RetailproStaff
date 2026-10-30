import '../services/changepassword_services.dart';

class ChangepasswordRepository {
  final ChangepasswordServices _services =
  ChangepasswordServices();

  Future<void> changePassword(
      String currentPassword,
      String newPassword,
      ) async {
    await _services.changePassword(
      currentPassword,
      newPassword,
    );
  }
}