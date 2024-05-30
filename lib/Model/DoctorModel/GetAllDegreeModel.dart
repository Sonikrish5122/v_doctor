class GetAllDegreeModel {
  String? message;
  List<DegreeData>? data;
  bool? success;

  GetAllDegreeModel({this.message, this.data, this.success});

  GetAllDegreeModel.fromJson(Map<String, dynamic> json) {
    message = json['message'];
    if (json['data'] != null) {
      data = <DegreeData>[];
      json['data'].forEach((v) {
        data!.add(new DegreeData.fromJson(v));
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

class DegreeData {
  String? sId;
  String? degreeName; // Adding degreeName property

  DegreeData({this.sId, this.degreeName});

  DegreeData.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    degreeName = json['degree_name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['_id'] = this.sId;
    data['degree_name'] = this.degreeName;
    return data;
  }
}
