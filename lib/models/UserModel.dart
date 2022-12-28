class UserModel {
  late String accountStatus;
  late String appVersion;
  var createdAt;
  late String deviceToken;
  late String email;
  late String firstName;
  late String gender;
  late String middleName;
  late bool onlineStatus;
  late String phoneNumber;
  late String profilePhoto;
  late String role;
  late String userId;
  late String surname;
  late String username;

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
      required this.role,
      required this.userId,
      required this.surname,
      required this.username});

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
    user["role"] = role;
    user["userId"] = userId;
    user["surname"] = surname;
    user["username"] = username;
    return user;
  }

  UserModel.fromFirebase(Map<dynamic, dynamic>? data) {
    accountStatus = data?["accountStatus"];
    appVersion = data?["appVersion"];
    createdAt = data?["createdAt"];
    deviceToken = data?["deviceToken"];
    email = data?["email"];
    firstName = data?["firstName"];
    gender = data?["gender"];
    middleName = data?["middleName"];
    onlineStatus = data?["onlineStatus"];
    phoneNumber = data?["phoneNumber"];
    profilePhoto = data?["profilePhoto"];
    role = data?["role"];
    surname = data?["surname"];
    userId = data?["userId"];
    username = data?["username"];
  }
}
