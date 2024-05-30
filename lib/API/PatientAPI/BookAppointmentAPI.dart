import 'package:dio/dio.dart';
import 'package:intl/intl.dart';
import 'package:v_doctor/Model/BookAppointmentModel.dart';
import 'package:v_doctor/utils/String.dart';

class BookAppointmentAPIService {
  Dio dio = Dio();

  Future<BookAppointmentModel> getBookAppointment({
    required String accessToken,
    required String userId,
    required String userType,
    required String doctorId,
    required String appointmentMode,
    required String startTime,
    required String endTime,
    required String date,
    required List<Map<String, String>> preDiagnosisQuestions,
    required List<String> testReports,
    required String appointmentType,
    required String comment,
    required String paymentMode,
    required String time,
  }) async {
    try {
      print('getBookAppointment: Start');

      // Check if any required parameter is null or empty
      final List<String> requiredParameters = [
        accessToken,
        userId,
        userType,
        doctorId,
        appointmentMode,
        startTime,
        endTime,
        date,
        appointmentType,
        comment,
        paymentMode,
        time,
      ];
      if (requiredParameters.any((element) => element.isEmpty)) {
        throw Exception('One or more required parameters are null or empty');
      }

      final response = await dio.post(
        API + 'appointment/book-appointment/$userId/$doctorId',
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
          "time": time,
          "appointmentMode": appointmentMode,
          "startTime": startTime,
          "endTime": endTime,
          "date": DateFormat("dd-MM-yyyy").format(DateTime.parse(date)),
          "preDiagnosisQuestions": preDiagnosisQuestions,
          "testReports": testReports,
          "appointmentType": appointmentType,
          "comment": comment,
          "paymentMode": paymentMode,
        },
      );

      print('getBookAppointment: Response received');

      // Check if response data is null
      if (response.data != null) {
        // Print the response for debugging
        print(response);

       return BookAppointmentModel.fromJson(response.data);
      } else {
        // Handle null response data
        throw Exception('Response data is null');
      }
    } catch (e) {

      print('getBookAppointment: Error - $e');
      throw Exception('Failed to book appointment: $e');
    }
  }

}
