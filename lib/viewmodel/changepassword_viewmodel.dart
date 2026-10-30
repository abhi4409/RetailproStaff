import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../models/changepassword_models.dart';
import '../repository/changepassword_repo.dart';

class ChangePasswordViewmodel extends ChangeNotifier {
  final ChangepasswordModels _model = ChangepasswordModels();
  final ChangepasswordRepository _repository = ChangepasswordRepository();

  TextEditingController currentPassword = TextEditingController();
  TextEditingController newPassword = TextEditingController();
  TextEditingController reenterPassword = TextEditingController();

  bool get loading => _model.loading;

  Future<void> changePassword(BuildContext context) async {
    if (currentPassword.text.isEmpty ||
        newPassword.text.isEmpty ||
        reenterPassword.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Please enter all fields"),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    if (newPassword.text != reenterPassword.text) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("New passwords do not match"),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    if (newPassword.text.length < 6) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Password must have at least 6 characters"),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    try {
      _model.loading = true;
      notifyListeners();

      _model.currentPassword = currentPassword.text;
      _model.newPassword = newPassword.text;
      _model.reenterPassword = reenterPassword.text;

      await _repository.changePassword(
        _model.currentPassword,
        _model.newPassword,
      );

      currentPassword.clear();
      newPassword.clear();
      reenterPassword.clear();

      if (!context.mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Password changed successfully"),
          backgroundColor: Colors.green,
        ),
      );
    } on FirebaseAuthException catch (e) {
      if (!context.mounted) return;

      String errorMessage;
      if (e.code == "wrong-password" || e.code == "invalid-credential") {
        errorMessage = "Current password is incorrect";
      } else if (e.code == "weak-password") {
        errorMessage = "New password is too weak";
      } else {
        errorMessage = e.message ?? "Password change failed";
      }

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(errorMessage),
          backgroundColor: Colors.red,
        ),
      );
    } finally {
      _model.loading = false;
      notifyListeners();
    }
  }

  @override
  void dispose() {
    currentPassword.dispose();
    newPassword.dispose();
    reenterPassword.dispose();
    super.dispose();
  }
}