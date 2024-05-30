import 'package:dio/dio.dart';
import 'package:v_doctor/Model/DoctorInfoModel.dart';
import 'package:v_doctor/utils/String.dart';

class DoctorInfoAPIService {
  Dio dio = Dio();

  Future<DoctorInfoModel> getDoctorDetails({
    required String accessToken,
    required String userId,
    required String userType,
    required String doctorId,
  }) async {
    try {
      var response = await dio.get(
        API + 'doctor/details-by-doctor-id/$doctorId',
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
      print(response);
      if (response.statusCode == 200) {
        if (response.data != null) {
          return DoctorInfoModel.fromJson(response.data['data'][0]);
        } else {
          throw Exception(
              'Failed to load doctor details: Response data is null');
        }
      } else {
        throw Exception(
            'Failed to load doctor details: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Failed to load doctor details: $e');
    }
  }
}
