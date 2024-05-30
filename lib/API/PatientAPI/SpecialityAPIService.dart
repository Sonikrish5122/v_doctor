import 'package:dio/dio.dart';
import 'package:v_doctor/Model/SpecialityModel.dart';
import 'package:v_doctor/utils/String.dart';

class SpecialityAPIService {
  final Dio _dio = Dio();

  Future<List<SpecialityData>> fetchSpecialities() async {
    try {
      Response response = await _dio.get(
        API +'common/all/speciality',
      );
      print(response);
      if (response.statusCode == 200) {
        return SpecialityModel.fromJson(response.data).data ?? [];
      } else {
        throw Exception('Failed to load data');
      }
    } catch (e) {
      throw Exception('Error: $e');
    }

  }
}
