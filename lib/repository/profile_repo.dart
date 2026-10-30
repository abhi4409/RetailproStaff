import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:image_picker/image_picker.dart';

import '../services/profile_services.dart';

class ProfileRepository {
  final ProfileServices _services =
  ProfileServices();

  User? getCurrentUser() {
    return _services.getCurrentUser();
  }

  Future<QuerySnapshot<Map<String, dynamic>>> getStaffByUid(
      String uid,
      ) async {
    return await _services.getStaffByUid(
      uid,
    );
  }

  Future<QuerySnapshot<Map<String, dynamic>>> getStaffByEmail(
      String? email,
      ) async {
    return await _services.getStaffByEmail(
      email,
    );
  }

  Future<void> updateStaff(
      String docid,
      Map<String, dynamic> data,
      ) async {
    await _services.updateStaff(
      docid,
      data,
    );
  }

  Future<XFile?> pickImage() async {
    return await _services.pickImage();
  }

  Future<Uint8List> getImageBytes(
      XFile picked,
      ) async {
    return await _services.getImageBytes(
      picked,
    );
  }

  Future<String> uploadProfileImage(
      String uid,
      XFile picked,
      Uint8List bytes,
      ) async {
    return await _services.uploadProfileImage(
      uid,
      picked,
      bytes,
    );
  }

  Future<void> signOut() async {
    await _services.signOut();
  }
}