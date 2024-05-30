import 'package:dio/dio.dart';
import 'package:v_doctor/Model/DoctorDetailsModel/DoctorDetailsModel.dart';
import 'package:v_doctor/utils/String.dart';

class DoctorDetailsAPIService {
  Dio dio = Dio();

  Future<DoctorProfileModel> getDoctorDetailsBySpeciality({
    required String accessToken,
    required String userId,
    required String userType,
    required String specialityId,
  }) async {
    try {
      final response = await dio.post(
        API + 'doctor/by-speciality',
        options: Options(
          headers: {
            'Content-Type': 'application/json',
            'Accept': 'application/json',
            'Authorization': 'Bearer $accessToken',
            'user-id': userId,
            'user-type': userType,
          },
        ),
        data: {
          "specialities": [specialityId],
        },
      );

      if (response.statusCode == 200) {
        // Print the response data for debugging
        print('Response Data: ${response.data}');

        return DoctorProfileModel.fromJson(response.data);
      } else {
        // Handle non-200 status codes
        throw Exception('Failed to load doctor details: ${response.statusCode}');
      }
    } catch (e) {
      // Handle errors
      print('Error: $e');
      throw Exception('Failed to load doctor details by speciality: $e');
    }
  }
}
