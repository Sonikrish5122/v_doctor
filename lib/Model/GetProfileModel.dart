class GetProfileModel {
  final String message;
  final bool success;
  final List<PatientData> data;

  GetProfileModel({
    required this.message,
    required this.success,
    required this.data,
  });

  factory GetProfileModel.fromJson(Map<String, dynamic> json) {
    return GetProfileModel(
      message: json['message'] ?? '',
      success: json['success'] ?? false,
      data: (json['data'] as List<dynamic>?)
          ?.map((data) => PatientData.fromJson(data))
          .toList() ?? [],
    );
  }
}

class PatientData {
  final String email;
  final String patientId;
  final String dob;
  final String gender;
  final String mobileNo;
  final String name;
  final String profilePic;

  PatientData({
    required this.email,
    required this.patientId,
    required this.dob,
    required this.gender,
    required this.mobileNo,
    required this.name,
    required this.profilePic,
  });

  factory PatientData.fromJson(Map<String, dynamic> json) {
    return PatientData(
      email: json['email'] ?? '',
      patientId: json['patient_id'] ?? '',
      dob: json['dob'] ?? '',
      gender: json['gender'] ?? '',
      mobileNo: json['mobile_no'] ?? '',
      name: json['name'] ?? '',
      profilePic: json['profile_pic'] ?? '',
    );
  }
}
