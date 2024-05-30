import 'package:dio/dio.dart';
import 'package:v_doctor/Model/TimeSlotsModel.dart';
import 'package:v_doctor/utils/String.dart';

class TimeSlotsAPIService {
  Dio dio = Dio();

  Future<TimeSlotsModel> getTimeSlots({
    required String accessToken,
    required String userId,
    required String userType,
    required String doctorId,
    required String date,
  }) async {
    try {
      final response = await dio.post(
        API + 'patient/available-slots/$doctorId',
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
          'date': date,
        },
      );

      print(response);
      print(date);
      return TimeSlotsModel.fromJson(response.data);
    } catch (e) {
      throw Exception('Failed to load doctor details by speciality: $e');
    }
  }
}
