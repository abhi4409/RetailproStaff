import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import '../models/profile_models.dart';
import '../repository/profile_repo.dart';

class ProfileViewmodel extends ChangeNotifier {
  final ProfileModels _model =
  ProfileModels();

  final ProfileRepository _repository = ProfileRepository();

  TextEditingController name =
  TextEditingController();

  TextEditingController phone =
  TextEditingController();

  TextEditingController email =
  TextEditingController();

  TextEditingController role =
  TextEditingController();

  ProfileViewmodel() {
    getProfile();
  }

  String? get docid =>
      _model.docid;

  bool get edit =>
      _model.edit;

  bool get loading =>
      _model.loading;

  bool get imageUploading =>
      _model.imageUploading;

  Uint8List? get profileImage =>
      _model.profileImage;

  String get profileImageUrl =>
      _model.profileImageUrl;

  Future getProfile() async {
    _model.loading =
    true;

    notifyListeners();

    try {
      var user =
      _repository.getCurrentUser();

      if (user == null) {
        return;
      }

      var data =
      await _repository.getStaffByUid(
        user.uid,
      );

      if (data.docs.isNotEmpty) {
        var snap =
            data.docs.first;

        var staffData =
        snap.data();

        _model.docid =
            snap.id;

        name.text =
            staffData['name']
                ?.toString() ??
                "";

        phone.text =
            staffData['phone']
                ?.toString() ??
                "";

        email.text =
            staffData['email']
                ?.toString() ??
                user.email ??
                "";

        role.text =
            staffData['role']
                ?.toString() ??
                "staff";

        _model.profileImageUrl =
            staffData['profileImage']
                ?.toString() ??
                "";
      } else {
        var emailData =
        await _repository
            .getStaffByEmail(
          user.email,
        );

        if (emailData.docs.isNotEmpty) {
          var snap =
              emailData.docs.first;

          var staffData =
          snap.data();

          _model.docid =
              snap.id;

          name.text =
              staffData['name']
                  ?.toString() ??
                  "";

          phone.text =
              staffData['phone']
                  ?.toString() ??
                  "";

          email.text =
              staffData['email']
                  ?.toString() ??
                  user.email ??
                  "";

          role.text =
              staffData['role']
                  ?.toString() ??
                  "staff";

          _model.profileImageUrl =
              staffData['profileImage']
                  ?.toString() ??
                  "";

          await _repository.updateStaff(
            snap.id,
            {
              'uid': user.uid,
            },
          );
        }
      }
    } catch (e) {
      debugPrint(
        "Profile Error: $e",
      );
    } finally {
      _model.loading =
      false;

      notifyListeners();
    }
  }

  Future pickProfileImage(
      BuildContext context,
      ) async {
    try {
      XFile? picked =
      await _repository.pickImage();

      if (picked == null) {
        return;
      }

      var user =
      _repository.getCurrentUser();

      if (user == null) {
        return;
      }

      _model.imageUploading =
      true;

      notifyListeners();

      Uint8List bytes =
      await _repository.getImageBytes(
        picked,
      );

      _model.profileImage =
          bytes;

      String imageUrl =
      await _repository.uploadProfileImage(
        user.uid,
        picked,
        bytes,
      );

      _model.profileImageUrl =
          imageUrl;

      if (_model.docid != null) {
        await _repository.updateStaff(
          _model.docid!,
          {
            'profileImage':
            imageUrl,
          },
        );
      }

      if (!context.mounted) {
        return;
      }

      ScaffoldMessenger.of(context)
          .showSnackBar(
        SnackBar(
          content: Text(
            "Profile picture updated successfully",
          ),
          backgroundColor:
          Colors.green,
        ),
      );
    } catch (e) {
      debugPrint(
        "IMAGE ERROR: $e",
      );

      if (!context.mounted) {
        return;
      }

      ScaffoldMessenger.of(context)
          .showSnackBar(
        SnackBar(
          content: Text(
            "Image upload failed $e",
          ),
          backgroundColor:
          Colors.red,
        ),
      );
    } finally {
      _model.imageUploading =
      false;

      notifyListeners();
    }
  }

  void enableEdit() {
    _model.edit =
    true;

    notifyListeners();
  }

  Future updateProfile(
      BuildContext context,
      ) async {
    if (_model.docid == null) {
      return;
    }

    try {
      await _repository.updateStaff(
        _model.docid!,
        {
          'name':
          name.text,
          'phone':
          phone.text,
          'profileImage':
          _model.profileImageUrl,
        },
      );

      _model.edit =
      false;

      notifyListeners();

      if (!context.mounted) {
        return;
      }

      ScaffoldMessenger.of(context)
          .showSnackBar(
        SnackBar(
          content: Text(
            "Profile updated successfully",
          ),
          backgroundColor:
          Colors.green,
        ),
      );
    } catch (e) {
      if (!context.mounted) {
        return;
      }

      ScaffoldMessenger.of(context)
          .showSnackBar(
        SnackBar(
          content: Text(
            "Profile update failed $e",
          ),
          backgroundColor:
          Colors.red,
        ),
      );
    }
  }

  Future signOut() async {
    await _repository.signOut();
  }

  @override
  void dispose() {
    name.dispose();
    phone.dispose();
    email.dispose();
    role.dispose();

    super.dispose();
  }
}