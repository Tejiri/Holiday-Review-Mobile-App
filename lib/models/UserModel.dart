class UserModel {
  String accountStatus;
  String appVersion;
  var createdAt;
  String deviceToken;
  String email;
  String firstName;
  String gender;
  String middleName;
  bool onlineStatus;
  String phoneNumber;
  String profilePhoto;
  String userId;
  String surname;

  UserModel(
      {required this.accountStatus,
      required this.appVersion,
      required this.createdAt,
      required this.deviceToken,
      required this.email,
      required this.firstName,
      required this.gender,
      required this.middleName,
      required this.onlineStatus,
      required this.phoneNumber,
      required this.profilePhoto,
      required this.userId,
      required this.surname});

  Map<String, dynamic> toMap() {
    Map<String, dynamic> user = Map<String, dynamic>();
    user["accountStatus"] = accountStatus;
    user["appVersion"] = appVersion;
    user["createdAt"] = createdAt;
    user["deviceToken"] = deviceToken;
    user["email"] = email;
    user["firstName"] = firstName;
    user["gender"] = gender;
    user["middleName"] = middleName;
    user["onlineStatus"] = onlineStatus;
    user["phoneNumber"] = phoneNumber;
    user["profilePhoto"] = profilePhoto;
    user["userId"] = userId;
    user["surname"] = surname;
    return user;
  }
}
