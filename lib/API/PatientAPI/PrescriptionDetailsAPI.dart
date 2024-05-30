import 'package:dio/dio.dart';
import 'package:v_doctor/Model/PrescriptionDetailsModel.dart';
import 'package:v_doctor/utils/String.dart';

class PrescriptionDetailsAPIService {
  Dio dio = Dio();

  Future<PrescriptionDetailsModel> getPrescriptionDetails({
    required String accessToken,
    required String userId,
    required String userType,
    required String prescriptionId,
  }) async {
    try {
      var response = await dio.get(
        API + 'appointment/get-prescription/$userId/$prescriptionId',
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
          return PrescriptionDetailsModel.fromJson(response.data);
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
