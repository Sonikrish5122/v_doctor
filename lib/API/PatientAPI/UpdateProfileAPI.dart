import 'package:dio/dio.dart';
import 'package:v_doctor/utils/String.dart';

class UpdateProfileAPI {
  final Dio _dio = Dio();

  Future<Map<String, dynamic>> updatePatientProfile({
    required String accessToken,
    required String userId,
    required String userType,
    required String name,
    required String mobileNo,
    required String dob,
    required String gender,
  }) async {
    try {
      var response = await _dio.post(
        API + 'patient/updatePatient/$userId',
        data: {
          'name': name,
          'mobile_no': mobileNo,
          'dob': dob,
          'gender': gender,
        },
        options: Options(
          headers: {
            'Content-Type': 'application/json',
            'Accept': 'application/json',
            'Authorization': 'Bearer $accessToken',
            'user-id': userId,
            'user-type': userType,
          },
        ),
      );

      if (response.statusCode == 200) {
        // Successfully updated profile
        return {
          'success': true,
          'message': 'Profile updated successfully',
          'data': response.data,
        };
      } else {
        // Failed to update profile
        return {
          'success': false,
          'message': 'Failed to update profile. Status code: ${response.statusCode}',
        };
      }
    } catch (e) {
      // Error occurred during the update process
      return {
        'success': false,
        'message': 'Failed to update profile: $e',
      };
    }
  }
}
