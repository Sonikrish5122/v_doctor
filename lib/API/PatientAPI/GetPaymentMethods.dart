import 'package:dio/dio.dart';
import 'package:v_doctor/Model/PaymentModel.dart';

class GetPaymentAPIService {
  Dio dio = Dio();

  Future<PaymentModel> getPayment({
    required String accessToken,
    required String userId,
    required String userType,
    required String doctorId,
  }) async {
    try {
      var response = await dio.get(
        'https://vdoctor-backend.itechnotion.dev/appointment/get-payment-methods/$doctorId',
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
          return PaymentModel.fromJson(response.data);
        } else {
          throw Exception(
              'Failed to load payment details: Response data is null');
        }
      } else {
        throw Exception(
            'Failed to load payment details: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Failed to load payment details: $e');
    }
  }

}
