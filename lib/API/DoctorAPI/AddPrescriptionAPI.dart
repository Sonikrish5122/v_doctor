import 'package:dio/dio.dart';
import 'package:v_doctor/Model/DoctorModel/AddPrescriptionModel.dart';
import 'package:v_doctor/utils/String.dart';

class AddPrescriptionAPIService {
  Dio dio = Dio();

  Future<AddPrescriptionModel> addPrescription({
    required String accessToken,
    required String userId,
    required String userType,
    required String patientID,
    required String appointmentId,
    required Map<String, dynamic> prescriptionData,
  }) async {
    try {
      final response = await dio.post(
        API +
            'appointment/add-prescription/$patientID/$userId/$appointmentId',
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
          "prescription_id": prescriptionData['prescription_id'],
          "unique_id": prescriptionData['unique_id'],
          "medications": prescriptionData['medications'],
        },
      );

      print(response);

      return AddPrescriptionModel.fromJson(response.data);
    } catch (e) {
      throw Exception('Failed to add prescription: $e');
    }
  }
}
