import 'dart:typed_data';

class ProfileModels {
  String? docid;

  bool edit;
  bool loading;
  bool imageUploading;

  Uint8List? profileImage;
  String profileImageUrl;

  ProfileModels({
    this.docid,
    this.edit = false,
    this.loading = true,
    this.imageUploading = false,
    this.profileImage,
    this.profileImageUrl = "",
  });
}