class GetReportsModel {
  String? message;
  List<Data>? data;
  bool? success;

  GetReportsModel({this.message, this.data, this.success});

  GetReportsModel.fromJson(Map<String, dynamic> json) {
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
  String? sId;
  List<Reports>? reports;

  Data({this.sId, this.reports});

  Data.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    if (json['reports'] != null) {
      reports = <Reports>[];
      json['reports'].forEach((v) {
        reports!.add(new Reports.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['_id'] = this.sId;
    if (this.reports != null) {
      data['reports'] = this.reports!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Reports {
  String? reportId;
  String? reportName;
  String? reportUrl;
  String? createdAt;
  String? patientName;
  String? reportDate;
  bool? isChecked;

  Reports({
    this.reportId,
    this.reportName,
    this.reportUrl,
    this.createdAt,
    this.patientName,
    this.reportDate,
    this.isChecked,
  });

  Reports.fromJson(Map<String, dynamic> json) {
    reportId = json['report__id'];
    reportName = json['reportName'];
    reportUrl = json['reportUrl'];
    createdAt = json['createdAt'];
    patientName = json['patientName'];
    reportDate = json['reportDate'];
    isChecked = false;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['report__id'] = this.reportId;
    data['reportName'] = this.reportName;
    data['reportUrl'] = this.reportUrl;
    data['createdAt'] = this.createdAt;
    data['patientName'] = this.patientName;
    data['reportDate'] = this.reportDate;
    return data;
  }
}
