import 'package:dio/dio.dart';
import 'package:v_doctor/Model/DoctorModel/GetClinicInfoModel.dart';
import 'package:v_doctor/utils/String.dart';

class GetClinicInfoAPIService {
  Dio dio = Dio();

  Future<GetClinicInfoModel> getClinicInfo({
    required String accessToken,
    required String userId,
    required String userType,
  }) async {
    try {
      var response = await dio.get(
        API + 'doctor/all-clinics/$userId',
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
          return GetClinicInfoModel.fromJson(response.data);
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



