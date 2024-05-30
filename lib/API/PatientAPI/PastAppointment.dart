import 'package:dio/dio.dart';
import 'package:v_doctor/Model/BookingModel/PastAppoinmentModel.dart'; // Import the PastAppointment model
import 'package:v_doctor/utils/String.dart'; // Assuming API and other constants are defined here

class PastAPIService {
  Dio dio = Dio();

  Future<PastAppointment> getPastAppointment({
    required String accessToken,
    required String userId,
    required String userType,
  }) async {
    try {
      var response = await dio.get(
        API + 'appointment/all-for-patients/$userId?type=past',
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
          // Parse JSON response into PastAppointment model object
          return PastAppointment.fromJson(response.data);
        } else {
          throw Exception(
              'Failed to load past appointment details: Response data is null');
        }
      } else {
        throw Exception(
            'Failed to load past appointment details: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Failed to load past appointment details: $e');
    }
  }
}
