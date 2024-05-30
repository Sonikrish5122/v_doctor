class User {
  String? userId;
  String? userType;
  String? accessToken;
  String? refreshToken;
  bool? isDoctor;
  bool? isPatient;

  User(
      {this.userId,
      this.userType,
      this.accessToken,
      this.refreshToken,
      this.isDoctor,
      this.isPatient});

  User.fromJson(Map<String, dynamic> json) {
    userId = json['user_id'];
    userType = json['userType'];
    accessToken = json['access_token'];
    refreshToken = json['refresh_token'];
    isDoctor = json['isDoctor'];
    isPatient = json['isPatient'];
  }

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
}
