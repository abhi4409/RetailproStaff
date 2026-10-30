import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../models/login_models.dart';
import '../repository/login_repo.dart';
import '../view/Home/Bottomnavi.dart';
import '../view/Login/Loginpage.dart';


class LoginViewmodel extends ChangeNotifier {
  final LoginModels _model = LoginModels();
  final LoginRepository _repository = LoginRepository();

  TextEditingController email = TextEditingController();
  TextEditingController pass = TextEditingController();
  TextEditingController forgotEmail = TextEditingController();
  TextEditingController name = TextEditingController();
  TextEditingController phone = TextEditingController();

  bool get loading => _model.loading;
  bool get showPassword => _model.showPassword;

  void passwordShow() {
    _model.showPassword = !_model.showPassword;
    notifyListeners();
  }

  Future<void> login(BuildContext context) async {
    try {
      _model.loading = true;
      notifyListeners();

      String result = await _repository.login(
        email.text,
        pass.text,
      );

      if (!context.mounted) return;

      if (result == "not_found") {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("Staff details not found"),
            backgroundColor: Colors.red,
          ),
        );
        return;
      }

      if (result == "not_staff") {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("This account is not a staff account"),
            backgroundColor: Colors.red,
          ),
        );
        return;
      }

      if (result == "approved") {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("Login successful"),
            backgroundColor: Colors.green,
          ),
        );

        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => Bottomnaviga(),
          ),
        );
      } else if (result == "pending") {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("Your account is waiting for admin approval"),
            backgroundColor: Colors.orange,
          ),
        );
      } else if (result == "rejected") {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("Your account has been rejected"),
            backgroundColor: Colors.red,
          ),
        );
      }
    } on FirebaseAuthException catch (e) {
      if (!context.mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(e.message ?? "Login failed"),
          backgroundColor: Colors.red,
        ),
      );
    } finally {
      _model.loading = false;
      notifyListeners();
    }
  }

  Future<void> forgotPassword(BuildContext context) async {
    try {
      String userEmail = forgotEmail.text.trim();

      if (!userEmail.contains("@")) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("Enter a valid email address"),
            backgroundColor: Colors.red,
          ),
        );
        return;
      }

      _model.loading = true;
      notifyListeners();

      await _repository.forgotPassword(userEmail);

      if (!context.mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Password reset link sent to $userEmail"),
          backgroundColor: Colors.green,
        ),
      );

      forgotEmail.clear();
      Navigator.pop(context);
    } on FirebaseAuthException catch (e) {
      if (!context.mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(e.message ?? "Failed to send reset email"),
          backgroundColor: Colors.red,
        ),
      );
    } finally {
      _model.loading = false;
      notifyListeners();
    }
  }

  Future<void> createAccount(BuildContext context) async {
    try {
      _model.loading = true;
      notifyListeners();

      await _repository.createAccount(
        name.text,
        phone.text,
        email.text,
        pass.text,
      );

      if (!context.mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Account created successfully"),
          backgroundColor: Colors.green,
        ),
      );

      name.clear();
      phone.clear();
      email.clear();
      pass.clear();

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => Log(),
        ),
      );
    } on FirebaseAuthException catch (e) {
      if (!context.mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(e.message ?? "Account creation failed"),
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
    email.dispose();
    pass.dispose();
    forgotEmail.dispose();
    name.dispose();
    phone.dispose();
    super.dispose();
  }
}