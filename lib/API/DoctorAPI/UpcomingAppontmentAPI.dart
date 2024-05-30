import 'package:dio/dio.dart';
import 'package:intl/intl.dart';

class UpComingAppointmentAPIService {
  Dio dio = Dio();

  Future<dynamic> getViewUpcomingAppointment({
    required String accessToken,
    required String userId,
    required String userType,
    required String date,
    required String time,
  }) async {
    try {
      // Format the date string
      String formattedDate =
          DateFormat("yyyy-MM-dd").format(DateTime.parse(date));
      String formattedDateTime = '$formattedDate' + 'T$time';

      var response = await dio.get(
        'https://vdoctor-backend.itechnotion.dev/appointment/all-for-doctor/$userId?type=upcoming&date=$formattedDateTime',
        options: Options(
          headers: {
            'Content-Type': 'application/json',
            'Accept': 'application/json',
            'Authorization': 'Bearer $accessToken',
            'user-id': userId,
            'user-type': userType,
            'date': date,
            'time': time,
          },
        ),
      );
      print(response);
      if (response.statusCode == 200) {
        if (response.data != null) {
          return response.data;
          //return UpcomingAppointment.fromJson(response.data);
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
