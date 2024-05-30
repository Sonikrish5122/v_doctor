import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:v_doctor/Model/UserModel.dart';
import 'package:v_doctor/utils/String.dart';

class UserAPIService {
  final Dio _dio = Dio();

  Future<UserResponseModel> createUser(UserRequestModel userRequestModel) async {
    try {
      String createUserUrl = API + 'user/create';

      final response = await _dio.post(
        createUserUrl,
        data: userRequestModel.toJson(),
      );

      if (response.statusCode == 200 || response.statusCode == 400) {
        final Map<String, dynamic> responseData = response.data;

        if (responseData['success'] == true) {
          SharedPreferences prefs = await SharedPreferences.getInstance();
          prefs.setString('email', userRequestModel.email);
          prefs.setString('type', userRequestModel.type);

          return UserResponseModel.fromJson(responseData);
        } else {
          throw Exception(responseData['message']);
        }
      } else {
        throw Exception('Failed to login');
      }
    } catch (error) {
      throw Exception('Failed to login: $error');
    }
  }

  Future<String?> getEmailFromSharedPreferences() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('email');
  }

  Future<String?> getTypeFromSharedPreferences() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('type');
  }
}