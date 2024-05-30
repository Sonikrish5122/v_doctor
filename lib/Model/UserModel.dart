class UserResponseModel {
  final String? message;
  final List<UserDataModel> data;
  final bool success;

  UserResponseModel(
      {required this.message, required this.data, required this.success});

  factory UserResponseModel.fromJson(Map<String, dynamic> json) {
    return UserResponseModel(
      message: json['message'],
      data: (json['data'] as List)
          .map((item) => UserDataModel.fromJson(item))
          .toList(),
      success: json['success'],
    );
  }
}

class UserDataModel {
  final String email;
  final String id;

  UserDataModel({required this.email, required this.id});

  factory UserDataModel.fromJson(Map<String, dynamic> json) {
    return UserDataModel(
      email: json['email'],
      id: json['_id'],
    );
  }
}

class UserRequestModel {
  String email;
  String password;
  String type;
  String? id; // Make id optional

  UserRequestModel({
    required this.email,
    required this.password,
    required this.type,
    this.id, // Make id optional
  });

  Map<String, dynamic> toJson() {
    return {
      'email': email.trim(),
      'type': type,
      'password': password.trim(),
      if (id != null) 'id': id, // Include id if it's not null
    };
  }
}
