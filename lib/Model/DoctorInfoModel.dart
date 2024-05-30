class DoctorInfoModel {
  DoctorProfile doctorProfile;
  List<Speciality> speciality;
  List<Degree> degrees;
  ClinicInfo clinicInfo;
  List<Map<String, dynamic>> availability;
  Fees fees;

  DoctorInfoModel({
    required this.doctorProfile,
    required this.speciality,
    required this.degrees,
    required this.clinicInfo,
    required this.availability,
    required this.fees,
  });

  factory DoctorInfoModel.fromJson(Map<String, dynamic> json) {
    return DoctorInfoModel(
      doctorProfile: DoctorProfile.fromJson(json['doctorProfile']),
      speciality: List<Speciality>.from(
          json['speciality'].map((x) => Speciality.fromJson(x))),
      degrees:
          List<Degree>.from(json['degrees'].map((x) => Degree.fromJson(x))),
      clinicInfo: ClinicInfo.fromJson(json['clinicInfo']),
      availability: _parseAvailability(json['availability']),
      fees: Fees.fromJson(json['fees']),
    );
  }

  static List<Map<String, dynamic>> _parseAvailability(
      dynamic jsonAvailability) {
    if (jsonAvailability is List) {
      return List<Map<String, dynamic>>.from(jsonAvailability);
    } else if (jsonAvailability is Map<String, dynamic>) {
      return [jsonAvailability];
    } else {
      return [];
    }
  }
}

class DoctorProfile {
  String? sId;
  String? doctorId;
  String? profilePic;
  String? name;
  String? dob;
  String? gender;
  String? about;
  String? mobileNo;
  dynamic experience;
  String? email;

  DoctorProfile(
      {this.sId,
      this.doctorId,
      this.profilePic,
      this.name,
      this.dob,
      this.gender,
      this.about,
      this.mobileNo,
      this.experience,
      this.email});

  DoctorProfile.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    doctorId = json['doctor_id'];
    profilePic = json['profile_pic'];
    name = json['name'];
    dob = json['dob'];
    gender = json['gender'];
    about = json['about'];
    mobileNo = json['mobile_no'];
    experience = json['experience'];
    email = json['email'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['_id'] = this.sId;
    data['doctor_id'] = this.doctorId;
    data['profile_pic'] = this.profilePic;
    data['name'] = this.name;
    data['dob'] = this.dob;
    data['gender'] = this.gender;
    data['about'] = this.about;
    data['mobile_no'] = this.mobileNo;
    data['experience'] = this.experience;
    data['email'] = this.email;
    return data;
  }
}

class Speciality {
  String? specialityId;
  String? specialityName;

  Speciality({this.specialityId, this.specialityName});

  Speciality.fromJson(Map<String, dynamic> json) {
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

class Degree {
  String degreeId;
  String degreeName;

  Degree({
    required this.degreeId,
    required this.degreeName,
  });

  factory Degree.fromJson(Map<String, dynamic> json) {
    return Degree(
      degreeId: json['degree_id'],
      degreeName: json['degree_name'],
    );
  }
}

class ClinicInfo {
  String? doctorId;
  String? address;
  String? addressUrl;
  String? city;
  String? country;
  String? state;
  String? zipCode;
  String? clinicId;

  ClinicInfo(
      {this.doctorId,
      this.address,
      this.addressUrl,
      this.city,
      this.country,
      this.state,
      this.zipCode,
      this.clinicId});

  ClinicInfo.fromJson(Map<String, dynamic> json) {
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

class Availability {
  String? day;
  bool? isAvailable;
  String? startTime;
  String? endTime;

  Availability({this.day, this.isAvailable, this.startTime, this.endTime});

  Availability.fromJson(Map<String, dynamic> json) {
    day = json['day'];
    isAvailable = json['isAvailable'];
    startTime = json['startTime'];
    endTime = json['endTime'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['day'] = this.day;
    data['isAvailable'] = this.isAvailable;
    data['startTime'] = this.startTime;
    data['endTime'] = this.endTime;
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
