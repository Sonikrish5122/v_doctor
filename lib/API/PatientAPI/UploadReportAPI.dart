import 'dart:io';
import 'package:dio/dio.dart';
import 'package:http_parser/http_parser.dart';

class UploadReportAPIService {

  Future<void> uploadReport({
    required File file,
    required String reportName,
    required String reportDate,
    required String patientName,
    required String accessToken,
    required String userId,
    required String userType,
  }) async {
    try {
      Dio dio = Dio();

      String url =
          'https://vdoctor-backend.itechnotion.dev/patient/upload-lab-reports/$userId';

      String fileExtension = file.path.split('.').last.toLowerCase(); // Extract and convert to lowercase

      // Define headers
      Map<String, dynamic> headers = {
        'Authorization': 'Bearer $accessToken',
        'user-id': userId,
        'user-type': userType,
      };

      // Determine content type based on file extension
      String contentType;
      if (fileExtension == 'pdf') {
        contentType = 'application/pdf';
      } else if (fileExtension == 'jpg' || fileExtension == 'jpeg' || fileExtension == 'png') {
        contentType = 'image/$fileExtension';
      } else {
        throw Exception('Unsupported file format');
      }

      FormData formData = FormData.fromMap({
        'file': await MultipartFile.fromFile(
          file.path,
          filename: file.path.split('/').last,
          contentType: MediaType.parse(contentType),
        ),
        'reportName': reportName,
        'reportDate': reportDate,
        'patientName': patientName,
        'fileFormat': fileExtension, // Include file format
      });

      // Send POST request with headers
      await dio.post(
        url,
        data: formData,
        options: Options(headers: headers),
      );
    } catch (e) {
      throw Exception('Error uploading report: $e');
    }
  }
}
