class LoginRequestModel {
  String email;
  String password;

  LoginRequestModel({required this.email, required this.password});

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['email'] = this.email;
    data['password'] = this.password;
    return data;
  }
}

class LoginResponseModel {
  final bool success;
  final String message;
  final List<UserData> data;

  LoginResponseModel({
    required this.success,
    required this.message,
    required this.data,
  });

  factory LoginResponseModel.fromJson(Map<String, dynamic> json) {
    return LoginResponseModel(
      success: json['success'],
      message: json['message'],
      data: List<UserData>.from(json['data'].map((x) => UserData.fromJson(x))),
    );
  }
}

class UserData {
  final String userId;
  final String userType;
  final String accessToken;
  final String refreshToken;
  final bool isDoctor;
  final bool isPatient;

  UserData({
    required this.userId,
    required this.userType,
    required this.accessToken,
    required this.refreshToken,
    required this.isDoctor,
    required this.isPatient,
  });

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['user_id'] = this.userId;
    data['userType'] = this.userType;
    data['access_token'] = this.accessToken;
    data['refresh_token'] = this.refreshToken;
    data['isDoctor'] = this.isDoctor;
    data['isPatient'] = this.isPatient;
    return data;
  }

  factory UserData.fromJson(Map<String, dynamic> json) {
    return UserData(
      userId: json['user_id'],
      userType: json['userType'],
      accessToken: json['access_token'],
      refreshToken: json['refresh_token'],
      isDoctor: json['isDoctor'],
      isPatient: json['isPatient'],
    );
  }
}
