import 'package:dio/dio.dart';
import 'package:v_doctor/Model/DoctorModel/GetClinicInfoModel.dart';
import 'package:v_doctor/Model/DoctorModel/TodayAppointmentModel.dart';
import 'package:v_doctor/Model/TodayAppontmentPatient.dart';
import 'package:v_doctor/utils/String.dart';

class GetTodayAppointmentPatientAPIService {
  Dio dio = Dio();

  Future<TodayAppointmentPatientModel> getTodayAppointmentPatientInfo({
    required String accessToken,
    required String userId,
    required String userType,
  }) async {
    try {
      var response = await dio.get(
        API + 'patient/appointments-by-date/$userId?limit=5',
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
          return TodayAppointmentPatientModel.fromJson(response.data);
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



