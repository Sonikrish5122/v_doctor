  import 'package:dio/dio.dart';
  import 'package:v_doctor/Model/DoctorModel/GetAllDegreeModel.dart';
  import 'package:v_doctor/utils/String.dart';

  class GetAllDegreeAPIService {
    final Dio _dio = Dio();

    Future<List<DegreeData>> fetchDegree() async {
      try {
        Response response = await _dio.get(
          API +'common/all/degrees',
        );
        print(response);
        if (response.statusCode == 200) {
          return GetAllDegreeModel.fromJson(response.data).data ?? [];
        } else {
          throw Exception('Failed to load data');
        }
      } catch (e) {
        throw Exception('Error: $e');
      }
    }
  }
