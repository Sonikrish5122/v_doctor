import 'package:dio/dio.dart';
import 'package:v_doctor/Model/DoctorModel/FeesStructureModel.dart';
import 'package:v_doctor/utils/String.dart';

class FeesAPIService {
  Dio dio = Dio();

  Future<FeesStructureModel> getFees({
    required String accessToken,
    required String userId,
    required String userType,
  }) async {
    try {
      var response = await dio.get(
        API + 'doctor/get-fees-by-doctor/$userId',
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
          return FeesStructureModel.fromJson(response.data);
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
