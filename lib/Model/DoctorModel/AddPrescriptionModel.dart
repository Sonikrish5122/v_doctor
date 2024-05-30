class AddPrescriptionModel {
  String? message;
  List<Data>? data;
  bool? success;

  AddPrescriptionModel({this.message, this.data, this.success});

  AddPrescriptionModel.fromJson(Map<String, dynamic> json) {
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
  Null? testReports;
  int? uniqueId;
  String? prescriptionId;

  Data(
      {this.medications, this.testReports, this.uniqueId, this.prescriptionId});

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
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.medications != null) {
      data['medications'] = this.medications!.map((v) => v.toJson()).toList();
    }
    data['testReports'] = this.testReports;
    data['unique_id'] = this.uniqueId;
    data['prescription_id'] = this.prescriptionId;
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
  List<String>? testReports;

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
    testReports = json['testReports'].cast<String>();
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
    data['testReports'] = this.testReports;
    return data;
  }
}