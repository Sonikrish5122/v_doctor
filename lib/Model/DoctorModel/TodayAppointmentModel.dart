class TodayAppointmentModel {
  final String message;
  final bool success;
  final List<AppointmentData> data;

  TodayAppointmentModel({
    required this.message,
    required this.success,
    required this.data,
  });

  factory TodayAppointmentModel.fromJson(Map<String, dynamic> json) {
    var appointmentList = json['data'] as List;
    List<AppointmentData> appointments = appointmentList.map((e) => AppointmentData.fromJson(e)).toList();

    return TodayAppointmentModel(
      message: json['message'],
      success: json['success'],
      data: appointments,
    );
  }
}

class AppointmentData {
  final int uniqueId;
  final String patientId;
  final String doctorId;
  final String appointmentDate;
  final String time;
  final DateTime startTime;
  final DateTime endTime;
  final String appointmentMode;
  final String appointmentType;
  final bool isCompleted;
  final bool isConfirmed;
  final bool isCanceled;
  final PatientProfile patientProfile;
  final String appointmentId;
  final String paymentStatus;
  final String paymentMode;

  AppointmentData({
    required this.uniqueId,
    required this.patientId,
    required this.doctorId,
    required this.appointmentDate,
    required this.time,
    required this.startTime,
    required this.endTime,
    required this.appointmentMode,
    required this.appointmentType,
    required this.isCompleted,
    required this.isConfirmed,
    required this.isCanceled,
    required this.patientProfile,
    required this.appointmentId,
    required this.paymentStatus,
    required this.paymentMode,
  });

  factory AppointmentData.fromJson(Map<String, dynamic> json) {
    return AppointmentData(
      uniqueId: json['unique_id'],
      patientId: json['patient_id'],
      doctorId: json['doctor_id'],
      appointmentDate: json['appointmentDate'],
      time: json['time'],
      startTime: DateTime.parse(json['startTime']),
      endTime: DateTime.parse(json['endTime']),
      appointmentMode: json['appointmentMode'],
      appointmentType: json['appointmentType'],
      isCompleted: json['is_completed'],
      isConfirmed: json['is_confirmed'],
      isCanceled: json['is_canceled'],
      patientProfile: PatientProfile.fromJson(json['patientProfile']),
      appointmentId: json['appointment_id'],
      paymentStatus: json['paymentStatus'],
      paymentMode: json['paymentMode'],
    );
  }
}

class PatientProfile {
  final String name;
  final String dob;
  final String gender;
  final String email;

  PatientProfile({
    required this.name,
    required this.dob,
    required this.gender,
    required this.email,
  });

  factory PatientProfile.fromJson(Map<String, dynamic> json) {
    return PatientProfile(
      name: json['name'],
      dob: json['dob'],
      gender: json['gender'],
      email: json['email'],
    );
  }
}
