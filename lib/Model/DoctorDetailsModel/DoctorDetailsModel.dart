class DoctorProfileModel {
  String? message;
  bool? success;
  List<Data>? data;

  DoctorProfileModel({this.message, this.success, this.data});

  DoctorProfileModel.fromJson(Map<String, dynamic> json) {
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
  DoctorProfile? doctorProfile;
  List<Specialities>? specialities;
  List<ClinicInfo>? clinicInfo;
  Fees? fees;

  Data(
      {this.doctorId,
      this.doctorProfile,
      this.specialities,
      this.clinicInfo,
      this.fees});

  Data.fromJson(Map<String, dynamic> json) {
    doctorId = json['doctor_id'];
    doctorProfile = json['doctorProfile'] != null
        ? new DoctorProfile.fromJson(json['doctorProfile'])
        : null;
    if (json['specialities'] != null) {
      specialities = <Specialities>[];
      json['specialities'].forEach((v) {
        specialities!.add(new Specialities.fromJson(v));
      });
    }
    if (json['clinicInfo'] != null) {
      clinicInfo = <ClinicInfo>[];
      json['clinicInfo'].forEach((v) {
        clinicInfo!.add(new ClinicInfo.fromJson(v));
      });
    }
    fees = json['fees'] != null ? new Fees.fromJson(json['fees']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['doctor_id'] = this.doctorId;
    if (this.doctorProfile != null) {
      data['doctorProfile'] = this.doctorProfile!.toJson();
    }
    if (this.specialities != null) {
      data['specialities'] = this.specialities!.map((v) => v.toJson()).toList();
    }
    if (this.clinicInfo != null) {
      data['clinicInfo'] = this.clinicInfo!.map((v) => v.toJson()).toList();
    }
    if (this.fees != null) {
      data['fees'] = this.fees!.toJson();
    }
    return data;
  }
}

class DoctorProfile {
  String? name;
  String? profilePic;
  String? gender;
  String? about;
  String? mobileNo;
  dynamic experience;

  DoctorProfile(
      {this.name,
      this.profilePic,
      this.gender,
      this.about,
      this.mobileNo,
      this.experience});

  DoctorProfile.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    profilePic = json['profile_pic'];
    gender = json['gender'];
    about = json['about'];
    mobileNo = json['mobile_no'];
    experience = json['experience'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['name'] = this.name;
    data['profile_pic'] = this.profilePic;
    data['gender'] = this.gender;
    data['about'] = this.about;
    data['mobile_no'] = this.mobileNo;
    data['experience'] = this.experience;
    return data;
  }
}

class Specialities {
  dynamic specialityId;

  String? specialityName;

  Specialities({this.specialityId, this.specialityName});

  Specialities.fromJson(Map<String, dynamic> json) {
    specialityId = json['speciality_id'];
    specialityName = json['speciality_name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['speciality_id'] = this.specialityId;
    data['speciality_name'] = this.specialityName;
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
  int? offlineNewCaseFees;

  ClinicInfo(
      {this.clinicId,
      this.address,
      this.addressUrl,
      this.city,
      this.country,
      this.state,
      this.zipCode,
      this.offlineNewCaseFees});

  ClinicInfo.fromJson(Map<String, dynamic> json) {
    clinicId = json['clinic_id'];
    address = json['address'];
    addressUrl = json['address_url'];
    city = json['city'];
    country = json['country'];
    state = json['state'];
    zipCode = json['zipCode'];
    offlineNewCaseFees = json['offline_new_case_fees'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['clinic_id'] = this.clinicId;
    data['address'] = this.address;
    data['address_url'] = this.addressUrl;
    data['city'] = this.city;
    data['country'] = this.country;
    data['state'] = this.state;
    data['zipCode'] = this.zipCode;
    data['offline_new_case_fees'] = this.offlineNewCaseFees;
    return data;
  }
}

class Fees {
  int? offlineNewCaseFees;
  int? offlineOngoingCaseFees;
  int? onlineNewCaseFees;
  int? onlineOngoingCaseFees;
  List<String>? acceptedPaymentMode;

  Fees({
    this.offlineNewCaseFees,
    this.offlineOngoingCaseFees,
    this.onlineNewCaseFees,
    this.onlineOngoingCaseFees,
    this.acceptedPaymentMode,
  });

  Fees.fromJson(Map<String, dynamic> json) {
    offlineNewCaseFees = json['offline_new_case_fees'] is int
        ? json['offline_new_case_fees']
        : int.tryParse(json['offline_new_case_fees'] ?? '');
    offlineOngoingCaseFees = json['offline_ongoing_case_fees'] is int
        ? json['offline_ongoing_case_fees']
        : int.tryParse(json['offline_ongoing_case_fees'] ?? '');
    onlineNewCaseFees = json['online_new_case_fees'] is int
        ? json['online_new_case_fees']
        : int.tryParse(json['online_new_case_fees'] ?? '');
    onlineOngoingCaseFees = json['online_ongoing_case_fees'] is int
        ? json['online_ongoing_case_fees']
        : int.tryParse(json['online_ongoing_case_fees'] ?? '');
    acceptedPaymentMode = json['accepted_payment_mode']?.cast<String>();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['offline_new_case_fees'] = offlineNewCaseFees;
    data['offline_ongoing_case_fees'] = offlineOngoingCaseFees;
    data['online_new_case_fees'] = onlineNewCaseFees;
    data['online_ongoing_case_fees'] = onlineOngoingCaseFees;
    data['accepted_payment_mode'] = acceptedPaymentMode;
    return data;
  }
}
