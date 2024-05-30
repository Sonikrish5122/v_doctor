import 'package:flutter/material.dart';

class AppointmentDetailsDoctorModel {
  final String message;
  final List<AppointmentData> data;
  final bool success;

  AppointmentDetailsDoctorModel({
    required this.message,
    required this.data,
    required this.success,
  });

  factory AppointmentDetailsDoctorModel.fromJson(Map<String, dynamic> json) {
    return AppointmentDetailsDoctorModel(
      message: json['message'],
      data: (json['data'] as List)
          .map((appointmentData) =>
          AppointmentData.fromJson(appointmentData))
          .toList(),
      success: json['success'],
    );
  }
}

class AppointmentData {
  final int uniqueId;
  final String patientId;
  final String doctorId;
  final String appointmentDate;
  final String time;
  final List<PreDiagnosisQuestion> preDiagnosisQuestions;
  final List<dynamic> testReports;
  final String comment;
  final String appointmentMode;
  final String appointmentType;
  final bool isCompleted;
  final bool isCanceled;
  final List<PatientProfile> patientProfile;
  final List<dynamic> prescription;
  final String appointmentId;
  final String paymentStatus;
  final String paymentMode;

  AppointmentData({
    required this.uniqueId,
    required this.patientId,
    required this.doctorId,
    required this.appointmentDate,
    required this.time,
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

  factory AppointmentData.fromJson(Map<String, dynamic> json) {
    return AppointmentData(
      uniqueId: json['unique_id'],
      patientId: json['patient_id'],
      doctorId: json['doctor_id'],
      appointmentDate: json['appointmentDate'],
      time: json['time'],
      preDiagnosisQuestions: (json['preDiagnosisQuestions'] as List)
          .map((question) => PreDiagnosisQuestion.fromJson(question))
          .toList(),
      testReports: json['testReports'],
      comment: json['comment'],
      appointmentMode: json['appointmentMode'],
      appointmentType: json['appointmentType'],
      isCompleted: json['is_completed'],
      isCanceled: json['is_canceled'],
      patientProfile: (json['patientProfile'] as List)
          .map((profile) => PatientProfile.fromJson(profile))
          .toList(),
      prescription: json['prescription'],
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
  final String mobileNo;

  PatientProfile({
    required this.email,
    required this.name,
    required this.dob,
    required this.gender,
    required this.mobileNo,
  });

  factory PatientProfile.fromJson(Map<String, dynamic> json) {
    return PatientProfile(
      email: json['email'],
      name: json['name'],
      dob: json['dob'],
      gender: json['gender'],
      mobileNo: json['mobile_no'],
    );
  }
}
