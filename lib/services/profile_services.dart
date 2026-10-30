import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:image_picker/image_picker.dart';
import 'package:supabase_flutter/supabase_flutter.dart' hide User;

class ProfileServices {
  final CollectionReference<Map<String, dynamic>> staff =
  FirebaseFirestore.instance.collection(
    'staffdata',
  );

  User? getCurrentUser() {
    return FirebaseAuth.instance.currentUser;
  }

  Future<QuerySnapshot<Map<String, dynamic>>> getStaffByUid(
      String uid,
      ) async {
    return await staff
        .where(
      'uid',
      isEqualTo: uid,
    )
        .get();
  }

  Future<QuerySnapshot<Map<String, dynamic>>> getStaffByEmail(
      String? email,
      ) async {
    return await staff
        .where(
      'email',
      isEqualTo: email,
    )
        .get();
  }

  Future<void> updateStaff(
      String docid,
      Map<String, dynamic> data,
      ) async {
    await staff
        .doc(docid)
        .update(
      data,
    );
  }

  Future<XFile?> pickImage() async {
    ImagePicker picker =
    ImagePicker();

    return await picker.pickImage(
      source: ImageSource.gallery,
      maxWidth: 1024,
      imageQuality: 85,
    );
  }

  Future<Uint8List> getImageBytes(
      XFile picked,
      ) async {
    return await picked.readAsBytes();
  }

  Future<String> uploadProfileImage(
      String uid,
      XFile picked,
      Uint8List bytes,
      ) async {
    String extension =
        "jpg";

    if (picked.name.contains(".")) {
      extension =
          picked.name
              .split(".")
              .last
              .toLowerCase();
    }

    String fileName =
        "${uid}_${DateTime.now().millisecondsSinceEpoch}.$extension";

    String path =
        "staffprofiles/$fileName";

    await Supabase.instance.client.storage
        .from(
      'Produtimages',
    )
        .uploadBinary(
      path,
      bytes,
    );

    String imageUrl =
    Supabase.instance.client.storage
        .from(
      'Produtimages',
    )
        .getPublicUrl(
      path,
    );

    return imageUrl;
  }

  Future<void> signOut() async {
    await FirebaseAuth.instance.signOut();
  }
}