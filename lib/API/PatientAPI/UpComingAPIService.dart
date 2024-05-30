import 'package:dio/dio.dart';
import 'package:v_doctor/Model/BookingModel/UpComingModel.dart';
import 'package:v_doctor/utils/String.dart';

class UpComingAppointmentAPIService {
  Dio dio = Dio();

  Future<UpcomingAppointment> getUpcomingAppointment({
    required String accessToken,
    required String userId,
    required String userType,
  }) async {
    try {
      var response = await dio.get(
        API + 'appointment/all-for-patients/$userId?type=upcoming',
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
      // print(response);
      if (response.statusCode == 200) {
        if (response.data != null) {
          return UpcomingAppointment.fromJson(response.data);
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
