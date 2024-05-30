class GetPrescriptionModel {
  final String message;
  final List<PrescriptionData> data;
  final bool success;

  GetPrescriptionModel({
    required this.message,
    required this.data,
    required this.success,
  });

  factory GetPrescriptionModel.fromJson(Map<String, dynamic> json) {
    return GetPrescriptionModel(
      message: json['message'],
      data: List<PrescriptionData>.from(json['data'].map((x) => PrescriptionData.fromJson(x))),
      success: json['success'],
    );
  }
}

class PrescriptionData {
  final int uniqueId;
  final String patientId;
  final String doctorId;
  final String appointmentDate;
  final String time;
  final DateTime startTime;
  final List<PreDiagnosisQuestion> preDiagnosisQuestions;
  final List<dynamic> testReports;
  final String comment;
  final String appointmentMode;
  final String appointmentType;
  final bool isCompleted;
  final bool isCanceled;
  final List<PatientProfile> patientProfile;
  final List<Prescription> prescription;
  final String appointmentId;
  final String paymentStatus;
  final String paymentMode;

  PrescriptionData({
    required this.uniqueId,
    required this.patientId,
    required this.doctorId,
    required this.appointmentDate,
    required this.time,
    required this.startTime,
    required this.preDiagnosisQuestions,
    required this.testReports,
    required this.comment,
    required this.appointmentMode,
    required this.appointmentType,
    required this.isCompleted,
    required this.isCanceled,
    required this.patientProfile,
    required this.prescription,
    required this.appointmentId,
    required this.paymentStatus,
    required this.paymentMode,
  });

  factory PrescriptionData.fromJson(Map<String, dynamic> json) {
    return PrescriptionData(
      uniqueId: json['unique_id'],
      patientId: json['patient_id'],
      doctorId: json['doctor_id'],
      appointmentDate: json['appointmentDate'],
      time: json['time'],
      startTime: DateTime.parse(json['startTime']),
      preDiagnosisQuestions: List<PreDiagnosisQuestion>.from(json['preDiagnosisQuestions'].map((x) => PreDiagnosisQuestion.fromJson(x))),
      testReports: json['testReports'],
      comment: json['comment'],
      appointmentMode: json['appointmentMode'],
      appointmentType: json['appointmentType'],
      isCompleted: json['is_completed'],
      isCanceled: json['is_canceled'],
      patientProfile: List<PatientProfile>.from(json['patientProfile'].map((x) => PatientProfile.fromJson(x))),
      prescription: List<Prescription>.from(json['prescription'].map((x) => Prescription.fromJson(x))),
      appointmentId: json['appointment_id'],
      paymentStatus: json['paymentStatus'],
      paymentMode: json['paymentMode'],
    );
  }
}

class PreDiagnosisQuestion {
  final String question;
  final String answer;

  PreDiagnosisQuestion({
    required this.question,
    required this.answer,
  });

  factory PreDiagnosisQuestion.fromJson(Map<String, dynamic> json) {
    return PreDiagnosisQuestion(
      question: json['question'],
      answer: json['answer'],
    );
  }
}

class PatientProfile {
  final String email;
  final String name;
  final String dob;
  final String gender;
  final String profilePic;
  final String mobileNo;

  PatientProfile({
    required this.email,
    required this.name,
    required this.dob,
    required this.gender,
    required this.profilePic,
    required this.mobileNo,
  });

  factory PatientProfile.fromJson(Map<String, dynamic> json) {
    return PatientProfile(
      email: json['email'],
      name: json['name'],
      dob: json['dob'],
      gender: json['gender'],
      profilePic: json['profile_pic'],
      mobileNo: json['mobile_no'],
    );
  }
}

class Prescription {
  final String prescriptionId;
  final List<Medication> medications;
  final List<dynamic> testReports;

  Prescription({
    required this.prescriptionId,
    required this.medications,
    required this.testReports,
  });

  factory Prescription.fromJson(Map<String, dynamic> json) {
    return Prescription(
      prescriptionId: json['prescription_id'],
      medications: List<Medication>.from(json['medications'].map((x) => Medication.fromJson(x))),
      testReports: json['testReports'],
    );
  }
}

class Medication {
  final String medicineType;
  final String medicineName;
  final String medicineStrength;
  final String importantNote;
  final String intakeDuration;
  final String medicineDose;
  final List<String> medicineIntakeTime;
  final String toBeTaken;
  final List<dynamic> testReports;

  Medication({
    required this.medicineType,
    required this.medicineName,
    required this.medicineStrength,
    required this.importantNote,
    required this.intakeDuration,
    required this.medicineDose,
    required this.medicineIntakeTime,
    required this.toBeTaken,
    required this.testReports,
  });

  factory Medication.fromJson(Map<String, dynamic> json) {
    return Medication(
      medicineType: json['medicineType'],
      medicineName: json['medicineName'],
      medicineStrength: json['medicineStrength'],
      importantNote: json['importantNote'],
      intakeDuration: json['intakeDuration'],
      medicineDose: json['medicineDose'],
      medicineIntakeTime: List<String>.from(json['medicineIntakeTime'].map((x) => x)),
      toBeTaken: json['toBeTaken'],
      testReports: json['testReports'],
    );
  }
}
