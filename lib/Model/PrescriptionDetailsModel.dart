class PrescriptionDetailsModel {
  String? message;
  List<Data>? data;
  bool? success;

  PrescriptionDetailsModel({this.message, this.data, this.success});

  PrescriptionDetailsModel.fromJson(Map<String, dynamic> json) {
    message = json['message'];
    if (json['data'] != null) {
      data = <Data>[];
      json['data'].forEach((v) {
        data!.add(new Data.fromJson(v));
      });
    }
    success = json['success'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['message'] = this.message;
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    data['success'] = this.success;
    return data;
  }
}

class Data {
  List<Medications>? medications;
  dynamic testReports;
  int? uniqueId;
  String? prescriptionId;
  Appointment? appointment;
  Doctor? doctor;
  Patient? patient;

  Data(
      {this.medications,
        this.testReports,
        this.uniqueId,
        this.prescriptionId,
        this.appointment,
        this.doctor,
        this.patient});

  Data.fromJson(Map<String, dynamic> json) {
    if (json['medications'] != null) {
      medications = <Medications>[];
      json['medications'].forEach((v) {
        medications!.add(new Medications.fromJson(v));
      });
    }
    testReports = json['testReports'];
    uniqueId = json['unique_id'];
    prescriptionId = json['prescription_id'];
    appointment = json['appointment'] != null
        ? new Appointment.fromJson(json['appointment'])
        : null;
    doctor =
    json['doctor'] != null ? new Doctor.fromJson(json['doctor']) : null;
    patient =
    json['patient'] != null ? new Patient.fromJson(json['patient']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.medications != null) {
      data['medications'] = this.medications!.map((v) => v.toJson()).toList();
    }
    data['testReports'] = this.testReports;
    data['unique_id'] = this.uniqueId;
    data['prescription_id'] = this.prescriptionId;
    if (this.appointment != null) {
      data['appointment'] = this.appointment!.toJson();
    }
    if (this.doctor != null) {
      data['doctor'] = this.doctor!.toJson();
    }
    if (this.patient != null) {
      data['patient'] = this.patient!.toJson();
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
  List<dynamic>? testReports;

  Medications(
      {this.medicineType,
        this.medicineName,
        this.medicineStrength,
        this.importantNote,
        this.intakeDuration,
        this.medicineDose,
        this.medicineIntakeTime,
        this.toBeTaken,
        this.testReports});

  Medications.fromJson(Map<String, dynamic> json) {
    medicineType = json['medicineType'];
    medicineName = json['medicineName'];
    medicineStrength = json['medicineStrength'];
    importantNote = json['importantNote'];
    intakeDuration = json['intakeDuration'];
    medicineDose = json['medicineDose'];
    medicineIntakeTime = json['medicineIntakeTime'].cast<String>();
    toBeTaken = json['toBeTaken'];
    if (json['testReports'] != null) {
      testReports = <dynamic>[];
      json['testReports'].forEach((v) {
        testReports!.add(v);
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['medicineType'] = this.medicineType;
    data['medicineName'] = this.medicineName;
    data['medicineStrength'] = this.medicineStrength;
    data['importantNote'] = this.importantNote;
    data['intakeDuration'] = this.intakeDuration;
    data['medicineDose'] = this.medicineDose;
    data['medicineIntakeTime'] = this.medicineIntakeTime;
    data['toBeTaken'] = this.toBeTaken;
    if (this.testReports != null) {
      data['testReports'] = this.testReports!.map((v) => v).toList();
    }
    return data;
  }
}

class Appointment {
  String? sId;
  String? date;
  String? time;
  String? mode;
  String? type;

  Appointment({this.sId, this.date, this.time, this.mode, this.type});

  Appointment.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    date = json['date'];
    time = json['time'];
    mode = json['mode'];
    type = json['type'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['_id'] = this.sId;
    data['date'] = this.date;
    data['time'] = this.time;
    data['mode'] = this.mode;
    data['type'] = this.type;
    return data;
  }
}

class Doctor {
  String? sId;
  String? name;
  String? dob;
  String? mobileNo;
  int? experience;

  Doctor({this.sId, this.name, this.dob, this.mobileNo, this.experience});

  Doctor.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    name = json['name'];
    dob = json['dob'];
    mobileNo = json['mobile_no'];
    experience = json['experience'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['_id'] = this.sId;
    data['name'] = this.name;
    data['dob'] = this.dob;
    data['mobile_no'] = this.mobileNo;
    data['experience'] = this.experience;
    return data;
  }
}

class Patient {
  String? sId;
  String? dob;
  String? gender;
  String? mobileNo;
  String? name;
  String? profilePic;

  Patient(
      {this.sId,
        this.dob,
        this.gender,
        this.mobileNo,
        this.name,
        this.profilePic});

  Patient.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    dob = json['dob'];
    gender = json['gender'];
    mobileNo = json['mobile_no'];
    name = json['name'];
    profilePic = json['profile_pic'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['_id'] = this.sId;
    data['dob'] = this.dob;
    data['gender'] = this.gender;
    data['mobile_no'] = this.mobileNo;
    data['name'] = this.name;
    data['profile_pic'] = this.profilePic;
    return data;
  }
}
