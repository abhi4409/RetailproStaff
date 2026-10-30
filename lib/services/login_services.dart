import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class LoginServices {
  final FirebaseAuth auth = FirebaseAuth.instance;

  final CollectionReference<Map<String, dynamic>> staff =
  FirebaseFirestore.instance.collection('staffdata');

  Future<String> login(
      String email,
      String password,
      ) async {
    UserCredential userCredential = await auth.signInWithEmailAndPassword(
      email: email.trim(),
      password: password.trim(),
    );

    String? uid = userCredential.user?.uid;
    if (uid == null) {
      await auth.signOut();
      return "not_found";
    }

    var check = await staff
        .where(
      'uid',
      isEqualTo: uid,
    )
        .limit(1)
        .get();

    if (check.docs.isEmpty) {
      await auth.signOut();
      return "not_found";
    }

    var data = check.docs.first.data();

    String status =
        data['status']?.toString().trim().toLowerCase() ?? "pending";
    String role = data['role']?.toString().trim().toLowerCase() ?? "";

    if (role != "staff") {
      await auth.signOut();
      return "not_staff";
    }

    if (status == "pending") {
      await auth.signOut();
      return "pending";
    }

    if (status == "rejected") {
      await auth.signOut();
      return "rejected";
    }

    return status;
  }

  Future<void> forgotPassword(String email) async {
    await auth.sendPasswordResetEmail(
      email: email.trim(),
    );
  }

  Future<void> createAccount(
      String name,
      String phone,
      String email,
      String password,
      ) async {
    UserCredential userCredential =
    await auth.createUserWithEmailAndPassword(
      email: email.trim(),
      password: password.trim(),
    );

    String? uid = userCredential.user?.uid;

    if (uid != null) {
      await staff.doc(uid).set({
        'uid': uid,
        'name': name.trim(),
        'phone': phone.trim(),
        'email': email.trim(),
        'role': 'staff',
        'status': 'pending',
        'createdAt': FieldValue.serverTimestamp(),
      });
    }

    await auth.signOut();
  }
}