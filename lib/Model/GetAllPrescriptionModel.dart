class GetAllPrescriptionModel {
  String? message;
  List<Data>? data;
  bool? success;

  GetAllPrescriptionModel({this.message, this.data, this.success});

  GetAllPrescriptionModel.fromJson(Map<String, dynamic> json) {
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
  String? patientId;
  String? doctorId;
  String? createdAt;
  List<Medications>? medications;
  List<String>? testReports;
  int? uniqueId;
  String? prescriptionId;
  Appointment? appointment;
  Doctor? doctor;

  Data({
    this.patientId,
    this.doctorId,
    this.createdAt,
    this.medications,
    this.testReports,
    this.uniqueId,
    this.prescriptionId,
    this.appointment,
    this.doctor,
  });

  Data.fromJson(Map<String, dynamic> json) {
    patientId = json['patient_id'];
    doctorId = json['doctor_id'];
    createdAt = json['createdAt'];
    if (json['medications'] != null) {
      medications = <Medications>[];
      json['medications'].forEach((v) {
        medications!.add(Medications.fromJson(v));
      });
    }
    testReports = List<String>.from(json['testReports'] ?? []);
    uniqueId = json['unique_id'];
    prescriptionId = json['prescription_id'];
    appointment = json['appointment'] != null ? Appointment.fromJson(json['appointment']) : null;
    doctor = json['doctor'] != null ? Doctor.fromJson(json['doctor']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['patient_id'] = patientId;
    data['doctor_id'] = doctorId;
    data['createdAt'] = createdAt;
    if (medications != null) {
      data['medications'] = medications!.map((v) => v.toJson()).toList();
    }
    data['testReports'] = testReports;
    data['unique_id'] = uniqueId;
    data['prescription_id'] = prescriptionId;
    if (appointment != null) {
      data['appointment'] = appointment!.toJson();
    }
    if (doctor != null) {
      data['doctor'] = doctor!.toJson();
    }
    return data;
  }
}

class Medications {
  String? medicineType;
  String? medicineName;
  String? medicineStrength;
  String? importantNote;
  String? intakeDuration;
  String? medicineDose;
  List<String>? medicineIntakeTime;
  String? toBeTaken;

  Medications({
    this.medicineType,
    this.medicineName,
    this.medicineStrength,
    this.importantNote,
    this.intakeDuration,
    this.medicineDose,
    this.medicineIntakeTime,
    this.toBeTaken,
  });

  Medications.fromJson(Map<String, dynamic> json) {
    medicineType = json['medicineType'];
    medicineName = json['medicineName'];
    medicineStrength = json['medicineStrength'];
    importantNote = json['importantNote'];
    intakeDuration = json['intakeDuration'];
    medicineDose = json['medicineDose'];
    medicineIntakeTime = List<String>.from(json['medicineIntakeTime'] ?? []);
    toBeTaken = json['toBeTaken'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['medicineType'] = medicineType;
    data['medicineName'] = medicineName;
    data['medicineStrength'] = medicineStrength;
    data['importantNote'] = importantNote;
    data['intakeDuration'] = intakeDuration;
    data['medicineDose'] = medicineDose;
    data['medicineIntakeTime'] = medicineIntakeTime;
    data['toBeTaken'] = toBeTaken;
    return data;
  }
}

class Appointment {
  String? sId;
  String? date;
  String? time;
  String? startTime;
  String? mode;
  String? type;
  int? uniqueId;

  Appointment({
    this.sId,
    this.date,
    this.time,
    this.startTime,
    this.mode,
    this.type,
    this.uniqueId,
  });

  Appointment.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    date = json['date'];
    time = json['time'];
    startTime = json['startTime'];
    mode = json['mode'];
    type = json['type'];
    uniqueId = json['unique_id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['_id'] = sId;
    data['date'] = date;
    data['time'] = time;
    data['startTime'] = startTime;
    data['mode'] = mode;
    data['type'] = type;
    data['unique_id'] = uniqueId;
    return data;
  }
}

class Doctor {
  String? sId;
  String? name;
  String? dob;
  String? gender;
  String? mobileNo;

  Doctor({
    this.sId,
    this.name,
    this.dob,
    this.gender,
    this.mobileNo,
  });

  Doctor.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    name = json['name'];
    dob = json['dob'];
    gender = json['gender'];
    mobileNo = json['mobile_no'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['_id'] = sId;
    data['name'] = name;
    data['dob'] = dob;
    data['gender'] = gender;
    data['mobile_no'] = mobileNo;
    return data;
  }
}
