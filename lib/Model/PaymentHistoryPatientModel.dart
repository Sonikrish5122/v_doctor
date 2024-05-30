class PaymentHistoryPatientModel {
  String? message;
  List<Data>? data;
  bool? success;

  PaymentHistoryPatientModel({this.message, this.data, this.success});

  PaymentHistoryPatientModel.fromJson(Map<String, dynamic> json) {
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
  String? paidUsing;
  int? amount;
  String? paidOn;
  String? status;

  Data(
      {this.appointmentId,
        this.paidUsing,
        this.amount,
        this.paidOn,
        this.status});

  Data.fromJson(Map<String, dynamic> json) {
    appointmentId = json['appointment_id'];
    paidUsing = json['paidUsing'];
    amount = json['amount'];
    paidOn = json['paidOn'];
    status = json['status'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['appointment_id'] = this.appointmentId;
    data['paidUsing'] = this.paidUsing;
    data['amount'] = this.amount;
    data['paidOn'] = this.paidOn;
    data['status'] = this.status;
    return data;
  }
}