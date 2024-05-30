import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:v_doctor/utils/String.dart';

class UpdateDoctorProfileService {
  final Dio dio = Dio();

  Future<void> updateDoctorProfile({
    required String accessToken,
    required String userId,
    required String userType,
    required String name,
    required String mobileNo,
    required String dob,
    required String gender,
    required int experience,
    required String about,
    required List<String> specialityIds,
    required List<String> degreeIds,
  }) async {
    try {
      final Map<String, dynamic> requestData = {
        "gender": gender,
        "experience": experience,
        "mobile_no": mobileNo,
        "about": about,
        "name": name,
        "speciality": specialityIds,
        "degree": degreeIds,
        "dob": dob,
      };

      final String apiUrl =  API + 'doctor/updateProfile/$userId?step=0&first_login=true';

      final Response response = await dio.patch(
        apiUrl,
        data: jsonEncode(requestData),
        options: Options(
          headers: {
            'Authorization': 'Bearer $accessToken',
            'user-id': userId,
            'user-type': userType,
          },
        ),
      );

      if (response.statusCode == 200) {

        print('Profile updated successfully');
      } else {

        print('Failed to update profile');
      }
    } catch (e) {
      // Handle Dio errors or other exceptions
      print('Error updating profile: $e');
    }
  }
}