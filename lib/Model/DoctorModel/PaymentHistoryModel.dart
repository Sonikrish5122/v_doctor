class PaymentHistoryModel {
  String? message;
  List<Data>? data;
  bool? success;

  PaymentHistoryModel({this.message, this.data, this.success});

  PaymentHistoryModel.fromJson(Map<String, dynamic> json) {
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
  String? appointmentId;
  String? doctorId;
  String? patientId;
  String? paidUsing;
  int? platformFees;
  int? appointmentFees;
  double? amount;
  String? paidOn;
  String? status;

  Data(
      {this.appointmentId,
        this.doctorId,
        this.patientId,
        this.paidUsing,
        this.platformFees,
        this.appointmentFees,
        this.amount,
        this.paidOn,
        this.status});

  Data.fromJson(Map<String, dynamic> json) {
    appointmentId = json['appointment_id'];
    doctorId = json['doctor_id'];
    patientId = json['patient_id'];
    paidUsing = json['paidUsing'];
    platformFees = json['platform_fees'];
    appointmentFees = json['appointment_fees'];
    amount = json['amount'];
    paidOn = json['paidOn'];
    status = json['status'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['appointment_id'] = this.appointmentId;
    data['doctor_id'] = this.doctorId;
    data['patient_id'] = this.patientId;
    data['paidUsing'] = this.paidUsing;
    data['platform_fees'] = this.platformFees;
    data['appointment_fees'] = this.appointmentFees;
    data['amount'] = this.amount;
    data['paidOn'] = this.paidOn;
    data['status'] = this.status;
    return data;
  }
}