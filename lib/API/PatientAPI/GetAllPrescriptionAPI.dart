import 'package:dio/dio.dart';
import 'package:v_doctor/Model/GetAllPrescriptionModel.dart';
import 'package:v_doctor/utils/String.dart';

class GetPrescriptionListAPIService {
  Dio dio = Dio();

  Future<GetAllPrescriptionModel> getPrescriptionList({
    required String accessToken,
    required String userId,
    required String userType,
  }) async {
    try {
      var response = await dio.get(
        API + 'appointment/get-all-prescription/$userId',
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
          return GetAllPrescriptionModel.fromJson(response.data);
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
