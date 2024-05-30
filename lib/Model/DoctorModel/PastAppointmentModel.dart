class PastAppointmentModel {
  final String message;
  final List<AppointmentData> data;
  final bool success;

  PastAppointmentModel({
    required this.message,
    required this.data,
    required this.success,
  });

  factory PastAppointmentModel.fromJson(Map<String, dynamic> json) {
    return PastAppointmentModel(
      message: json['message'],
      data: List<AppointmentData>.from(
          json['data'].map((x) => AppointmentData.fromJson(x))),
      success: json['success'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'message': message,
      'data': data.map((x) => x.toJson()).toList(),
      'success': success,
    };
  }
}

class AppointmentData {
  final List<AppointmentDetails> appointments;

  AppointmentData({
    required this.appointments,
  });

  factory AppointmentData.fromJson(Map<String, dynamic> json) {
    final appointmentsList = json.entries.map((entry) {
      final List<dynamic> appointmentsData = entry.value;
      return appointmentsData
          .map((e) => AppointmentDetails.fromJson(e))
          .toList();
    }).expand((e) => e).toList();
    return AppointmentData(appointments: appointmentsList);
  }

  Map<String, dynamic> toJson() {
    return {
      'appointments': appointments.map((x) => x.toJson()).toList(),
    };
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

  final PatientProfile patientProfile;

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

    required this.patientProfile,
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

      patientProfile: PatientProfile.fromJson(json['patientProfile']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'appointment_id': appointmentId,
      'patient_id': patientId,
      'doctor_id': doctorId,
      'appointmentDate': appointmentDate,
      'startTime': startTime,
      'endTime': endTime,
      'time': time,
      'unique_id': uniqueId,
      'is_completed': isCompleted,
      'is_canceled': isCanceled,
      'appointmentMode': appointmentMode,
      'appointmentType': appointmentType,
      'paymentStatus': paymentStatus,
      'paymentMode': paymentMode,
      'is_confirmed': isConfirmed,
      'patientProfile': patientProfile.toJson(),
    };
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

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'dob': dob,
      'gender': gender,
      'email': email,
    };
  }
}
