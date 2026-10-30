import 'package:firebase_auth/firebase_auth.dart';

class ChangepasswordServices {
  final FirebaseAuth auth = FirebaseAuth.instance;

  Future<void> changePassword(
      String currentPassword,
      String newPassword,
      ) async {
    User? user = auth.currentUser;

    if (user == null || user.email == null) {
      return;
    }

    AuthCredential credential = EmailAuthProvider.credential(
      email: user.email!,
      password: currentPassword,
    );

    await user.reauthenticateWithCredential(credential);
    await user.updatePassword(newPassword);
  }
}