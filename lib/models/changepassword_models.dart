class ChangepasswordModels {
  String currentPassword;
  String newPassword;
  String reenterPassword;
  bool loading;

  ChangepasswordModels({
    this.currentPassword = "",
    this.newPassword = "",
    this.reenterPassword = "",
    this.loading = false,
  });
}