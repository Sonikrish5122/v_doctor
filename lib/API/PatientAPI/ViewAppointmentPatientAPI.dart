import 'package:dio/dio.dart';
import 'package:v_doctor/Model/ViewAppointmentPatientModel.dart';
import 'package:v_doctor/utils/String.dart';

class ViewAppointmentPatientDetailsAPIService {
  Dio dio = Dio();

  Future<PatientVIewAppointmentDetailsModel> getViewAppointmentDetails({
    required String accessToken,
    required String userId,
    required String userType,
    required String appointmentId,
  }) async {
    try {
      var response = await dio.get(
        API + 'appointment/for-patients/$userId/$appointmentId',
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
          return PatientVIewAppointmentDetailsModel.fromJson(response.data);
        } else {
          throw Exception(
              'Failed to load prescription details: Response data is null');
        }
      } else {
        throw Exception(
            'Failed to load prescription details: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Failed to load prescription details: $e');
    }
  }
}
