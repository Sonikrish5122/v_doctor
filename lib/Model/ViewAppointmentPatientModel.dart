class PatientVIewAppointmentDetailsModel {
  String? message;
  List<Data>? data;
  bool? success;

  PatientVIewAppointmentDetailsModel({this.message, this.data, this.success});

  PatientVIewAppointmentDetailsModel.fromJson(Map<String, dynamic> json) {
    message = json['message'];
    if (json['data'] != null) {
      data = <Data>[];
      json['data'].forEach((v) {
        data!.add(Data.fromJson(v));
      });
    }
    success = json['success'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['message'] = message;
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    data['success'] = success;
    return data;
  }
}

class Data {
  int? uniqueId;
  String? patientId;
  String? doctorId;
  String? appointmentDate;
  String? time;
  String? startTime;
  String? endTime;
  List<PreDiagnosisQuestions>? preDiagnosisQuestions;
  List<String>? testReports;
  String? comment;
  String? appointmentMode;
  String? appointmentType;
  bool? isCompleted;
  bool? isCanceled;
  List<ClinicInfo>? clinicInfo;
  List<Prescription>? prescription;
  List<DoctorDetails>? doctorDetails;
  String? appointmentId;
  PaymentStatus? paymentStatus;

  Data({
    this.uniqueId,
    this.patientId,
    this.doctorId,
    this.appointmentDate,
    this.time,
    this.startTime,
    this.endTime,
    this.preDiagnosisQuestions,
    this.testReports,
    this.comment,
    this.appointmentMode,
    this.appointmentType,
    this.isCompleted,
    this.isCanceled,
    this.clinicInfo,
    this.prescription,
    this.doctorDetails,
    this.appointmentId,
    this.paymentStatus,
  });

  Data.fromJson(Map<String, dynamic> json) {
    uniqueId = json['unique_id'];
    patientId = json['patient_id'];
    doctorId = json['doctor_id'];
    appointmentDate = json['appointmentDate'];
    time = json['time'];
    startTime = json['startTime'];
    endTime = json['endTime'];
    if (json['preDiagnosisQuestions'] != null) {
      preDiagnosisQuestions = <PreDiagnosisQuestions>[];
      json['preDiagnosisQuestions'].forEach((v) {
        preDiagnosisQuestions!.add(PreDiagnosisQuestions.fromJson(v));
      });
    }
    testReports = json['testReports']?.cast<String>();
    comment = json['comment'];
    appointmentMode = json['appointmentMode'];
    appointmentType = json['appointmentType'];
    isCompleted = json['is_completed'];
    isCanceled = json['is_canceled'];
    if (json['clinicInfo'] != null) {
      clinicInfo = <ClinicInfo>[];
      json['clinicInfo'].forEach((v) {
        clinicInfo!.add(ClinicInfo.fromJson(v));
      });
    }
    if (json['prescription'] != null) {
      prescription = <Prescription>[];
      json['prescription'].forEach((v) {
        prescription!.add(Prescription.fromJson(v));
      });
    }
    if (json['doctorDetails'] != null) {
      doctorDetails = <DoctorDetails>[];
      json['doctorDetails'].forEach((v) {
        doctorDetails!.add(DoctorDetails.fromJson(v));
      });
    }
    appointmentId = json['appointment_id'];
    paymentStatus = json['paymentStatus'] != null
        ? PaymentStatus.fromJson(json['paymentStatus'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['unique_id'] = uniqueId;
    data['patient_id'] = patientId;
    data['doctor_id'] = doctorId;
    data['appointmentDate'] = appointmentDate;
    data['time'] = time;
    data['startTime'] = startTime;
    data['endTime'] = endTime;
    if (preDiagnosisQuestions != null) {
      data['preDiagnosisQuestions'] =
          preDiagnosisQuestions!.map((v) => v.toJson()).toList();
    }
    data['testReports'] = testReports;
    data['comment'] = comment;
    data['appointmentMode'] = appointmentMode;
    data['appointmentType'] = appointmentType;
    data['is_completed'] = isCompleted;
    data['is_canceled'] = isCanceled;
    if (clinicInfo != null) {
      data['clinicInfo'] = clinicInfo!.map((v) => v.toJson()).toList();
    }
    if (prescription != null) {
      data['prescription'] = prescription!.map((v) => v.toJson()).toList();
    }
    if (doctorDetails != null) {
      data['doctorDetails'] = doctorDetails!.map((v) => v.toJson()).toList();
    }
    data['appointment_id'] = appointmentId;
    if (paymentStatus != null) {
      data['paymentStatus'] = paymentStatus!.toJson();
    }
    return data;
  }
}

class PreDiagnosisQuestions {
  String? question;
  String? answer;

  PreDiagnosisQuestions({this.question, this.answer});

  PreDiagnosisQuestions.fromJson(Map<String, dynamic> json) {
    question = json['question'];
    answer = json['answer'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['question'] = question;
    data['answer'] = answer;
    return data;
  }
}

class ClinicInfo {
  String? clinicId;
  String? address;
  String? addressUrl;
  String? city;
  String? country;
  String? state;
  String? zipCode;

  ClinicInfo({
    this.clinicId,
    this.address,
    this.addressUrl,
    this.city,
    this.country,
    this.state,
    this.zipCode,
  });

  ClinicInfo.fromJson(Map<String, dynamic> json) {
    clinicId = json['clinic_id'];
    address = json['address'];
    addressUrl = json['address_url'];
    city = json['city'];
    country = json['country'];
    state = json['state'];
    zipCode = json['zipCode'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['clinic_id'] = clinicId;
    data['address'] = address;
    data['address_url'] = addressUrl;
    data['city'] = city;
    data['country'] = country;
    data['state'] = state;
    data['zipCode'] = zipCode;
    return data;
  }
}

class Prescription {
  String? prescriptionId;
  List<Medications>? medications;
  List<String>? testReports;

  Prescription({this.prescriptionId, this.medications, this.testReports});

  Prescription.fromJson(Map<String, dynamic> json) {
    prescriptionId = json['prescription_id'];
    if (json['medications'] != null) {
      medications = <Medications>[];
      json['medications'].forEach((v) {
        medications!.add(Medications.fromJson(v));
      });
    }
    testReports = json['testReports']?.cast<String>();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['prescription_id'] = prescriptionId;
    if (medications != null) {
      data['medications'] = medications!.map((v) => v.toJson()).toList();
    }
    data['testReports'] = testReports;
    return data;
  }
}

class Medications {
  String? medicineType;
  String? medicineName;
  String? medicineStrength;
  String? medicineDose;
  String? intakeDuration;
  String? toBeTaken;
  List<String>? medicineIntakeTime;
  String? importantNote;

  Medications({
    this.medicineType,
    this.medicineName,
    this.medicineStrength,
    this.medicineDose,
    this.intakeDuration,
    this.toBeTaken,
    this.medicineIntakeTime,
    this.importantNote,
  });

  Medications.fromJson(Map<String, dynamic> json) {
    medicineType = json['medicineType'];
    medicineName = json['medicineName'];
    medicineStrength = json['medicineStrength'];
    medicineDose = json['medicineDose'];
    intakeDuration = json['intakeDuration'];
    toBeTaken = json['toBeTaken'];
    medicineIntakeTime = json['medicineIntakeTime']?.cast<String>();
    importantNote = json['importantNote'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['medicineType'] = medicineType;
    data['medicineName'] = medicineName;
    data['medicineStrength'] = medicineStrength;
    data['medicineDose'] = medicineDose;
    data['intakeDuration'] = intakeDuration;
    data['toBeTaken'] = toBeTaken;
    data['medicineIntakeTime'] = medicineIntakeTime;
    data['importantNote'] = importantNote;
    return data;
  }
}

class DoctorDetails {
  String? doctorId;
  String? profilePic;
  String? name;
  String? gender;
  int? experience;

  DoctorDetails({
    this.doctorId,
    this.profilePic,
    this.name,
    this.gender,
    this.experience,
  });

  DoctorDetails.fromJson(Map<String, dynamic> json) {
    doctorId = json['doctor_id'];
    profilePic = json['profile_pic'];
    name = json['name'];
    gender = json['gender'];
    experience = json['experience'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['doctor_id'] = doctorId;
    data['profile_pic'] = profilePic;
    data['name'] = name;
    data['gender'] = gender;
    data['experience'] = experience;
    return data;
  }
}

class PaymentStatus {
  int? amount;
  dynamic partner;
  String? status;
  String? paymentMode;

  PaymentStatus({this.amount, this.partner, this.status, this.paymentMode});

  PaymentStatus.fromJson(Map<String, dynamic> json) {
    amount = json['amount'];
    partner = json['partner'];
    status = json['status'];
    paymentMode = json['paymentMode'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['amount'] = amount;
    data['partner'] = partner;
    data['status'] = status;
    data['paymentMode'] = paymentMode;
    return data;
  }
}
