import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:v_doctor/Model/LoginModel.dart';
import 'package:v_doctor/utils/String.dart';

class LoginAPIService {
  final Dio _dio = Dio();

  Future<LoginResponseModel> loginUser(LoginRequestModel loginRequest) async {
    try {
      Response response = await _dio.post(
          API + 'user/login',
          data: loginRequest.toJson());
      return LoginResponseModel.fromJson(response.data);
    } on DioError catch (e) {
      throw Exception('Failed to login: Dio error - ${e.message}');
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
