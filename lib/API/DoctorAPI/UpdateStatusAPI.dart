import 'package:dio/dio.dart';
import 'package:v_doctor/Model/DoctorModel/UpdateStatusModel.dart'; // Importing UpdateStatusModel
import 'package:v_doctor/utils/String.dart';

class UpdateStatusAPIService {
  Dio dio = Dio();

  Future<UpdateStatusModel> updateStatus({
    required String accessToken,
    required String userId,
    required String userType,
    required String appointmentId,
    required String completionStatus,
    required String doctorId,
    required String patientId,
  }) async {
    try {
      final response = await dio.post(
        API + 'appointment/update-status-to-complete',
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
          'appointmentId': appointmentId,
          'completionStatus': completionStatus,
          'doctorId': userId,
          'patientId': patientId,
          'updatedBy': userId,
        },
      );

      print(response);
      return UpdateStatusModel.fromJson(response.data);
    } catch (e) {
      // Error handling: If request fails, throw an exception
      throw Exception('Failed to update status: $e');
    }
  }
}
