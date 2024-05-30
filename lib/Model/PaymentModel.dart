class PaymentModel {
  String? message;
  bool? success;
  Data? data;

  PaymentModel({this.message, this.success, this.data});

  PaymentModel.fromJson(Map<String, dynamic> json) {
    message = json['message'];
    success = json['success'];
    data = json['data'] != null ? new Data.fromJson(json['data']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['message'] = this.message;
    data['success'] = this.success;
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    return data;
  }
}

class Data {
  List<String>? doctorsMethods;
  List<AdminMethods>? adminMethods;

  Data({this.doctorsMethods, this.adminMethods});

  Data.fromJson(Map<String, dynamic> json) {
    doctorsMethods = json['doctorsMethods'].cast<String>();
    if (json['adminMethods'] != null) {
      adminMethods = <AdminMethods>[];
      json['adminMethods'].forEach((v) {
        adminMethods!.add(new AdminMethods.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['doctorsMethods'] = this.doctorsMethods;
    if (this.adminMethods != null) {
      data['adminMethods'] = this.adminMethods!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class AdminMethods {
  String? name;
  int? type;
  String? partnerId;

  AdminMethods({this.name, this.type, this.partnerId});

  AdminMethods.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    type = json['type'];
    partnerId = json['partner_id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['name'] = this.name;
    data['type'] = this.type;
    data['partner_id'] = this.partnerId;
    return data;
  }
}
