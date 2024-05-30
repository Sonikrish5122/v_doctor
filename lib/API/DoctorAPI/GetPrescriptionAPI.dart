import 'package:dio/dio.dart';
import 'package:v_doctor/Model/DoctorModel/AppointmentDetailsDoctorModel.dart';
import 'package:v_doctor/Model/DoctorModel/DoctorDetailsModel.dart';
import 'package:v_doctor/Model/DoctorModel/GetClinicInfoModel.dart';
import 'package:v_doctor/Model/DoctorModel/GetPrescriptionModel.dart';
import 'package:v_doctor/utils/String.dart';

class GetPrescriptionAPI {
  Dio dio = Dio();

  Future<GetPrescriptionModel> getPrescriptionDetails({
    required String accessToken,
    required String userId,
    required String prescription_id,
  }) async {
    try {
      var response = await dio.get(
        API + 'appointment/get-prescription-by-appointment/$prescription_id',
        options: Options(
          headers: {
            'Content-Type': 'application/json',
            'Accept': 'application/json',
            'Authorization': 'Bearer $accessToken',
            'user-id': userId,

          },
        ),
      );
      print(response);
      if (response.statusCode == 200) {
        if (response.data != null) {
          return GetPrescriptionModel.fromJson(response.data);
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



