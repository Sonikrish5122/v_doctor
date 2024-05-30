class FeesStructureModel {
  String? message;
  bool? success;
  List<Data>? data;

  FeesStructureModel({this.message, this.success, this.data});

  FeesStructureModel.fromJson(Map<String, dynamic> json) {
    message = json['message'];
    success = json['success'];
    if (json['data'] != null) {
      data = <Data>[];
      json['data'].forEach((v) {
        data!.add(new Data.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['message'] = this.message;
    data['success'] = this.success;
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Data {
  List<String>? acceptedPaymentMode;
  String? offlineNewCaseFees;
  String? offlineOngoingCaseFees;
  String? onlineNewCaseFees;
  String? onlineOngoingCaseFees;

  Data({
    this.acceptedPaymentMode,
    this.offlineNewCaseFees,
    this.offlineOngoingCaseFees,
    this.onlineNewCaseFees,
    this.onlineOngoingCaseFees,
  });

  Data.fromJson(Map<String, dynamic> json) {
    acceptedPaymentMode = List<String>.from(json['accepted_payment_mode']);
    offlineNewCaseFees = json['offline_new_case_fees'];
    offlineOngoingCaseFees = json['offline_ongoing_case_fees'];
    onlineNewCaseFees = json['online_new_case_fees'];
    onlineOngoingCaseFees = json['online_ongoing_case_fees'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['accepted_payment_mode'] = this.acceptedPaymentMode;
    data['offline_new_case_fees'] = this.offlineNewCaseFees;
    data['offline_ongoing_case_fees'] = this.offlineOngoingCaseFees;
    data['online_new_case_fees'] = this.onlineNewCaseFees;
    data['online_ongoing_case_fees'] = this.onlineOngoingCaseFees;
    return data;
  }
}
