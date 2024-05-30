class UpdateProfileDataModel {
  String? message;
  bool? success;
  List<Data>? data;

  UpdateProfileDataModel({this.message, this.success, this.data});

  UpdateProfileDataModel.fromJson(Map<String, dynamic> json) {
    message = json['message'];
    success = json['success'];
    if (json['data'] != null) {
      data = (json['data'] as List)
          .map((item) => Data.fromJson(item))
          .toList();
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['message'] = this.message;
    data['success'] = this.success;
    if (this.data != null) {
      data['data'] = this.data!.map((item) => item.toJson()).toList();
    }
    return data;
  }
}

class Data {
  String? patientId;
  String? dob;
  String? gender;
  bool? isDelete;
  String? mobileNo;
  String? name;
  String? profilePic;

  Data({
    this.patientId,
    this.dob,
    this.gender,
    this.isDelete,
    this.mobileNo,
    this.name,
    this.profilePic,
  });

  Data.fromJson(Map<String, dynamic> json) {
    patientId = json['patient_id'];
    dob = json['dob'];
    gender = json['gender'];
    isDelete = json['is_delete'];
    mobileNo = json['mobile_no'];
    name = json['name'];
    profilePic = json['profile_pic'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['patient_id'] = this.patientId;
    data['dob'] = this.dob;
    data['gender'] = this.gender;
    data['is_delete'] = this.isDelete;
    data['mobile_no'] = this.mobileNo;
    data['name'] = this.name;
    data['profile_pic'] = this.profilePic;
    return data;
  }
}
