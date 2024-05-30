class DoctorDetailsModel {
  String? message;
  bool? success;
  List<Data>? data;

  DoctorDetailsModel({this.message, this.success, this.data});

  DoctorDetailsModel.fromJson(Map<String, dynamic> json) {
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
  String? profilePic;
  String? name;
  String? dob;
  String? gender;
  String? about;
  String? mobileNo;
  int? experience;
  Null? email;
  List<Specialities>? specialities;
  List<Degrees>? degrees;

  Data(
      {this.doctorId,
      this.profilePic,
      this.name,
      this.dob,
      this.gender,
      this.about,
      this.mobileNo,
      this.experience,
      this.email,
      this.specialities,
      this.degrees});

  Data.fromJson(Map<String, dynamic> json) {
    doctorId = json['doctor_id'];
    profilePic = json['profile_pic'];
    name = json['name'];
    dob = json['dob'];
    gender = json['gender'];
    about = json['about'];
    mobileNo = json['mobile_no'];
    experience = json['experience'];
    email = json['email'];
    if (json['specialities'] != null) {
      specialities = <Specialities>[];
      json['specialities'].forEach((v) {
        specialities!.add(new Specialities.fromJson(v));
      });
    }
    if (json['degrees'] != null) {
      degrees = <Degrees>[];
      json['degrees'].forEach((v) {
        degrees!.add(new Degrees.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['doctor_id'] = this.doctorId;
    data['profile_pic'] = this.profilePic;
    data['name'] = this.name;
    data['dob'] = this.dob;
    data['gender'] = this.gender;
    data['about'] = this.about;
    data['mobile_no'] = this.mobileNo;
    data['experience'] = this.experience;
    data['email'] = this.email;
    if (this.specialities != null) {
      data['specialities'] = this.specialities!.map((v) => v.toJson()).toList();
    }
    if (this.degrees != null) {
      data['degrees'] = this.degrees!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Specialities {
  String? specialityId;
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

class Degrees {
  String? degreeId;
  String? degreeName;

  Degrees({this.degreeId, this.degreeName});

  Degrees.fromJson(Map<String, dynamic> json) {
    degreeId = json['degree_id'];
    degreeName = json['degree_name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['degree_id'] = this.degreeId;
    data['degree_name'] = this.degreeName;
    return data;
  }
}
