class SpecialityModel {
  String? message;
  List<SpecialityData>? data;
  bool? success;

  SpecialityModel({this.message, this.data, this.success});

  SpecialityModel.fromJson(Map<String, dynamic> json) {
    message = json['message'];
    if (json['data'] != null) {
      data = <SpecialityData>[];
      json['data'].forEach((v) {
        data!.add(SpecialityData.fromJson(v));
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

class SpecialityData {
  String? sId;
  String? specialityName;

  SpecialityData({this.sId, this.specialityName, required doctorProfile});

  SpecialityData.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    specialityName = json['speciality_name']; // Check this line
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['_id'] = this.sId;
    data['speciality_name'] = this.specialityName; // Check this line
    return data;
  }
}
