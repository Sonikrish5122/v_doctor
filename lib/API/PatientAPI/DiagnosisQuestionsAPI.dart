import 'package:dio/dio.dart';
import 'package:v_doctor/Model/DiagnosisQuestionsModel.dart';

import 'package:v_doctor/utils/String.dart';

class DiagnosisQuestionsAPIService {
  Dio dio = Dio();

  Future<DiagnosisQuestionsModel> getDiagnosisQuestions({
    required String accessToken,
    required String userId,
    required String userType,
    required String doctorId,
  }) async {
    try {
      var response = await dio.get(
        API + 'doctor/get-diagnosis-questions/$doctorId',
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
          return DiagnosisQuestionsModel.fromJson(response.data);
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
