class GetClinicInfoModel {
  String? message;
  bool? success;
  List<Data>? data;

  GetClinicInfoModel({this.message, this.success, this.data});

  GetClinicInfoModel.fromJson(Map<String, dynamic> json) {
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
  String? doctorId;
  String? address;
  String? addressUrl;
  String? city;
  String? country;
  String? state;
  String? zipCode;
  String? clinicId;

  Data(
      {this.doctorId,
        this.address,
        this.addressUrl,
        this.city,
        this.country,
        this.state,
        this.zipCode,
        this.clinicId});

  Data.fromJson(Map<String, dynamic> json) {
    doctorId = json['doctor_id'];
    address = json['address'];
    addressUrl = json['address_url'];
    city = json['city'];
    country = json['country'];
    state = json['state'];
    zipCode = json['zipCode'];
    clinicId = json['clinic_id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['doctor_id'] = this.doctorId;
    data['address'] = this.address;
    data['address_url'] = this.addressUrl;
    data['city'] = this.city;
    data['country'] = this.country;
    data['state'] = this.state;
    data['zipCode'] = this.zipCode;
    data['clinic_id'] = this.clinicId;
    return data;
  }
}