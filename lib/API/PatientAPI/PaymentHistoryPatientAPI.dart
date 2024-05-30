import 'package:dio/dio.dart';
import 'package:v_doctor/Model/DoctorModel/PaymentHistoryModel.dart';
import 'package:v_doctor/Model/PaymentHistoryPatientModel.dart';
import 'package:v_doctor/utils/String.dart';

class PaymentHistoryPatientAPIService {
  Dio dio = Dio();

  Future<PaymentHistoryPatientModel> PaymentHistoryPatientInfo({
    required String accessToken,
    required String userId,
    required String userType,
  }) async {
    try {
      var response = await dio.get(
        API + 'patient/payment-history/$userId',
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
          return PaymentHistoryPatientModel.fromJson(response.data);
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



