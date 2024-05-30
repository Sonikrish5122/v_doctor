class PastAppointment {
  final String message;
  final List<PastAppointmentData> appointmentData;
  final bool success;

  PastAppointment({
    required this.message,
    required this.appointmentData,
    required this.success,
  });

  factory PastAppointment.fromJson(Map<String, dynamic> json) {
    return PastAppointment(
      message: json['message'],
      appointmentData: List<PastAppointmentData>.from(
          json['data'].map((x) => PastAppointmentData.fromJson(x))),
      success: json['success'],
    );
  }
}

class PastAppointmentData {
  final List<AppointmentDetails> appointments;

  PastAppointmentData({
    required this.appointments,
  });

  factory PastAppointmentData.fromJson(Map<String, dynamic> json) {
    final appointmentsList = json.entries
        .map((entry) {
          final List<dynamic> appointmentsData = entry.value;
          return appointmentsData
              .map((e) => AppointmentDetails.fromJson(e))
              .toList();
        })
        .expand((e) => e)
        .toList();
    return PastAppointmentData(appointments: appointmentsList);
  }
}

class AppointmentDetails {
  final String appointmentId;
  final String patientId;
  final String doctorId;
  final String appointmentDate;
  final String startTime;
  final String endTime;
  final String time;
  final int uniqueId;
  final bool isCompleted;
  final bool isCanceled;
  final String appointmentMode;
  final String appointmentType;
  final String paymentStatus;
  final String paymentMode;
  final bool isConfirmed;
  final DoctorDetails doctorDetails;

  AppointmentDetails({
    required this.appointmentId,
    required this.patientId,
    required this.doctorId,
    required this.appointmentDate,
    required this.startTime,
    required this.endTime,
    required this.time,
    required this.uniqueId,
    required this.isCompleted,
    required this.isCanceled,
    required this.appointmentMode,
    required this.appointmentType,
    required this.paymentStatus,
    required this.paymentMode,
    required this.isConfirmed,
    required this.doctorDetails,
  });

  factory AppointmentDetails.fromJson(Map<String, dynamic> json) {
    return AppointmentDetails(
      appointmentId: json['appointment_id'],
      patientId: json['patient_id'],
      doctorId: json['doctor_id'],
      appointmentDate: json['appointmentDate'],
      startTime: json['startTime'],
      endTime: json['endTime'],
      time: json['time'],
      uniqueId: json['unique_id'],
      isCompleted: json['is_completed'],
      isCanceled: json['is_canceled'],
      appointmentMode: json['appointmentMode'],
      appointmentType: json['appointmentType'],
      paymentStatus: json['paymentStatus'],
      paymentMode: json['paymentMode'],
      isConfirmed: json['is_confirmed'],
      doctorDetails: DoctorDetails.fromJson(json['doctorDetails']),
    );
  }
}

class DoctorDetails {
  final String name;
  final String mobileNo;
  final String email;
  final String profilePic;
  final int experience;

  DoctorDetails({
    required this.name,
    required this.mobileNo,
    required this.email,
    required this.profilePic,
    required this.experience,
  });

  factory DoctorDetails.fromJson(Map<String, dynamic> json) {
    return DoctorDetails(
      name: json['name'],
      mobileNo: json['mobile_no'],
      email: json['email'],
      profilePic: json['profile_pic'],
      experience: json['experience'],
    );
  }
}
