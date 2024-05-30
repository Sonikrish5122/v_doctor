import 'package:dio/dio.dart';
import 'package:v_doctor/Model/DoctorModel/AppointmentDetailsDoctorModel.dart';
import 'package:v_doctor/Model/DoctorModel/DoctorDetailsModel.dart';
import 'package:v_doctor/Model/DoctorModel/GetClinicInfoModel.dart';
import 'package:v_doctor/utils/String.dart';

class AppointmentDetailsDoctorAPI {
  Dio dio = Dio();

  Future<AppointmentDetailsDoctorModel> getAppointmentDetails({
    required String accessToken,
    required String userId,
    required String appointment_id,
  }) async {
    try {
      var response = await dio.get(
        API + 'appointment/for-doctors/$userId/$appointment_id',
        options: Options(
          headers: {
            'Content-Type': 'application/json',
            'Accept': 'application/json',
            'Authorization': 'Bearer $accessToken',
            'user-id': userId,
            'user-type': appointment_id,
          },
        ),
      );
      print(response);
      if (response.statusCode == 200) {
        if (response.data != null) {
          return AppointmentDetailsDoctorModel.fromJson(response.data);
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



